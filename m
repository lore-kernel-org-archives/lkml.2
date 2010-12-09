Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab0LINPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:15:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54184 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab0LINO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:14:58 -0500
Date: Thu, 9 Dec 2010 14:14:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
Message-ID: <20101209131452.GA2260@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jim Keniston <jkenisto@linux.vnet.ibm.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <AANLkTin7xDWO8fU2WA7cxC55TNi2+kAb50ajCySCfg9G@mail.gmail.com>
 <4d00164c296166b682@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4d00164c296166b682@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:35:40PM -0800, Luck, Tony wrote:
> > > what happens if it IS_ERR?
> > 
> > Good point - I need to clean up if things fail (and akpm would
> > like to see me re-factor so that there is only one "return"
> > statement for better maintainabiliy).  I'll fix up stuff here.
> 
> Here's what I'll have in the next version. With all the error
> handling the pstore_mkfile() routine was getting a bit big, so
> I split out the writing-to-the-file part into another function.
> The pair of functions now look like this:
> 
> /*
>  * Set up a file structure as if we had opened this file and
>  * write our data to it.
>  */
> static int pstore_writefile(struct inode *inode, struct dentry *dentry,
> 	char *data, size_t size)
> {
> 	struct file f;
> 	ssize_t n;
> 	mm_segment_t old_fs = get_fs();
> 
> 	memset(&f, '0', sizeof f);
> 	f.f_mapping = inode->i_mapping;
> 	f.f_path.dentry = dentry;
> 	f.f_path.mnt = pstore_mnt;
> 	f.f_pos = 0;
> 	f.f_op = inode->i_fop;
> 	set_fs(KERNEL_DS);
> 	n = do_sync_write(&f, data, size, &f.f_pos);
> 	set_fs(old_fs);
> 
> 	return n == size;
> }

Good.

> 
> /*
>  * Make a regular file in the root directory of our file system.
>  * Load it up with "size" bytes of data from "buf".
>  * Set the mtime & ctime to the date that this record was originally stored.
>  */
> int pstore_mkfile(char *name, char *data, size_t size, struct timespec time,
> 		  void *private)
> {
> 	struct dentry	*root = pstore_sb->s_root;
> 	struct dentry	*dentry;
> 	struct inode	*inode;
> 	int		rc = 0;
> 
> 	inode = pstore_get_inode(pstore_sb, root->d_inode, S_IFREG | 0444, 0);
> 	if (!inode) {
> 		rc = -ENOMEM;
> 		goto fail;
> 	}
> 	inode->i_private = private;
> 
> 	mutex_lock(&root->d_inode->i_mutex);
> 
> 	dentry = d_alloc_name(root, name);
> 	if (IS_ERR(dentry)) {
> 		mutex_unlock(&root->d_inode->i_mutex);
> 		rc = -ENOSPC;
> 		goto fail1;
> 	}
> 
> 	d_add(dentry, inode);
> 
> 	mutex_unlock(&root->d_inode->i_mutex);
> 
> 	if (!pstore_writefile(inode, dentry, data, size)) {
> 		inode->i_nlink--;
> 		mutex_lock(&root->d_inode->i_mutex);
> 		d_delete(dentry);
> 		dput(dentry);
> 		mutex_unlock(&root->d_inode->i_mutex);
> 		rc = -ENOSPC;
> 		goto fail;
> 	}

don't we have to iput() the inode here too if pstore_writefile() fails?

> 
> 	if (time.tv_sec)
> 		inode->i_mtime = inode->i_ctime = time;
> 
> 	return 0;
> 
> fail1:
> 	iput(inode);
> fail:
> 	return rc;
> }

So this version is ok. However, I'd go and move the error paths to
labels near the end of the function since this makes the main part of
what it does more readable, IMHO. IOW, something like this (untested, of
course):

int pstore_mkfile(char *name, char *data, size_t size, struct timespec time,
                  void *private)
{
        struct dentry   *root = pstore_sb->s_root;
        struct dentry   *dentry;
        struct inode    *inode;
        int             rc;

	rc = -ENOMEM;
        inode = pstore_get_inode(pstore_sb, root->d_inode, S_IFREG | 0444, 0);
        if (!inode)
                goto fail;

        inode->i_private = private;

        mutex_lock(&root->d_inode->i_mutex);

	rc = -ENOSPC;
        dentry = d_alloc_name(root, name);
        if (IS_ERR(dentry))
                goto fail_alloc;

        d_add(dentry, inode);

        mutex_unlock(&root->d_inode->i_mutex);

        if (!pstore_writefile(inode, dentry, data, size))
		goto fail_write;

        if (time.tv_sec)
                inode->i_mtime = inode->i_ctime = time;

        return 0;

fail_write:
	inode->i_nlink--;
	mutex_lock(&root->d_inode->i_mutex);
	d_delete(dentry);
        dput(dentry);
	/* we fall through to unlock the mutex below */

fail_alloc:
	mutex_unlock(&root->d_inode->i_mutex);
        iput(inode);

fail:
        return rc;
}


Hmm.

-- 
Regards/Gruss,
Boris.
