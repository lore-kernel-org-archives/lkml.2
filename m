Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1K2GDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:03:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53621 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1K2GDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:03:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Nov 2011 15:02:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V4 PATCH 1/2] tmpfs: add fallocate support
Message-Id: <20111129150210.ad266dd7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322544793-2676-1-git-send-email-amwang@redhat.com>
References: <1322544793-2676-1-git-send-email-amwang@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 13:33:12 +0800
Cong Wang <amwang@redhat.com> wrote:

> Systemd needs tmpfs to support fallocate [1], to be able
> to safely use mmap(), regarding SIGBUS, on files on the
> /dev/shm filesystem. The glibc fallback loop for -ENOSYS
> on fallocate is just ugly.
> 
> This patch adds fallocate support to tmpfs, and as we
> already have shmem_truncate_range(), it is also easy to
> add FALLOC_FL_PUNCH_HOLE support too.
> 
> 1. http://lkml.org/lkml/2011/10/20/275
> 

one question.


> V3->V4:
> Handle 'undo' ENOSPC more correctly.
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
>  mm/shmem.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 90 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d672250..90c835b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -30,6 +30,7 @@
>  #include <linux/mm.h>
>  #include <linux/export.h>
>  #include <linux/swap.h>
> +#include <linux/falloc.h>
>  
>  static struct vfsmount *shm_mnt;
>  
> @@ -1016,6 +1017,35 @@ failed:
>  	return error;
>  }
>  
> +static void shmem_putpage_noswap(struct inode *inode, pgoff_t index)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	struct shmem_inode_info *info;
> +	struct shmem_sb_info *sbinfo;
> +	struct page *page;
> +
> +	page = find_lock_page(mapping, index);
> +

You can't know whether the 'page' is allocated by alloc_page() in fallocate()
or just found as exiting one.
Then, yourwill corrupt existing pages in error path.
Is it allowed ?

Thanks,
-Kame

