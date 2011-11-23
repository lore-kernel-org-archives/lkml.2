Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1KWT7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:59:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33469 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1KWT7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <1322038412-29013-1-git-send-email-amwang@redhat.com>
References: <1322038412-29013-1-git-send-email-amwang@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 23 Nov 2011 14:59:01 -0500
X-Google-Sender-Auth: 4FU-_ToOJuY7TWzOVjoqEKf_7fM
Message-ID: <CAHGf_=rOYkEGHakyHpihopMg2VtVfDV7XvC_QGs_kj6HgDmBRA@mail.gmail.com>
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Systemd needs tmpfs to support fallocate [1], to be able
> to safely use mmap(), regarding SIGBUS, on files on the
> /dev/shm filesystem. The glibc fallback loop for -ENOSYS
> on fallocate is just ugly.

for EOPNOTSUPP?

glibc/sysdeps/unix/sysv/linux/i386/posix_fallocate.c
----------------
int
posix_fallocate (int fd, __off_t offset, __off_t len)
{
#ifdef __NR_fallocate
# ifndef __ASSUME_FALLOCATE
  if (__builtin_expect (__have_fallocate >= 0, 1))
# endif
    {
      int res = __call_fallocate (fd, 0, offset, len);
      if (! res)
        return 0;

# ifndef __ASSUME_FALLOCATE
      if (__builtin_expect (res == ENOSYS, 0))
        __have_fallocate = -1;
      else
# endif
        if (res != EOPNOTSUPP)
          return res;
    }
#endif

  return internal_fallocate (fd, offset, len);
}
--------------------------


But, ok, I'm now convinced this is needed. people strongly dislike to
receive SIGBUS. yes.


> This patch adds fallocate support to tmpfs, and as we
> already have shmem_truncate_range(), it is also easy to
> add FALLOC_FL_PUNCH_HOLE support too.
>
> 1. http://lkml.org/lkml/2011/10/20/275
>
> V2->V3:
> a) Read i_size directly after holding i_mutex;
> b) Call page_cache_release() too after shmem_getpage();
> c) Undo previous changes when -ENOSPC.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Lennart Poettering <lennart@poettering.net>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
>
> ---
>  mm/shmem.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 65 insertions(+), 0 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d672250..65f7a27 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -30,6 +30,7 @@
>  #include <linux/mm.h>
>  #include <linux/export.h>
>  #include <linux/swap.h>
> +#include <linux/falloc.h>
>
>  static struct vfsmount *shm_mnt;
>
> @@ -1431,6 +1432,69 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
>        return error;
>  }
>
> +static void shmem_truncate_page(struct inode *inode, pgoff_t index)
> +{
> +       loff_t start = index << PAGE_CACHE_SHIFT;
> +       loff_t end = ((index + 1) << PAGE_CACHE_SHIFT) - 1;
> +       shmem_truncate_range(inode, start, end);
> +}
> +
> +static long shmem_fallocate(struct file *file, int mode,
> +                               loff_t offset, loff_t len)
> +{
> +       struct inode *inode = file->f_path.dentry->d_inode;
> +       pgoff_t start = offset >> PAGE_CACHE_SHIFT;
> +       pgoff_t end = DIV_ROUND_UP((offset + len), PAGE_CACHE_SIZE);
> +       pgoff_t index = start;
> +       loff_t i_size;
> +       struct page *page = NULL;
> +       int ret = 0;

do_fallocate has following file type check.

        if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
                return -ENODEV;

However, this implementation don't support dir allocation and/or punch hole.
ext4's ext4_punch_hole() has following additional check. Maybe we need similar
check.

        if (!S_ISREG(inode->i_mode))
                return -ENOTSUPP;


> +       mutex_lock(&inode->i_mutex);
> +       i_size = inode->i_size;
> +       if (mode & FALLOC_FL_PUNCH_HOLE) {
> +               if (!(offset > i_size || (end << PAGE_CACHE_SHIFT) > i_size))

Seems incorrect.
fallocate(PUNCH, 0, very_big_number) should punch to a range of [0, end).


> +                       shmem_truncate_range(inode, offset,
> +                                            (end << PAGE_CACHE_SHIFT) - 1);
> +               goto unlock;
> +       }
> +
> +       if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> +               ret = inode_newsize_ok(inode, (offset + len));
> +               if (ret)
> +                       goto unlock;
> +       }
> +       while (index < end) {
> +               ret = shmem_getpage(inode, index, &page, SGP_WRITE, NULL);
> +               if (ret) {
> +                       if (ret == -ENOSPC)
> +                               goto undo;
> +                       else
> +                               goto unlock;
> +               }
> +               if (page) {
> +                       unlock_page(page);
> +                       page_cache_release(page);
> +               }
> +               index++;
> +       }
> +       if (!(mode & FALLOC_FL_KEEP_SIZE) && (index << PAGE_CACHE_SHIFT) > i_size)
> +               i_size_write(inode, index << PAGE_CACHE_SHIFT);

Seems incorrect.
new i_size should be offset+len. our round-up is implementation detail
and don't have to expose
to userland.

> +
> +       goto unlock;
> +
> +undo:
> +       while (index > start) {
> +               shmem_truncate_page(inode, index);
> +               index--;

Hmmm...
seems too aggressive truncate if the file has pages before starting fallocate.
but I have no idea to make better undo. ;)


> +       }
> +
> +unlock:
> +       mutex_unlock(&inode->i_mutex);
> +       return ret;
> +}
> +
>  static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
>        struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
> @@ -2286,6 +2350,7 @@ static const struct file_operations shmem_file_operations = {
>        .fsync          = noop_fsync,
>        .splice_read    = shmem_file_splice_read,
>        .splice_write   = generic_file_splice_write,
> +       .fallocate      = shmem_fallocate,
>  #endif
>  };
