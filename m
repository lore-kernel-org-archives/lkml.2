Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0CZUkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:40:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:57625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab0CZUkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:40:14 -0400
Message-ID: <4BAD1B72.9040002@kernel.org>
Date: Fri, 26 Mar 2010 13:39:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: hpa@zytor.com, teheo@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] free_early_partial() should permit start == end
References: <4BACF0E60200007800037373@vpn.id2.novell.com>
In-Reply-To: <4BACF0E60200007800037373@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 09:37 AM, Jan Beulich wrote:
> The per-CPU allocator, when using atom_size == PAGE_SIZE, may call
> free_area_init_partial() this way.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  kernel/early_res.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.34-rc2/kernel/early_res.c	2010-03-25 15:23:45.000000000 +0100
> +++ 2.6.34-rc2-free_early_partial-zero-size/kernel/early_res.c	2010-03-26 14:49:41.000000000 +0100
> @@ -335,10 +335,10 @@ void __init free_early_partial(u64 start
>  
>  try_next:
>  	i = find_overlapped_early(start, end);
> -	if (i >= max_early_res)
> +	r = &early_res[i];
> +	if (i >= max_early_res || !r->end)
>  		return;
>  
> -	r = &early_res[i];
>  	/* hole ? */
>  	if (r->end >= end && r->start <= start) {
>  		drop_range_partial(i, start, end);
> 
> 

can you check if this patch work for you?

Thanks

Yinghai Lu

Subject: [PATCH -v6] x86: do not free zero sized per cpu areas
From: Ian Campbell <ian.campbell@citrix.com>

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial to catch future problems.

-v5: put back start > end back into WARN_ONCE()
-v6: use one line for if according to linus

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/early_res.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/kernel/early_res.c
===================================================================
--- linux-2.6.orig/kernel/early_res.c
+++ linux-2.6/kernel/early_res.c
@@ -333,6 +333,12 @@ void __init free_early_partial(u64 start
 	struct early_res *r;
 	int i;
 
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "free_early_partial: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)
