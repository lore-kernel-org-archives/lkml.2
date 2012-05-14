Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2ENJfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:35:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44351 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2ENJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:35:08 -0400
Message-ID: <4FB0D1C6.7090801@gmail.com>
Date: Mon, 14 May 2012 17:35:02 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/10] tmpfs: enable NOSEC optimization
References: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils> <alpine.LSU.2.00.1205120500040.28861@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205120500040.28861@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 08:02 PM, Hugh Dickins wrote:
> Let tmpfs into the NOSEC optimization (avoiding file_remove_suid()
> overhead on most common writes): set MS_NOSEC on its superblocks.
>
> Signed-off-by: Hugh Dickins<hughd@google.com>
> ---
>   mm/shmem.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- 3045N.orig/mm/shmem.c	2012-05-05 10:45:17.888060878 -0700
> +++ 3045N/mm/shmem.c	2012-05-05 10:46:05.732062006 -0700
> @@ -2361,6 +2361,7 @@ int shmem_fill_super(struct super_block
>   		}
>   	}
>   	sb->s_export_op =&shmem_export_ops;
> +	sb->s_flags |= MS_NOSEC;

Isn't setting the flag on inode better? Something like:

diff --git a/mm/shmem.c b/mm/shmem.c
index f99ff3e..7d98fb5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2325,6 +2325,7 @@ static void shmem_init_inode(void *foo)
  {
         struct shmem_inode_info *info = foo;
         inode_init_once(&info->vfs_inode);
+       info->vfs_inode.i_flags |= S_NOSEC;
  }

  static int shmem_init_inodecache(void)
