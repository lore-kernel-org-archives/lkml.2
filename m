Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2EBTqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:46:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2EBTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:46:12 -0400
Date: Wed, 2 May 2012 12:46:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com, rientjes@google.com,
        Neil Brown <neilb@suse.de>, Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] vmalloc: add warning in __vmalloc
Message-Id: <20120502124610.175e099c.akpm@linux-foundation.org>
In-Reply-To: <1335932890-25294-1-git-send-email-minchan@kernel.org>
References: <1335932890-25294-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 May 2012 13:28:09 +0900
Minchan Kim <minchan@kernel.org> wrote:

> Now there are several places to use __vmalloc with GFP_ATOMIC,
> GFP_NOIO, GFP_NOFS but unfortunately __vmalloc calls map_vm_area
> which calls alloc_pages with GFP_KERNEL to allocate page tables.
> It means it's possible to happen deadlock.
> I don't know why it doesn't have reported until now.
> 
> Firstly, I tried passing gfp_t to lower functions to support __vmalloc
> with such flags but other mm guys don't want and decided that
> all of caller should be fixed.
> 
> http://marc.info/?l=linux-kernel&m=133517143616544&w=2
> 
> To begin with, let's listen other's opinion whether they can fix it
> by other approach without calling __vmalloc with such flags.
> 
> So this patch adds warning in __vmalloc_node_range to detect it and
> to be fixed hopely. __vmalloc_node_range isn't random chocie because
> all caller which has gfp_mask of map_vm_area use it through __vmalloc_area_node.
> And __vmalloc_area_node is current static function and is called by only
> __vmalloc_node_range. So warning in __vmalloc_node_range would cover all
> vmalloc functions which have gfp_t argument.
>
> I Cced related maintainers.
> If I miss someone, please Cced them.
> 
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1648,6 +1648,10 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
>  	void *addr;
>  	unsigned long real_size = size;
>  
> +	WARN_ON_ONCE(!(gfp_mask & __GFP_WAIT) ||
> +			!(gfp_mask & __GFP_IO) ||
> +			!(gfp_mask & __GFP_FS));
> +
>  	size = PAGE_ALIGN(size);
>  	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
>  		goto fail;

Well.  What are we actually doing here?  Causing the kernel to spew a
warning due to known-buggy callsites, so that users will report the
warnings, eventually goading maintainers into fixing their stuff.

This isn't very efficient :(

It would be better to fix that stuff first, then add the warning to
prevent reoccurrences.  Yes, maintainers are very naughty and probably
do need cattle prods^W^W warnings to motivate them to fix stuff, but we
should first make an effort to get these things fixed without
irritating and alarming our users.  

Where are these offending callsites?
