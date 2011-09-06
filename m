Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1IFEf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 00:35:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59423 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1IFEfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 00:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <1315096661.23425.YahooMailClassic@web29510.mail.ird.yahoo.com>
References: <CAG1a4rscDrbiCKxSPvbkG7SutQ5HCU2tX9FJEv81nFuVxLWekg@mail.gmail.com>
 <1315096661.23425.YahooMailClassic@web29510.mail.ird.yahoo.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Tue, 6 Sep 2011 00:35:22 -0400
Message-ID: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Christoph Hellwig <hch@tuxera.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 3, 2011 at 8:37 PM, Hin-Tak Leung <hintak_leung@yahoo.co.uk> wrote:
>> I've looked into the code myself a little and here's what I
>> see.
>> hfsplus_read_wrapper() calls to hfsplus_submit_bio() twice
>> to fill
>> sbi->s_vhdr and sbi->s_backup_vhdr. And according to
>> parameters they
>> are filled with pointers into sbi->s_vhdr_buf and
>> sbi->s_backup_vhdr_buf respectively. It's done with the
>> following code
>> at fs/hfsplus/wrapper.c:79:
>>
>>     if (!(rw & WRITE) && data)
>>         *data = (u8 *)buf +
>> offset;
>>
>> So s_vhdr and s_backup_vhdr shouldn't be freed, s_vhdr_buf
>> and
>> s_backup_vhdr_buf should be freed instead. And indeed
>> changing in
>> hfsplus_fill_super()
>>
>>     kfree(sbi->s_vhdr);
>>     kfree(sbi->s_backup_vhdr);
>>
>> to
>>
>>     kfree(sbi->s_vhdr_buf);
>>     kfree(sbi->s_backup_vhdr_buf);
>>
>> fixes BUG reports from SLUB.
>
> The code around there is a bit too dense, and both of the *_buf are recent introductions (and temp values, I think) as is hfsplus_submit_bio() itself, around the 2.6.39/3.0 time frame. I think the intention is to fill s_vhdr/s_backup_vhdr via mulitple fetches using *_buf as temp buffer.

Well, look at the commit 6596528e. It clearly shows that result of
kmalloc() is no longer assigned to sbi->s_vhdr and sbi->s_backup_vhdr,
but is assigned to sbi->s_vhdr_buf and sbi->s_backup_vhdr_buf. Also
this commit clearly changes hfsplus_put_super() so that it doesn't
free sbi->s_vhdr and sbi->s_backup_vhdr, but frees sbi->s_vhdr_buf and
sbi->s_backup_vhdr_buf instead. I guess Seth just missed
hfsplus_fill_super() in there as it's pretty unusual exit path.

>> Now, the problem with "too large" error is trickier.
>> According to this message
>>
>> >> [   92.549197] hfs: filesystem size too large
>> blksz_shift=14, total_blocks=486494
>>
>> HFS thinks that my iPod has block size of 16 KiB. But
>> generic_check_addressable() decides that everything with
>> blocks larger
>> than PAGE_CACHE_SHIFT (i.e. 4 KiB on my system) cannot be
>> addressable
>> and thus filesystem cannot be mounted. I guess it wasn't
>> supposed to
>> be that way. Is hfsplus_read_wrapper() wrong in determining
>> block size
>> or all iPods where this was tested actually had block size
>> 4 KiB or
>> less?
>
> Your logical sector size is 4k according to dmesg and hfs block size is 512 so that 16KiB is a bit dodgy.

I'm not sure where that "logical sector size" of 4k comes from but
according to the sources 16K is taken directly from iPod via vhdr in
hfsplus_read_wrapper(). And apparently all hfsplus code is designed to
work with blocks larger than PAGE_SIZE. So it's just
generic_check_addressable() that stands in the way. Maybe commit
c6d5f5fa wasn't quite well thought through or tested by Christoph?
Anyway the following patch worked for me and I've got my iPod mounted
and navigateable (although only in read-only mode because it has
journaled filesystem).

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index c106ca2..5458be4 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -345,6 +345,8 @@ static int hfsplus_fill_super(struct super_block
*sb, void *data, int silent)
 	struct qstr str;
 	struct nls_table *nls = NULL;
 	int err;
+	unsigned check_blksz_bits;
+	u64 check_num_blocks;

 	err = -EINVAL;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
@@ -399,10 +401,15 @@ static int hfsplus_fill_super(struct super_block
*sb, void *data, int silent)
 	if (!sbi->rsrc_clump_blocks)
 		sbi->rsrc_clump_blocks = 1;

-	err = generic_check_addressable(sbi->alloc_blksz_shift,
-					sbi->total_blocks);
+	check_blksz_bits = sbi->alloc_blksz_shift;
+	check_num_blocks = sbi->total_blocks;
+	if (sbi->fs_shift != 0) {
+		check_num_blocks <<= sbi->fs_shift;
+		check_blksz_bits -= sbi->fs_shift;
+	}
+	err = generic_check_addressable(check_blksz_bits, check_num_blocks);
 	if (err) {
		printk(KERN_ERR "hfs: filesystem size too large.\n");
 		goto out_free_vhdr;


I can format and submit both patches (plus a small cleanup that I felt
is needed to be changed along the way). Tell me what you think.


Pavel
