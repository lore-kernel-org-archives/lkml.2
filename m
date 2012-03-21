Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2CUFhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:37:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48182 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2CUFhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:37:37 -0400
Date: Wed, 21 Mar 2012 05:37:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux-sh <linux-sh@vger.kernel.org>,
        Adrian McMenamin <adrianmcmenamin@gmail.com>
Subject: Re: [PATCH] VMUFAT filesystem [2/4]
Message-ID: <20120321053735.GO6589@ZenIV.linux.org.uk>
References: <CAN628AE8gytYTE3eGDYrKR9Vx4JnND+OGzHcfneCb4q-QUM6cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN628AE8gytYTE3eGDYrKR9Vx4JnND+OGzHcfneCb4q-QUM6cA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 12:32:59PM +0800, Adrian McMenamin wrote:
> +static struct dentry *vmufat_inode_lookup(struct inode *in, struct
> dentry *dent,
> +	struct nameidata *ignored)
> +{
> +	struct super_block *sb;
> +	struct memcard *vmudetails;
> +	struct buffer_head *bufhead = NULL;
> +	struct inode *ino;
> +	char name[VMUFAT_NAMELEN];
> +	int i, j, error = -EINVAL;

> +	if (!dent || !in || !in->i_sb)
> +		goto out;
Huh?  It is ->lookup(), isn't it?  Then none of the above can happen...

> +	if (dent->d_name.len > VMUFAT_NAMELEN) {
> +		error = -ENAMETOOLONG;
> +		goto out;
> +	}
> +	sb = in->i_sb;
> +	if (!sb->s_fs_info)
> +		goto out;

Is it possible?

> +	vmudetails = sb->s_fs_info;
> +	error = 0;
> +
> +	for (i = vmudetails->dir_bnum;
> +		i > vmudetails->dir_bnum - vmudetails->dir_len; i--) {
> +		brelse(bufhead);
> +		bufhead = vmufat_sb_bread(sb, i);
> +		if (!bufhead) {
> +			error = -EIO;
> +			goto out;
> +		}
> +		for (j = 0; j < VMU_DIR_ENTRIES_PER_BLOCK; j++) {
> +			if (bufhead->b_data[j * VMU_DIR_RECORD_LEN] == 0)
> +				goto fail;
Two words: local variables.  Like something that would store
bufhead->b_data + j * VMU_DIR_RECORD_LEN instead of copying that expression
again and again...

> +			/* get name and check for match */
> +			memcpy(name,
> +				bufhead->b_data + j * VMU_DIR_RECORD_LEN
> +				+ VMUFAT_NAME_OFFSET, VMUFAT_NAMELEN);
> +			if (memcmp(dent->d_name.name, name,

What's the point of that name array, while we are at it?  You've copied into
it, then compared the copy with ->d_name.name contents and never used that
copy again.  Why bother copying at all, when comparison with the original
would obviously work just as well?

> +				dent->d_name.len) == 0) {
> +				ino = vmufat_get_inode(sb,
> +					le16_to_cpu(((u16 *) bufhead->b_data)
> +					[j * VMU_DIR_RECORD_LEN16
> +					+ VMUFAT_FIRSTBLOCK_OFFSET16]));
> +				if (IS_ERR_OR_NULL(ino)) {
> +					if (IS_ERR(ino))
> +						error = PTR_ERR(ino);
> +					else
> +						error = -EACCES;
> +					goto out;
> +				}
Please, explain that one.

> +				d_add(dent, ino);
> +				goto out;
> +			}
> +		}
> +	}
> +fail:
> +	d_add(dent, NULL); /* Did not find the file */
> +out:
> +	brelse(bufhead);
> +	return ERR_PTR(error);
> +}

