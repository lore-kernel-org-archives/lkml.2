Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2DFA50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:57:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:28235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2DFA50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127694843"
Subject: Re: [PATCH_V2 1/2] fix the bug that printk can't support
 printk(KERN_LEVEL)
From: "he, bo" <bo.he@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        william.douglas@intel.com, yanmin_zhang@linux.intel.com
In-Reply-To: <1332725787.2359.27.camel@hebo>
References: <1332493027.2359.5.camel@hebo> <1332493269.2359.9.camel@hebo>
	 <20120323122208.GB13920@gmail.com>  <1332725787.2359.27.camel@hebo>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Apr 2012 08:57:34 +0800
Message-ID: <1333673854.2171.3.camel@hebo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 09:36 +0800, he, bo wrote:
> From: he bo <bo.he@intel.com>
> 
> Usually, there is a special scenario that developer wants to
> call printk to just set up a log level (might be transferred
> here as a parameter from upper level), then, later calling
> of printk prints out real string with the same log level
> continuously.
> 
> Current function vprintk has an issue to support this capability.
> When the whole string in one calling to printk is just a log level,
> it ignores it.
> 
> Signed-off-by: he, bo <bo.he@intel.com>
> Reviewed-by: Zhang, Yanmin <yanmin.zhang@intel.com>
> ---
>  kernel/printk.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
Ingo,

What's your opinion about the 2 patches? The 1st patch fixes an issue
and 2nd patch enhances dump_stack with log level.

https://lkml.org/lkml/2012/3/25/152
https://lkml.org/lkml/2012/3/25/153

Thanks,
Bo

> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index b663c2c..473afdb 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -909,7 +909,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  	 * Copy the output into log_buf. If the caller didn't provide
>  	 * the appropriate log prefix, we insert them here
>  	 */
> -	for (; *p; p++) {
> +	for (; plen || *p; p++) {
>  		if (new_text_line) {
>  			new_text_line = 0;
>  
> @@ -920,6 +920,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  				for (i = 0; i < plen; i++)
>  					emit_log_char(printk_buf[i]);
>  				printed_len += plen;
> +				plen = 0;
>  			} else {
>  				/* Add log prefix */
>  				emit_log_char('<');
> @@ -946,10 +947,10 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  				printed_len += tlen;
>  			}
>  
> -			if (!*p)
> -				break;
>  		}
>  
> +		if (!*p)
> +			break;
>  		emit_log_char(*p);
>  		if (*p == '\n')
>  			new_text_line = 1;


