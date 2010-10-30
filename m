Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab0J3Ahh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:37:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35712 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0J3Ahf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:37:35 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimJWX5WnG6oiUfBxiD=BBJ=Q5iRc73iar=gPKCy@mail.gmail.com>
References: <1288395700-9527-1-git-send-email-ksumrall@android.com>
	<20101029170209.0aced0ca.akpm@linux-foundation.org>
	<AANLkTimJWX5WnG6oiUfBxiD=BBJ=Q5iRc73iar=gPKCy@mail.gmail.com>
Date: Fri, 29 Oct 2010 17:37:33 -0700
Message-ID: <AANLkTin2NDYZ9qy+FLV6z2Vc5Cytn2B0=jdNgFVvq9C=@mail.gmail.com>
Subject: Fwd: [PATCH] Fix bug in FUSE where the attribute cache for a file was
 not cleared when a file is opened with O_TRUNC.
From: Ken Sumrall <ksumrall@android.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending to the list, as it was rejected due to html content.



---------- Forwarded message ----------
From: Ken Sumrall <ksumrall@android.com>
Date: Fri, Oct 29, 2010 at 5:31 PM
Subject: Re: [PATCH] Fix bug in FUSE where the attribute cache for a
file was not cleared when a file is opened with O_TRUNC.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
Jens Axboe <jens.axboe@oracle.com>, Anfei <anfei.zhou@gmail.com>,
"Anand V. Avati" <avati@gluster.com>, fuse-devel@lists.sourceforge.net


Here is a snippet of code from a test case we have:
  {
   FILE*   pFile = NULL;
   int32_t data  = 0x01020304;
   LOGE("WRITETEST start");
   pFile = fopen("/sdcard/write_test", "wb");
   if( NULL != pFile ) {
       LOGE("WRITETEST : starting position %d", ftell(pFile));
       fseek(pFile, 0, SEEK_END);
       LOGE("WRITETEST : starting size %d", ftell(pFile));
       fwrite(&data, sizeof(int32_t), 1, pFile);
       fclose(pFile);
   } else {
       LOGE("WRITETEST : failed to open the file");
   }
   LOGE("WRITETEST end");
}
fopen("wb") turns into open(O_TRUNC) in bionic (the Android libc).
The code is odd in that it then does fseek(SEEK_END) on a newly truncated file.
However, that is completely legal, and should set the file pointer to offset 0.
If the file had previously existed, it's attributes are still in the
FUSE attribute
cache, so the fseek(SEEK_END) positions the file pointer to the end
size of the file
before it was truncated.
This has probably never been seen before because most code that opens
with O_TRUNC
just starts writing, and doesn't query the attributes of the file till
after a write.  Writing clears
the attribute cache for the file so it is fetched from the filesystem
the next time it is
requested.
___
Ken
On Fri, Oct 29, 2010 at 5:02 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 29 Oct 2010 16:41:40 -0700 Ken Sumrall <ksumrall@android.com> wrote:
>
> > Signed-off-by: Ken Sumrall <ksumrall@android.com>
> > ---
> >  fs/fuse/file.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index c822458..4fbe62c 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -134,6 +134,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
> >  void fuse_finish_open(struct inode *inode, struct file *file)
> >  {
> >       struct fuse_file *ff = file->private_data;
> > +     struct fuse_conn *fc = get_fuse_conn(inode);
> >
> >       if (ff->open_flags & FOPEN_DIRECT_IO)
> >               file->f_op = &fuse_direct_io_file_operations;
> > @@ -141,6 +142,8 @@ void fuse_finish_open(struct inode *inode, struct file *file)
> >               invalidate_inode_pages2(inode->i_mapping);
> >       if (ff->open_flags & FOPEN_NONSEEKABLE)
> >               nonseekable_open(inode, file);
> > +     if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC))
> > +             fuse_invalidate_attr(inode);
> >  }
> >
> >  int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
>
> What were the user-visible effects of this bug?
>
