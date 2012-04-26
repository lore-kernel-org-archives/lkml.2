Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab2DZXVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 19:21:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2DZXVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 19:21:10 -0400
Date: Thu, 26 Apr 2012 16:21:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memblock - Handled failure of debug fs entries
 creation
Message-Id: <20120426162108.b654a920.akpm@linux-foundation.org>
In-Reply-To: <1335383992-19419-1-git-send-email-sasikanth.v19@gmail.com>
References: <1335383992-19419-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 01:29:52 +0530
Sasikantha babu <sasikanth.v19@gmail.com> wrote:

> 1) Removed already created debug fs entries on failure
> 
> 2) Fixed coding style 80 char per line
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
> ---
>  mm/memblock.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index a44eab3..5553723 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -966,11 +966,19 @@ static int __init memblock_init_debugfs(void)
>  {
>  	struct dentry *root = debugfs_create_dir("memblock", NULL);
>  	if (!root)
> -		return -ENXIO;
> -	debugfs_create_file("memory", S_IRUGO, root, &memblock.memory, &memblock_debug_fops);
> -	debugfs_create_file("reserved", S_IRUGO, root, &memblock.reserved, &memblock_debug_fops);
> +		return -ENOMEM;

hm, why the switch to -ENOMEM?

Fact is, debugfs_create_dir() and debugfs_create_file() are stupid
interfaces which don't provide the caller (and hence the user) with any
information about why they failed.  Perhaps memblock_init_debugfs()
should return -EWESUCK.

> +	if (!debugfs_create_file("memory", S_IRUGO, root, &memblock.memory,
> +				&memblock_debug_fops))
> +		goto fail;
> +	if (!debugfs_create_file("reserved", S_IRUGO, root, &memblock.reserved,
> +				&memblock_debug_fops))
> +		goto fail;
>  
>  	return 0;
> +fail:
> +	debugfs_remove_recursive(root);
> +	return -ENOMEM;
>  }
>  __initcall(memblock_init_debugfs);

