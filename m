Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2BMJZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:25:42 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:36732 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751878Ab2BMJZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:25:40 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <529124129.16414@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: "'Tyler Hicks'" <tyhicks@canonical.com>
Cc: "'Jan Kara'" <jack@suse.cz>, "'Yong Peng'" <pengyong@kylinos.com.cn>,
        <viro@zeniv.linux.org.uk>, <akpm@linux-foundation.org>,
        <taysom@chromium.org>, "'Thieu Le'" <thieule@chromium.org>,
        <ecryptfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
References: <20120210194142.GB15606@boyd> <528913714.17261@eyou.net>
In-Reply-To: <528913714.17261@eyou.net>
Subject: RE: Re: [PATCH] eCryptfs: Quota check incorrectly ignored
Date: Mon, 13 Feb 2012 17:25:17 +0800
Message-ID: <003e01ccea31$6e381cd0$4aa85670$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AczoR3nCCxbTzRS7T0aO2HvhUhcLiQB5mlQw
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a pity to have to cancel this optimization due to such small probability events. It does bring obvious
write speedups, especially when the system load is not high, it offloads the encryption task from the
processes, and makes the write call nearly 1x faster according to our test, comparable to the lower file system
throughput, and it avoids, to some extent, repeated encryptions when the same part of data being multiple written.

Again, thanks Thieu.


-----Original Message-----
From: liwang@nudt.edu.cn [mailto:liwang@nudt.edu.cn] On Behalf Of Tyler Hicks
Sent: Saturday, February 11, 2012 6:58 AM
To: ecryptfs@vger.kernel.org; linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org
Cc: Li Wang; Jan Kara; Yong Peng; viro@zeniv.linux.org.uk; akpm@linux-foundation.org; taysom@chromium.org; Thieu Le
Subject: Fwd: Re: [PATCH] eCryptfs: Quota check incorrectly ignored

Thieu says his emails to the vger.kernel.org lists are bouncing.
Forwarding for completeness.

Tyler

----- Forwarded message from Thieu Le <thieule@chromium.org> -----

