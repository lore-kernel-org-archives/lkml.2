Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab2BJOoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:44:16 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:49285 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932264Ab2BJOoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:44:14 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <528884067.18397@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: "'Jan Kara'" <jack@suse.cz>
Cc: "'Tyler Hicks'" <tyhicks@canonical.com>, <ecryptfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "'Yong Peng'" <pengyong@kylinos.com.cn>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>
References: <1328787572-2030-1-git-send-email-liwang@nudt.edu.cn> <528868922.02520@eyou.net>
In-Reply-To: <528868922.02520@eyou.net>
Subject: RE: [PATCH] eCryptfs: Quota check incorrectly ignored
Date: Fri, 10 Feb 2012 22:44:05 +0800
Message-ID: <000001cce802$709bf770$51d3e650$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aczn3OW7QydQCiptRiaGMtZXH+t4fgAH/geg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jan Kara [mailto:jack@suse.cz]
> Sent: Friday, February 10, 2012 6:32 PM
> To: Li Wang
> Cc: Tyler Hicks; ecryptfs@vger.kernel.org; linux-kernel@vger.kernel.org;
Jan
> Kara; Yong Peng
> Subject: Re: [PATCH] eCryptfs: Quota check incorrectly ignored
> 
> On Thu 09-02-12 19:39:32, Li Wang wrote:
> > eCryptfs recently modified the write path to perform encryption
> > and write down in ecryptfs_writepage(). This function invokes
vfs_write()
> > to write down the encrypted data to lower page cache. vfs_write() will
> > first make sure this write will not exceed the quota limit for the owner
> > of the file being written into, if quota is supported by
> > the underlying file system, and it is turned on. Normally, it
accomplishs
> > this job by calling check_idq()/check_bdq() (fs/quota/dquot.c). When
system
> > dirty ratio is not high, ecryptfs_writepage() is normally invoked by the
> > write back kernel thread, who has the capability CAP_SYS_RESOURCE,
> > this priority will let check_idq()/check_bdq() directly bypass the quota
> > check. This sometimes makes data safely written into the disk in spite
of
> > exceeding the quota limit.
> >
> > This patch temporarily removes the CAP_SYS_RESOURCE capability from the
> kernel
> > thread before invoking vfs_write_lower(), to let it undergo quota check
by
> > the lower file system, if necessary. After that, reassign the
capability.
>   Hmm, but then the error will just be thrown away by the flusher thread
> and the application never learns about it? That doesn't sound like a good
> solution.
> 
> 								Honza

Yes. we are aware of that, but we have not found better solution, since it
seems 
VFS does not supply a file system independent interface to check quota early
and only
(fix us if we are wrong), The file systems just perform the quota check in
their own way, 
the routine is wrapped deeply inside the file system specific code path.
Maybe we could
copy some codes from _dquot_alloc_space() & dquot_alloc_inode
(fs/quota/dquot.c) to 
perform quota check on lower inode ourselves, but that is ugly, and we are
not sure if it works
for any file system or not..., On the other side, due to the existence of
write buffer, and io schedule,
the successful write call does not gurantee the data will be written into
disk, in terms of that,
we do not change much of the semantic of write call. 
 
> 
> 
> >
> > Signed-off-by: Li Wang <liwang@nudt.edu.cn>
> > Singed-off-by: Yong Peng <pengyong@kylinos.com.cn>
> > ---
> >
> > To repeat this bug,
> > 	mount -o usrquota /dev/sda3 /tmp
> > 	cd /tmp
> > 	edquota -u foo // set the disk quota limit for user foo be m1 bytes
> > 	quotaon -a
> > 	mount -t ecryptfs cipher plain
> >
> > 	login the system as user foo
> > 	cd /tmp/plain
> > 	execute the following simple program
> >
> > 	int main()
> > 	{
> > 		char buf[m2]; // m2>m1
> > 		FILE *f = fopen("dummy", "w");
> > 		fwrite(buf, 1, m2, f);
> > 		sleep(60); // let the kernel thread do the write back job
> > 		fclose(f);
> > 		return 0;
> > 	}
> >
> > 	This program can write as much of data as it wants, provided sleep
> enough long time before closing the file.
> >
> >  fs/ecryptfs/crypto.c |   27 +++++++++++++++++++++++++++
> >  1 files changed, 27 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> > index 63ab245..2c1da29 100644
> > --- a/fs/ecryptfs/crypto.c
> > +++ b/fs/ecryptfs/crypto.c
> > @@ -457,6 +457,7 @@ int ecryptfs_encrypt_page(struct page *page)
> >  	struct page *enc_extent_page = NULL;
> >  	loff_t extent_offset;
> >  	int rc = 0;
> > +	struct cred *cred;
> >
> >  	ecryptfs_inode = page->mapping->host;
> >  	crypt_stat =
> > @@ -487,8 +488,34 @@ int ecryptfs_encrypt_page(struct page *page)
> >  				   * (PAGE_CACHE_SIZE
> >  				      / crypt_stat->extent_size))
> >  				  + extent_offset), crypt_stat);
> > +		if (current->flags & PF_KTHREAD) {
> > +			/*
> > +                         * Temporarily remove the
> CAP_SYS_RESOURCE capability
> > +                         * from the write back kernel thread to let it
> undergo
> > +                         * quota check by the lower file system
> > +                         */
> > +			cred = prepare_creds();
> > +			if (unlikely(!cred)) {
> > +				rc = -ENOMEM;
> > +				goto out;
> > +			}
> > +			cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
> > +			commit_creds(cred);
> > +		}
> >  		rc = ecryptfs_write_lower(ecryptfs_inode, enc_extent_virt,
> >  					  offset, crypt_stat->extent_size);
> > +		if (current->flags & PF_KTHREAD) {
> > +			/*
> > +                         * Reassign the CAP_SYS_RESOURCE
> capability
> > +                         */
> > +			cred = prepare_creds();
> > +			if (unlikely(!cred)) {
> > +				rc = -ENOMEM;
> > +				goto out;
> > +			}
> > +			cap_raise(cred->cap_effective, CAP_SYS_RESOURCE);
> > +			commit_creds(cred);
> > +		}
> >  		if (rc < 0) {
> >  			ecryptfs_printk(KERN_ERR, "Error attempting "
> >  					"to write lower page; rc = [%d]"
> > --
> > 1.7.6.5
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

