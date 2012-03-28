Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2C1D3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 23:29:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:61717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab2C1D3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 23:29:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124102782"
Subject: Re: [PATCH_V2 1/2] fix the bug that printk can't support
 printk(KERN_LEVEL)
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: "he, bo" <bo.he@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, akpm@linux-foudation.org, mingo@elte.hu,
        rusty@rustcorp.com.au, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, william.douglas@intel.com
In-Reply-To: <1332725787.2359.27.camel@hebo>
References: <1332493027.2359.5.camel@hebo> <1332493269.2359.9.camel@hebo>
	 <20120323122208.GB13920@gmail.com>  <1332725787.2359.27.camel@hebo>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Wed, 28 Mar 2012 11:28:43 +0800
Message-ID: <1332905323.1916.233.camel@ymzhang>
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
The patch fixes a real issue. See the function.

static void print_trace_address(void *data, unsigned long addr, int reliable)
{
        touch_nmi_watchdog();
        printk(data);		<============= Here is to print the log level only
        printk_address(addr, reliable);
}

Without the patch, printk(data) doesn't emit the log level,
so printk_address would use the default log level.

Besides above real issue, developer might write below codes to debug issues.
printk("%s", log_level);
for (i = 0; i < fields; i++) {
	printk("one field");
}
I did so years ago and felt weird why the log level was incorrect. :)

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


