Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2FEPPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:15:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35117 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2FEPPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:15:45 -0400
Date: Tue, 5 Jun 2012 17:15:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v5 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120605151542.GA10669@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ShuoX Liu <shuox.liu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>
References: <4FBF3295.7090608@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>
 <1338165058.14538.209.camel@ymzhang.sh.intel.com>
 <4FC2E8CF.2040109@intel.com>
 <4FC2E944.6060903@intel.com>
 <20120604171202.GA8533@x1.osrc.amd.com>
 <1338856360.14538.220.camel@ymzhang.sh.intel.com>
 <20120605081448.GA7097@liondog.tnic>
 <4FCDD72A.9030701@intel.com>
 <4FCDD78A.3070106@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FCDD78A.3070106@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 05:55:22PM +0800, ShuoX Liu wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
> 
> On x86 machines, some times MCE happens just when kernel calls printk
> to output some log info to serial console, while usually MCE module in
> kernel is used to print out some hardware error information, such like
> bad cache or bad memory bank. That causes printk recursion and printk
> would omit MCE printk output.
> 
> We hit it when running MTBF testing on Android ATOM mobiles.
> 
> Here in mce_panic, we choose to disable printk recursion to make sure
> MCE logs printed out.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 2afcbd2..906e838 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -306,6 +306,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
>  {
>  	int i, apei_err = 0;
>  
> +	printk_recursion_check_disable();
>  	if (!fake_panic) {
>  		/*
>  		 * Make sure only one CPU runs in machine check panic
> @@ -360,6 +361,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
>  		panic(msg);
>  	} else
>  		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
> +	printk_recursion_check_enable();

Ok, let me ask this again: why not disable the printk recursion check in
the function that actually _prints_ the MCE, i.e. print_mce() instead of
here in mce_panic() which does a whole bunch of other stuff and it can
also return without printing any MCE to dmesg?

Are you interested in seeing the printk's from mce_panic? Why?

Thanks.

-- 
Regards/Gruss,
Boris.
