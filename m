Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1FJJdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:33:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51999 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1FJJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:33:30 -0400
Date: Fri, 10 Jun 2011 11:33:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 04/10] MCE: Move ADDR/MISC reading code into common
 function
Message-ID: <20110610093312.GA1621@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
 <4df13bf927261abd27@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df13bf927261abd27@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 05:32:41PM -0400, Luck, Tony wrote:
> From: Andi Kleen <andi@firstfloor.org>
> 
> Used for next patch.

Yeah, let's have a more general comment here like "save us some code
duplication"

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index cbd4b0f..0349e87 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -532,6 +532,17 @@ static void mce_report_event(struct pt_regs *regs)
>  #endif
>  }
>  
> +/*
> + * Read ADDR and MISC registers.
> + */

No need for that comment, IMO. Function is small enough and the macros
speak for themselves :).

> +static void mce_read_aux(struct mce *m, int i)

inline?

> +{
> +	if (m->status & MCI_STATUS_MISCV)
> +		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
> +	if (m->status & MCI_STATUS_ADDRV)
> +		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
> +}
> +
>  DEFINE_PER_CPU(unsigned, mce_poll_count);
>  
>  /*
> @@ -582,10 +593,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
>  			continue;
>  
> -		if (m.status & MCI_STATUS_MISCV)
> -			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
> -		if (m.status & MCI_STATUS_ADDRV)
> -			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
> +		mce_read_aux(&m, i);
>  
>  		if (!(flags & MCP_TIMESTAMP))
>  			m.tsc = 0;
> @@ -1027,10 +1035,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  		if (severity == MCE_AR_SEVERITY)
>  			kill_it = 1;
>  
> -		if (m.status & MCI_STATUS_MISCV)
> -			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
> -		if (m.status & MCI_STATUS_ADDRV)
> -			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
> +		mce_read_aux(&m, i);
>  
>  		/*
>  		 * Action optional error. Queue address for later processing.
> -- 
> 1.7.3.1
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
