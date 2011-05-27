Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab1E0Gqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:46:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43076 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab1E0Gqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:46:51 -0400
Date: Fri, 27 May 2011 08:46:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 03/12] mce-severity: cleanup severity table
Message-ID: <20110527064647.GC16811@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tony Luck <tony.luck@intel.com>
References: <4DDF21DE.9040705@jp.fujitsu.com>
 <4DDF22FA.4020406@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DDF22FA.4020406@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:05:14PM +0900, Hidetoshi Seto wrote:
> Current format of item in this table is:
>   condition(param, ..., level, message [, condition2 ...])
> 
> So we have to check both of head and tail of the item to know
> conditions to match the item.
> 
> Make them in straight forward form:
>   item(level, message, condition [, condition2 ...])
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce-severity.c |  127 +++++++++++++----------------
>  1 files changed, 58 insertions(+), 69 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index eaf5a43..b797913 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -43,116 +43,105 @@ static struct severity {
>  	unsigned char covered;
>  	char *msg;
>  } severities[] = {
> -#define KERNEL .context = IN_KERNEL
> -#define USER .context = IN_USER
> -#define SER .ser = SER_REQUIRED
> -#define NOSER .ser = NO_SER
> -#define SEV(s) .sev = MCE_ ## s ## _SEVERITY
> -#define BITCLR(x, s, m, r...) { .mask = x, .result = 0, SEV(s), .msg = m, ## r }
> -#define BITSET(x, s, m, r...) { .mask = x, .result = x, SEV(s), .msg = m, ## r }
> -#define MCGMASK(x, res, s, m, r...) \
> -	{ .mcgmask = x, .mcgres = res, SEV(s), .msg = m, ## r }
> -#define MASK(x, y, s, m, r...) \
> -	{ .mask = x, .result = y, SEV(s), .msg = m, ## r }
> +#define MCESEV(s, m, c...) { .sev = MCE_ ## s ## _SEVERITY, .msg = m, ## c }
> +#define  KERNEL		.context = IN_KERNEL
> +#define  USER		.context = IN_USER
> +#define  SER		.ser = SER_REQUIRED
> +#define  NOSER		.ser = NO_SER
> +#define  BITCLR(x)	.mask = x, .result = 0
> +#define  BITSET(x)	.mask = x, .result = x
> +#define  MCGMASK(x, y)	.mcgmask = x, .mcgres = y
> +#define  MASK(x, y)	.mask = x, .result = y
>  #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
>  #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
>  #define MCACOD 0xffff
>  
> -	BITCLR(
> -		MCI_STATUS_VAL,
> -		NO, "Invalid"
> +	MCESEV(
> +		NO, "Invalid",
> +		BITCLR(MCI_STATUS_VAL)
>  		),
> -	BITCLR(
> -		MCI_STATUS_EN,
> -		NO, "Not enabled"
> +	MCESEV(
> +		NO, "Not enabled",
> +		BITCLR(MCI_STATUS_EN)
>  		),
> -	BITSET(
> -		MCI_STATUS_PCC,
> -		PANIC, "Processor context corrupt"
> +	MCESEV(
> +		PANIC, "Processor context corrupt",
> +		BITSET(MCI_STATUS_PCC)
>  		),

I'm still wondering whether using the gcc struct assignment syntax could
make those much more readable instead of changing the macro inclusion:

	{
		.sev	= MCE_PANIC_SEVERITY,
		.msg	= "Processor context corrupt",
		.mask	= MCI_STATUS_PCC,
		.result	= MCI_STATUS_PCC,
	},
	...

I dunno, I have to say, I can read those better instead of eyeballing
the macros all the time to wonder which was it, was it a bitset or a
bitclr, or a mcg mask...

>  	/* When MCIP is not set something is very confused */
> -	MCGMASK(
> -		MCG_STATUS_MCIP, 0,
> -		PANIC, "MCIP not set in MCA handler"
> +	MCESEV(
> +		PANIC, "MCIP not set in MCA handler",
> +		MCGMASK(MCG_STATUS_MCIP, 0)
>  		),
>  	/* Neither return not error IP -- no chance to recover -> PANIC */
> -	MCGMASK(
> -		MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0,
> -		PANIC, "Neither restart nor error IP"
> +	MCESEV(
> +		PANIC, "Neither restart nor error IP",
> +		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
>  		),
> -	MCGMASK(
> -		MCG_STATUS_RIPV, 0,
> +	MCESEV(
>  		PANIC, "In kernel and no restart IP",
> -		KERNEL
> +		KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
>  		),
> -	BITCLR(
> -		MCI_STATUS_UC,
> +	MCESEV(
>  		KEEP, "Corrected error",
> -		NOSER
> +		NOSER, BITCLR(MCI_STATUS_UC)
>  		),
>  
>  	/* ignore OVER for UCNA */
> -	MASK(
> -		MCI_UC_SAR, MCI_STATUS_UC,
> +	MCESEV(
>  		KEEP, "Uncorrected no action required",
> -		SER
> +		SER, MASK(MCI_UC_SAR, MCI_STATUS_UC)
>  		),
> -	MASK(
> -		MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR,
> +	MCESEV(
>  		PANIC, "Illegal combination (UCNA with AR=1)",
> -		SER
> +		SER,
> +		MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR)
>  		),
> -	MASK(
> -		MCI_STATUS_S, 0,
> +	MCESEV(
>  		KEEP, "Non signalled machine check",
> -		SER
> +		SER, MASK(MCI_STATUS_S, 0)
>  		),
>  
>  	/* AR add known MCACODs here */
> -	MASK(
> -		MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR,
> +	MCESEV(
>  		PANIC, "Action required with lost events",
> -		SER
> +		SER,
> +		MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR)
>  		),
> -	MASK(
> -		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR,
> +	MCESEV(
>  		PANIC, "Action required; unknown MCACOD",
> -		SER
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
>  		),
>  
>  	/* known AO MCACODs: */
> -	MASK(
> -		MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0,
> +	MCESEV(
>  		AO, "Action optional: memory scrubbing error",
> -		SER
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0xc0)
>  		),
> -	MASK(
> -		MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a,
> +	MCESEV(
>  		AO, "Action optional: last level cache writeback error",
> -		SER
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x17a)
>  		),
> -
> -	MASK(
> -		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S,
> +	MCESEV(
>  		SOME, "Action optional unknown MCACOD",
> -		SER
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S)
>  		),
> -	MASK(
> -		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER,
> +	MCESEV(
>  		SOME, "Action optional with lost events",
> -		SER
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER)
>  		),
> -	BITSET(
> -		MCI_STATUS_UC|MCI_STATUS_OVER,
> -		PANIC, "Overflowed uncorrected"
> +
> +	MCESEV(
> +		PANIC, "Overflowed uncorrected",
> +		BITSET(MCI_STATUS_OVER|MCI_STATUS_UC)
>  		),
> -	BITSET(
> -		MCI_STATUS_UC,
> -		UC, "Uncorrected"
> +	MCESEV(
> +		UC, "Uncorrected",
> +		BITSET(MCI_STATUS_UC)
>  		),
> -	BITSET(
> -		0,
> -		SOME, "No match"
> +	MCESEV(
> +		SOME, "No match",
> +		BITSET(0)
>  		)	/* always matches. keep at end */
>  };
>  
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
