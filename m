Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2ENTsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:48:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49428 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab2ENTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:48:34 -0400
Date: Mon, 14 May 2012 12:48:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/10] tmpfs: enable NOSEC optimization
In-Reply-To: <4FB0D1C6.7090801@gmail.com>
Message-ID: <alpine.LSU.2.00.1205141242530.1623@eggly.anvils>
References: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils> <alpine.LSU.2.00.1205120500040.28861@eggly.anvils> <4FB0D1C6.7090801@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Cong Wang wrote:
> On 05/12/2012 08:02 PM, Hugh Dickins wrote:
> > Let tmpfs into the NOSEC optimization (avoiding file_remove_suid()
> > overhead on most common writes): set MS_NOSEC on its superblocks.
> > 
> > Signed-off-by: Hugh Dickins<hughd@google.com>
> > ---
> >   mm/shmem.c |    1 +
> >   1 file changed, 1 insertion(+)
> > 
> > --- 3045N.orig/mm/shmem.c	2012-05-05 10:45:17.888060878 -0700
> > +++ 3045N/mm/shmem.c	2012-05-05 10:46:05.732062006 -0700
> > @@ -2361,6 +2361,7 @@ int shmem_fill_super(struct super_block
> >   		}
> >   	}
> >   	sb->s_export_op =&shmem_export_ops;
> > +	sb->s_flags |= MS_NOSEC;
> 
> Isn't setting the flag on inode better? Something like:

I don't think so.  The MS_NOSEC S_NOSEC business is fairly subtle,
and easy to miss if it's gone wrong, so I would much rather follow
the established pattern in local block filesystems: which is to set
MS_NOSEC in superblock flags, and leave S_NOSEC to file_remove_suid().

Hugh

> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f99ff3e..7d98fb5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2325,6 +2325,7 @@ static void shmem_init_inode(void *foo)
>  {
>         struct shmem_inode_info *info = foo;
>         inode_init_once(&info->vfs_inode);
> +       info->vfs_inode.i_flags |= S_NOSEC;
>  }
> 
>  static int shmem_init_inodecache(void)
