Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2CELoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 06:44:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab2CELoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 06:44:20 -0500
Message-ID: <4F54A6FF.50502@redhat.com>
Date: Mon, 05 Mar 2012 08:43:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/4] EDAC: Convert AMD EDAC pieces to use RAS printk buffer
References: <1330698314-9863-1-git-send-email-bp@amd64.org> <1330698314-9863-5-git-send-email-bp@amd64.org> <4F50DECB.8030200@redhat.com> <20120305110441.GC1070@aftab>
In-Reply-To: <20120305110441.GC1070@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-03-2012 08:04, Borislav Petkov escreveu:
> On Fri, Mar 02, 2012 at 11:52:59AM -0300, Mauro Carvalho Chehab wrote:
> 
> [..]
> 
>> 	- the "ras_agent" helper functions is used only for amd64_edac. There's
>> no reason for use it elsewhere;
> 
> [..]
> 
> That can be fixed very easily with the patch below ontop of the current
> series (I'll add a proper version of it to the series later). This way,
> one does ras_printk() and builds up the message and then, when its done,
> calls into the tracepoint like this:
> 
> 	trace_mce_record(ras_get_decoded_err(), m);
> 
> where m is struct mce.

It is still adding an amd64-specific code inside the core, as no other driver will
use the amd64 "ras_agent".

Instead of doing that, you should do the opposite: call the EDAC report function
passing ras_get_decoded_err() as the string parameter of the function. This way,
the EDAC core will work the same way with amd64 and with the other drivers.

> 
> The result is:
> 
> [Hardware Error]: CPU:0 MC4_STATUS[-|UE|-|PCC|AddrV|UECC]: 0xb607a10009080a23 MC4_ADDR: 0x0000000955647380
> [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
> [Hardware Error]: EDAC MC2: UE page 0x955647, offset 0x380, grain 0, row 2, labels ":": amd64_edac
> 
> ^^^ This line comes from the respective edac driver.
> 
> [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: WR, part-proc: RES (no timeout)
> [Hardware Error]: CPU: 0, MCGc/s: 0/0, MC4: b607a10009080a23, ADDR/MISC: 0000000955647380/dead57ac1ba0babe, RIP: 00:<0000000000000000>, TSC: 0, TIME: 0, SOCKET: 0
> 
> 
>> non MCA drivers should also generate tracepoints;
> 
> yes, they should define a tracepoint which fits the hardware error
> reporting scheme they're using.

If nobody objects, I'll add my changes to linux-next, as it was tested on most
systems. I'll remove the MCE-specific tracepoint from my code, keeping the trace
there for the other stuff.

> 
> --
> diff --git a/arch/x86/include/asm/ras.h b/arch/x86/include/asm/ras.h
> index 92199af2ab7b..b51838514259 100644
> --- a/arch/x86/include/asm/ras.h
> +++ b/arch/x86/include/asm/ras.h
> @@ -6,8 +6,8 @@
>  extern bool ras_agent;
>  
>  #define PR_EMERG	BIT(0)
> -#define PR_WARNING	BIT(1)
> -#define PR_CONT		BIT(2)
> +#define PR_WARNING	BIT(4)
> +#define PR_CONT		BIT(8)
>  
>  extern const char *ras_get_decoded_err(void);
>  extern void ras_printk(unsigned long flags, const char *fmt, ...);
> diff --git a/arch/x86/ras/ras.c b/arch/x86/ras/ras.c
> index 5edfe30034d3..868d732c6cd4 100644
> --- a/arch/x86/ras/ras.c
> +++ b/arch/x86/ras/ras.c
> @@ -52,7 +52,7 @@ void ras_printk(unsigned long flags, const char *fmt, ...)
>  	if (!ras_agent) {
>  		if (flags & PR_EMERG)
>  			pr_emerg("%s", buf);
> -		if (flags & PR_WARNING)
> +		else if (flags & PR_WARNING)
>  			pr_warning("%s", buf);
>  		else if (flags & PR_CONT)
>  			pr_cont("%s", buf);
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 29e153c57e33..c0f31f953c70 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1902,10 +1902,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
>  	sys_addr = get_error_address(m);
>  	syndrome = extract_syndrome(m->status);
>  
> -	if (ras_agent)
> -		ras_printk(PR_EMERG, "ERR_ADDR: 0x%llx", sys_addr);
> -	else
> -		amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
> +	amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
>  
>  	pvt->ops->map_sysaddr_to_csrow(mci, sys_addr, syndrome);
>  }
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index e48ab3108ad8..62a32b3fa660 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -49,8 +49,17 @@
>  #define edac_printk(level, prefix, fmt, arg...) \
>  	printk(level "EDAC " prefix ": " fmt, ##arg)
>  
> -#define edac_mc_printk(mci, level, fmt, arg...) \
> -	printk(level "EDAC MC%d: " fmt, mci->mc_idx, ##arg)
> +#define edac_mc_printk(mci, level, fmt, arg...)					\
> +({										\
> +	if (ras_agent) {							\
> +		unsigned pr_lvl = BIT((unsigned)(level[1] - '0'));		\
> +										\
> +		ras_printk(pr_lvl, HW_ERR "EDAC MC%d" fmt,			\
> +			   mci->mc_idx, ##arg);					\
> +	}									\
> +	else									\
> +		printk(level "EDAC MC%d: " fmt, mci->mc_idx, ##arg);		\
> +})
>  
>  #define edac_mc_chipset_printk(mci, level, prefix, fmt, arg...) \
>  	printk(level "EDAC " prefix " MC%d: " fmt, mci->mc_idx, ##arg)
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 3b3db477b5d0..446853a303c4 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -703,11 +703,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
>  		return;
>  	}
>  
> -	if (edac_mc_get_log_ce()) {
> -		if (ras_agent)
> -			ras_printk(PR_CONT, ", row: %d, channel: %d\n",
> -				   row, channel);
> -		else
> +	if (edac_mc_get_log_ce())
>  			/* FIXME - put in DIMM location */
>  			edac_mc_printk(mci, KERN_WARNING,
>  					"CE page 0x%lx, offset 0x%lx, grain %d,"
> @@ -718,7 +714,6 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
>  					row, channel,
>  					mci->csrows[row].channels[channel].label,
>  					msg);
> -	}
>  
>  	mci->ce_count++;
>  	mci->csrows[row].ce_count++;
> @@ -790,16 +785,12 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
>  		pos += chars;
>  	}
>  
> -	if (edac_mc_get_log_ue()) {
> -		if (ras_agent)
> -			ras_printk(PR_CONT, "row: %d\n", row);
> -		else
> +	if (edac_mc_get_log_ue())
>  			edac_mc_printk(mci, KERN_EMERG,
>  				       "UE page 0x%lx, offset 0x%lx, grain %d,"
>  				       " row %d, labels \"%s\": %s\n",
>  				       page_frame_number, offset_in_page,
>  				       mci->csrows[row].grain, row, labels, msg);
> -	}
>  
>  	if (edac_mc_get_panic_on_ue())
>  		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
> 

