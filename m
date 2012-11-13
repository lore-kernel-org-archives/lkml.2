Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2KMWYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:24:16 -0500
Received: from nm16-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.166]:45150
	"EHLO nm16-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463Ab2KMWYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:24:15 -0500
X-Yahoo-Newman-Id: 987309.93580.bm@smtp101.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MD.D2k8VM1mtAOPTlaevvmjsgBUL338At7XBntxiSfTubIw
 An_Gj4LmiR5hi191LvDhs42Hy45ilhEBY1IAkBCDMPm_cv3D2S4B27TqjDwG
 dR4rsS2a1pqhMilOi0pNNKkS9IKAtjvIgIhyRWmY.PvRQbx3O__wp.l8QklS
 izuCE52G3cZlMeKHSQkkQg7ee9ZjwZt.DeCbI..K4cfRY_DLqQCCJHD8Loan
 q4TqRdr663KgJAqkmdhTvb9zLHJfnuEXuEhF2ugEcdoRtkjqJfhxZmqMSzx7
 uohwLmTsv.ym.OyevJtpKObERel1RIAP3lvDdpcRPhVwYxpGo3KJwdsjeeJl
 R5KjudpZxV83x8tF00m5prfBx8wAaF9_OGwvsktQOVb3oLLBb5erl_mE9uH7
 Ll6pmDad4Q7h759xHgc_IL6c._PukXUBk91LK5fKT3R6IGOIMarFTOFol7PT
 TLB8tMRBzgpNyTm18doMC4Ns7kA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50A2C88F.5010902@att.net>
Date: Tue, 13 Nov 2012 16:24:15 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 7/9] bug.h: Make BUILD_BUG_ON generate compile-time
 error
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com> <1352844821-18952-7-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1352844821-18952-7-git-send-email-daniel.santos@pobox.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav,

Please note that this patch has changed slightly since you Acked it.  I
have moved the location of the negative-size array code to the end of
the macro.  I don't think this really matters honestly, but I figured
this was the best place to put that change.

Daniel

On 11/13/2012 04:13 PM, danielfsantos@att.net wrote:
> Negative sized arrays wont create a compile-time error in some cases
> starting with gcc 4.4 (e.g., inlined functions), but gcc 4.3 introduced
> the error function attribute that will.  This patch modifies
> BUILD_BUG_ON to behave like BUILD_BUG already does, using the error
> function attribute so that you don't have to build the entire kernel to
> discover that you have a problem, and then enjoy trying to track it down
> from a link-time error.
>
> Also, we are only including asm/bug.h and then expecting that
> linux/compiler.h will eventually be included to define __linktime_error
> (used in BUILD_BUG_ON). This patch includes it directly for clarity and
> to avoid the possibility of changes in <arch>/*/include/asm/bug.h being
> changed or not including linux/compiler.h for some reason.
>
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> Acked-by: Borislav Petkov <bp@alien8.de>
> ---
>  include/linux/bug.h |   32 +++++++++++++++++++-------------
>  1 files changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index ccd44ce..dd4f506 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_BUG_H
>  
>  #include <asm/bug.h>
> +#include <linux/compiler.h>
>  
>  enum bug_trap_type {
>  	BUG_TRAP_TYPE_NONE = 0,
> @@ -42,25 +43,30 @@ struct pt_regs;
>   * @condition: the condition which the compiler should know is false.
>   *
>   * If you have some code which relies on certain constants being equal, or
> - * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
> + * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
>   * detect if someone changes it.
>   *
> - * The implementation uses gcc's reluctance to create a negative array, but
> - * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
> - * to inline functions).  So as a fallback we use the optimizer; if it can't
> - * prove the condition is false, it will cause a link error on the undefined
> - * "__build_bug_on_failed".  This error message can be harder to track down
> - * though, hence the two different methods.
> + * The implementation uses gcc's reluctance to create a negative array, but gcc
> + * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
> + * inline functions).  Luckily, in 4.3 they added the "error" function
> + * attribute just for this type of case.  Thus, we use a negative sized array
> + * (should always create an error on gcc versions older than 4.4) and then call
> + * an undefined function with the error attribute (should always create an
> + * error on gcc 4.3 and later).  If for some reason, neither creates a
> + * compile-time error, we'll still have a link-time error, which is harder to
> + * track down.
>   */
>  #ifndef __OPTIMIZE__
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  #else
> -extern int __build_bug_on_failed;
> -#define BUILD_BUG_ON(condition)					\
> -	do {							\
> -		bool __cond = !!(condition);			\
> -		((void)sizeof(char[1 - 2*!!(__cond)]));		\
> -		if (__cond) __build_bug_on_failed = 1;		\
> +#define BUILD_BUG_ON(condition)						\
> +	do {								\
> +		bool __cond = !!(condition);				\
> +		extern void __build_bug_on_failed(void)			\
> +			__compiletime_error("BUILD_BUG_ON failed");	\
> +		if (__cond)						\
> +			__build_bug_on_failed();			\
> +		((void)sizeof(char[1 - 2*!!(__cond)]));			\
>  	} while(0)
>  #endif
>  