> +static int vmufat_find_free(struct super_block *sb)
> +{
> +	struct memcard *vmudetails;
> +	int found = 0, testblk, fatblk, error, index_to_fat;
> +	int diff;
> +	__le16 fatdata;
> +	struct buffer_head *bh_fat;
> +
> +	if (!sb || !sb->s_fs_info) {

Again, can that really happen?  The same goes for all subsequent functions
where you do that...  Defensive programming of that kind is almost always
wrong - it obfuscates the code and make finding bugs harder.  Please, don't
do that kind of stuff.

> +	for (fatblk = vmudetails->fat_bnum;
> +		fatblk > vmudetails->fat_bnum - vmudetails->fat_len;
> +		fatblk--) {
> +		bh_fat = vmufat_sb_bread(sb, fatblk);
> +		if (!bh_fat) {
> +			error = -EIO;
> +			goto fail;
> +		}
> +
> +		index_to_fat = 0xFF;
> +		/* prefer not to allocate to higher blocks if we can
> +		 * to ensure full compatibility with Dreamcast devices */
> +		diff = index_to_fat - VMUFAT_START_ALLOC;
> +		for (testblk = index_to_fat; testblk > 0; testblk--) {
> +			if (diff > 0 && testblk - diff < 0)
> +				diff = -VMUFAT_START_ALLOC - 1;

l-k != IOCCC.  This is way too convoluted for its own good - what you
are trying to do is
	__le16 *p = bh_fat->b_data;
	for (i = VMUFAT_START_ALLOC; i >= 0; i--) {
		if (p[i] == cpu_to_le16(VMUFAT_UNALLOCATED)) {
			put_bh(bh_fat);
			return i + <whatever>;
		}
	}
	for (i = 0xff; i > VMUFAT_START_ALLOC; i--) {
		if (p[i] == cpu_to_le16(VMUFAT_UNALLOCATED)) {
			put_bh(bh_fat);
			return i + <whatever>;
		}
	}
	put_bh(bh_fat);

with this <whatever> (i.e.
(fatblk - 1 - vmudetails->fat_bnum + vmudetails->fat_len) * VMU_BLK_SZ16
) IMO begging to be in a local variable as well.

> +out_of_loop:
> +	return (fatblk - 1 - vmudetails->fat_bnum + vmudetails->fat_len)
> +			* VMU_BLK_SZ16 + testblk - diff;
> +
> +	printk(KERN_WARNING "VMUFAT: volume is full\n");

Huh?  How are we going to get here?

> +	/* Executable files must be at the start of the volume */
> +	if (imode & EXEC) {

Huh?  If you mean S_IXUGO, please say so.

> +		in->i_ino = VMUFAT_ZEROBLOCK;
> +		if (vmufat_get_fat(sb, 0) != VMUFAT_UNALLOCATED) {
> +			printk(KERN_WARNING "VMUFAT: cannot write excutable "
> +				"file. Volume block 0 already allocated.\n");

Umm...  So one can trigger KERN_WARNING printk by normal syscalls?

> +static void vmu_handle_zeroblock(int recno, struct buffer_head *bh, int ino)
> +{
> +	/* offset and header offset settings */
> +	if (ino != VMUFAT_ZEROBLOCK) {
> +		((u16 *) bh->b_data)[recno + VMUFAT_START_OFFSET16] =
> +		    cpu_to_le16(ino);
> +		((u16 *) bh->b_data)[recno + VMUFAT_HEADER_OFFSET16] = 0;
> +	} else {
> +		((u16 *) bh->b_data)[recno + VMUFAT_START_OFFSET16] = 0;
> +		((u16 *) bh->b_data)[recno + VMUFAT_HEADER_OFFSET16] = 1;

That smells very fishy - what happens on big-endian here?

> +static int vmufat_inode_create(struct inode *dir, struct dentry *de,
> +		umode_t imode, struct nameidata *nd)

> +	if (de->d_name.len > VMUFAT_NAMELEN) {

How would such a dentry arrive here?  It would have to survive ->lookup()
first, after all...

> +	down_interruptible(&vmudetails->vmu_sem);

The point of down_interruptible() is that we allow signals to interrupt us
while we are waiting for that semaphore.  Doesn't your code want to know
if we got the damn semaphore, after all?  The same goes for all subsequent
uses of that thing.

> +	vmudetails = sb->s_fs_info;
> +	if (!vmudetails)
> +		goto out;
> +	error = 0;
> +
> +	index = filp->f_pos;
> +	if (index > 200)
> +		return -EIO;

So lseek() past the end of directory => -EIO on readdir()?
