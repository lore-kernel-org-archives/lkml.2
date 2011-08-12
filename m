Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1HLJkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 05:40:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46229 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab1HLJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 05:40:32 -0400
Date: Fri, 12 Aug 2011 10:40:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kmemleak: Show where early_log issues come from
Message-ID: <20110812094018.GA1639@e102109-lin.cambridge.arm.com>
References: <1311701636.3526.97.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311701636.3526.97.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Tue, Jul 26, 2011 at 06:33:56PM +0100, Steven Rostedt wrote:
> The backtrace is from where the problem was detected, not where the
> problem occurred. I also noticed that the logs that are stored include a
> stack_trace dump. But this trace is only added when ALLOC is done.
> 
> The above issues ended up being from the cgroup code calling
> kmemleak_not_leak(), which does not store the trace. But that didn't
> matter, because even if it did, the trace is not printed out here
> leaving the above output still unhelpful in finding where the problem
> occurred.
> 
> By having all early kmemleak logs record the stack_trace, and by having
> the above error message / detection bubble up the call stack that an
> error occurred. We can have kmemleak_init() write exactly where the
> problem occurred.
...
> @@ -1708,10 +1730,12 @@ void __init kmemleak_init(void)
>  			kmemleak_free_part(log->ptr, log->size);
>  			break;
>  		case KMEMLEAK_NOT_LEAK:
> -			kmemleak_not_leak(log->ptr);
> +			if (__kmemleak_not_leak(log->ptr) < 0)
> +				print_log_stack(log);
>  			break;
>  		case KMEMLEAK_IGNORE:
> -			kmemleak_ignore(log->ptr);
> +			if (__kmemleak_ignore(log->ptr) < 0)
> +				print_log_stack(log);
>  			break;
>  		case KMEMLEAK_SCAN_AREA:
>  			kmemleak_scan_area(log->ptr, log->size, GFP_KERNEL);

Thanks for the patch, it makes sense. I was wondering whether we should
extend the above to the other early kmemleak API calls (apart from
KMEMLEAK_ALLOC). Also, to avoid some code duplication, maybe something
like below:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d6880f5..afec4cb 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1696,32 +1696,37 @@ void __init kmemleak_init(void)
 	 */
 	for (i = 0; i < crt_early_log; i++) {
 		struct early_log *log = &early_log[i];
+		int ret = 0;
 
 		switch (log->op_type) {
 		case KMEMLEAK_ALLOC:
 			early_alloc(log);
 			break;
 		case KMEMLEAK_FREE:
-			kmemleak_free(log->ptr);
+			ret = __kmemleak_free(log->ptr);
 			break;
 		case KMEMLEAK_FREE_PART:
-			kmemleak_free_part(log->ptr, log->size);
+			ret = __kmemleak_free_part(log->ptr, log->size);
 			break;
 		case KMEMLEAK_NOT_LEAK:
-			kmemleak_not_leak(log->ptr);
+			ret = __kmemleak_not_leak(log->ptr);
 			break;
 		case KMEMLEAK_IGNORE:
-			kmemleak_ignore(log->ptr);
+			ret = __kmemleak_ignore(log->ptr);
 			break;
 		case KMEMLEAK_SCAN_AREA:
-			kmemleak_scan_area(log->ptr, log->size, GFP_KERNEL);
+			ret = __kmemleak_scan_area(log->ptr, log->size,
+						   GFP_KERNEL);
 			break;
 		case KMEMLEAK_NO_SCAN:
-			kmemleak_no_scan(log->ptr);
+			ret = __kmemleak_no_scan(log->ptr);
 			break;
 		default:
 			WARN_ON(1);
 		}
+
+		if (ret < 0)
+			print_log_stack(log);
 	}
 }
 

Thanks.

-- 
Catalin