> Date: Fri, 10 Feb 2012 14:31:12 -0800
> From: Thieu Le <thieule@chromium.org>
> To: Tyler Hicks <tyhicks@canonical.com>
> Cc: Li Wang <liwang@nudt.edu.cn>, Jan Kara <jack@suse.cz>, ecryptfs@vger.kernel.org,
> 	linux-kernel@vger.kernel.org, Yong Peng <pengyong@kylinos.com.cn>, viro@zeniv.linux.org.uk,
> 	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, taysom@chromium.org
> Subject: Re: [PATCH] eCryptfs: Quota check incorrectly ignored
> 
> +taysom
> 
> I am onboard with backing out the write-back cache patch.  It looks like
> we're just peeling the layers of this onion.
> 
> On Fri, Feb 10, 2012 at 11:41 AM, Tyler Hicks <tyhicks@canonical.com> wrote:
> 
> > On 2012-02-10 13:31:49, 'Tyler Hicks' wrote:
> > > On 2012-02-10 22:44:05, Li Wang wrote:
> > > > > -----Original Message-----
> > > > > From: Jan Kara [mailto:jack@suse.cz]
> > > > > Sent: Friday, February 10, 2012 6:32 PM
> > > > > To: Li Wang
> > > > > Cc: Tyler Hicks; ecryptfs@vger.kernel.org;
> > linux-kernel@vger.kernel.org;
> > > > Jan
> > > > > Kara; Yong Peng
> > > > > Subject: Re: [PATCH] eCryptfs: Quota check incorrectly ignored
> > > > >
> > > > > On Thu 09-02-12 19:39:32, Li Wang wrote:
> > > > > > eCryptfs recently modified the write path to perform encryption
> > > > > > and write down in ecryptfs_writepage(). This function invokes
> > > > vfs_write()
> > > > > > to write down the encrypted data to lower page cache. vfs_write()
> > will
> > > > > > first make sure this write will not exceed the quota limit for the
> > owner
> > > > > > of the file being written into, if quota is supported by
> > > > > > the underlying file system, and it is turned on. Normally, it
> > > > accomplishs
> > > > > > this job by calling check_idq()/check_bdq() (fs/quota/dquot.c).
> > When
> > > > system
> > > > > > dirty ratio is not high, ecryptfs_writepage() is normally invoked
> > by the
> > > > > > write back kernel thread, who has the capability CAP_SYS_RESOURCE,
> > > > > > this priority will let check_idq()/check_bdq() directly bypass the
> > quota
> > > > > > check. This sometimes makes data safely written into the disk in
> > spite
> > > > of
> > > > > > exceeding the quota limit.
> > > > > >
> > > > > > This patch temporarily removes the CAP_SYS_RESOURCE capability
> > from the
> > > > > kernel
> > > > > > thread before invoking vfs_write_lower(), to let it undergo quota
> > check
> > > > by
> > > > > > the lower file system, if necessary. After that, reassign the
> > > > capability.
> > > > >   Hmm, but then the error will just be thrown away by the flusher
> > thread
> > > > > and the application never learns about it? That doesn't sound like a
> > good
> > > > > solution.
> > > > >
> > > > >                                                           Honza
> > > >
> > > > Yes. we are aware of that, but we have not found better solution,
> > since it
> > > > seems
> > > > VFS does not supply a file system independent interface to check quota
> > early
> > > > and only
> > > > (fix us if we are wrong), The file systems just perform the quota
> > check in
> > > > their own way,
> > > > the routine is wrapped deeply inside the file system specific code
> > path.
> > > > Maybe we could
> > > > copy some codes from _dquot_alloc_space() & dquot_alloc_inode
> > > > (fs/quota/dquot.c) to
> > > > perform quota check on lower inode ourselves, but that is ugly, and we
> > are
> > > > not sure if it works
> > > > for any file system or not..., On the other side, due to the existence
> > of
> > > > write buffer, and io schedule,
> > > > the successful write call does not gurantee the data will be written
> > into
> > > > disk, in terms of that,
> > > > we do not change much of the semantic of write call.
> > >
> > > Maybe I should just revert 57db4e8d73ef2b5e94a3f412108dff2576670a8a
> > > (and friends) and go back to the write-through cache model for eCryptfs.
> > > The write-back model has some nice performance improvements, but we keep
> > > running into little issues like this. For write-through to work
> > > reliably, we're going to need some support from the VFS that isn't there
> > > yet.
> >
> > Sorry, that should be "For write-back to work reliably, we're going to
> > need some support from the VFS that isn't there yet."
> >
> > Tyler
> >
> > >
> > > Handling ENOSPC correctly is another area that is lacking after the
> > > switch to write-back. Currently, an application will continue to write
> > > out data without having any indication that the disk is full. Thieu
> > > proposed a fix, but it was never merged:
> > >
> > > http://article.gmane.org/gmane.linux.kernel/1209265
> > >
> > > So, what do folks think about going back to a write-through cache until
> > > we have the ability to alert the application of these error conditions?
> > >
> > > Tyler
> > >
> > > >
> > > > >
> > > > >
> > > > > >
> > > > > > Signed-off-by: Li Wang <liwang@nudt.edu.cn>
> > > > > > Singed-off-by: Yong Peng <pengyong@kylinos.com.cn>
> > > > > > ---
> > > > > >
> > > > > > To repeat this bug,
> > > > > >         mount -o usrquota /dev/sda3 /tmp
> > > > > >         cd /tmp
> > > > > >         edquota -u foo // set the disk quota limit for user foo be
> > m1 bytes
> > > > > >         quotaon -a
> > > > > >         mount -t ecryptfs cipher plain
> > > > > >
> > > > > >         login the system as user foo
> > > > > >         cd /tmp/plain
> > > > > >         execute the following simple program
> > > > > >
> > > > > >         int main()
> > > > > >         {
> > > > > >                 char buf[m2]; // m2>m1
> > > > > >                 FILE *f = fopen("dummy", "w");
> > > > > >                 fwrite(buf, 1, m2, f);
> > > > > >                 sleep(60); // let the kernel thread do the write
> > back job
> > > > > >                 fclose(f);
> > > > > >                 return 0;
> > > > > >         }
> > > > > >
> > > > > >         This program can write as much of data as it wants,
> > provided sleep
> > > > > enough long time before closing the file.
> > > > > >
> > > > > >  fs/ecryptfs/crypto.c |   27 +++++++++++++++++++++++++++
> > > > > >  1 files changed, 27 insertions(+), 0 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> > > > > > index 63ab245..2c1da29 100644
> > > > > > --- a/fs/ecryptfs/crypto.c
> > > > > > +++ b/fs/ecryptfs/crypto.c
> > > > > > @@ -457,6 +457,7 @@ int ecryptfs_encrypt_page(struct page *page)
> > > > > >         struct page *enc_extent_page = NULL;
> > > > > >         loff_t extent_offset;
> > > > > >         int rc = 0;
> > > > > > +       struct cred *cred;
> > > > > >
> > > > > >         ecryptfs_inode = page->mapping->host;
> > > > > >         crypt_stat =
> > > > > > @@ -487,8 +488,34 @@ int ecryptfs_encrypt_page(struct page *page)
> > > > > >                                    * (PAGE_CACHE_SIZE
> > > > > >                                       / crypt_stat->extent_size))
> > > > > >                                   + extent_offset), crypt_stat);
> > > > > > +               if (current->flags & PF_KTHREAD) {
> > > > > > +                       /*
> > > > > > +                         * Temporarily remove the
> > > > > CAP_SYS_RESOURCE capability
> > > > > > +                         * from the write back kernel thread to
> > let it
> > > > > undergo
> > > > > > +                         * quota check by the lower file system
> > > > > > +                         */
> > > > > > +                       cred = prepare_creds();
> > > > > > +                       if (unlikely(!cred)) {
> > > > > > +                               rc = -ENOMEM;
> > > > > > +                               goto out;
> > > > > > +                       }
> > > > > > +                       cap_lower(cred->cap_effective,
> > CAP_SYS_RESOURCE);
> > > > > > +                       commit_creds(cred);
> > > > > > +               }
> > > > > >                 rc = ecryptfs_write_lower(ecryptfs_inode,
> > enc_extent_virt,
> > > > > >                                           offset,
> > crypt_stat->extent_size);
> > > > > > +               if (current->flags & PF_KTHREAD) {
> > > > > > +                       /*
> > > > > > +                         * Reassign the CAP_SYS_RESOURCE
> > > > > capability
> > > > > > +                         */
> > > > > > +                       cred = prepare_creds();
> > > > > > +                       if (unlikely(!cred)) {
> > > > > > +                               rc = -ENOMEM;
> > > > > > +                               goto out;
> > > > > > +                       }
> > > > > > +                       cap_raise(cred->cap_effective,
> > CAP_SYS_RESOURCE);
> > > > > > +                       commit_creds(cred);
> > > > > > +               }
> > > > > >                 if (rc < 0) {
> > > > > >                         ecryptfs_printk(KERN_ERR, "Error
> > attempting "
> > > > > >                                         "to write lower page; rc =
> > [%d]"
> > > > > > --
> > > > > > 1.7.6.5
> > > > > --
> > > > > Jan Kara <jack@suse.cz>
> > > > > SUSE Labs, CR
> > > >
> >
> >
> >

----- End forwarded message -----

