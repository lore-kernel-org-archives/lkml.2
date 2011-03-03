Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab1CCVTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:19:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57851 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880Ab1CCVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:19:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A4N85d2ETZE1tzshF/wncTBDETm1Ckk+TM8pRxpBpJRcfss489zcJK6tPaqmwbQS+4
         h2KrscMroKaiSe9GIThICqHhLnZcrVj83ra64FW7fkPkQyxmMeep/WoscV+2SXvRBFJ9
         vcnjW/FboPBcUnXqovAmEj7jiJBoIIIrTZ/bc=
Message-ID: <4D7005D6.9050108@gmail.com>
Date: Fri, 04 Mar 2011 00:19:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] x86: make some apic symbols init
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-2-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1299182701-8591-2-git-send-email-henne@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 11:04 PM, Henrik Kretzschmar wrote:
> apic_force_enable(), apic_verify() and the variable
> force_enable_local_apic are only used by init code
> and now get marked as such.
> 
> Global __initdata variables may better be initialized,
> since they are in the data section and not in the bss.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
>  arch/x86/include/asm/apic.h |    2 +-
>  arch/x86/kernel/apic/apic.c |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index dbd558c..afe69e1 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -240,7 +240,7 @@ extern void setup_boot_APIC_clock(void);
>  extern void setup_secondary_APIC_clock(void);
>  extern int APIC_init_uniprocessor(void);
>  extern void enable_NMI_through_LVT0(void);
> -extern int apic_force_enable(unsigned long addr);
> +extern int apic_force_enable(unsigned long addr) __init;

Nope, we either should _check_ all the prototipes and fix them
either left them untouched. This will confuse code readers with "for
what reason some functions have __init, some -- not". So I rather
would fix this nit in different patch later which would address
all of them (if this would not break someone's queue).

>  
>  /*
>   * On 32bit this is mach-xxx local
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 6c464a3..022afb9 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -93,7 +93,7 @@ DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
>   *
>   * +1=force-enable
>   */
> -static int force_enable_local_apic;
> +static int force_enable_local_apic __initdata = 0;

Hmm, I fail to see why we need to set it to 0.

>  /*
>   * APIC command line parameters
>   */
> @@ -1560,7 +1560,7 @@ static int __init detect_init_APIC(void)
>  }
>  #else
>  
> -static int apic_verify(void)
> +static int __init apic_verify(void)
>  {
>  	u32 features, h, l;
>  
> @@ -1585,7 +1585,7 @@ static int apic_verify(void)
>  	return 0;
>  }
>  
> -int apic_force_enable(unsigned long addr)
> +int __init apic_force_enable(unsigned long addr)
>  {
>  	u32 h, l;
>  

Other looks good to me.

-- 
    Cyrill
