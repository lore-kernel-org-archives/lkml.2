Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab1LPAOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:14:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54116 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab1LPAOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:14:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EEA8D3A.7050205@jp.fujitsu.com>
Date: Fri, 16 Dec 2011 09:13:46 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] x86, mce: create helper function to save addr/misc
 when needed
References: <cover.1323803130.git.tony.luck@intel.com> <f00f81fe745bf8323f24fa6eeced59f211b01de9.1323803130.git.tony.luck@intel.com>
In-Reply-To: <f00f81fe745bf8323f24fa6eeced59f211b01de9.1323803130.git.tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/14 2:48), Tony Luck wrote:
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 265139d..43f22c8 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -492,6 +492,27 @@ static void mce_report_event(struct pt_regs *regs)
>  	irq_work_queue(&__get_cpu_var(mce_irq_work));
>  }
>  
> +/*
> + * Read ADDR and MISC registers.
> + */
> +static void mce_read_aux(struct mce *m, int i)
> +{
> +	if (m->status & MCI_STATUS_MISCV)
> +		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
> +	if (m->status & MCI_STATUS_ADDRV) {
> +		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
> +
> +		/*
> +		 * Mask the reported address by the reported granularity.
> +		 */
> +		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
> +			u8 shift = m->misc & 0x3f;

(nitpick) You can use:

#define MCI_MISC_ADDR_LSB(m)    ((m) & 0x3f)

> +			m->addr >>= shift;
> +			m->addr <<= shift;
> +		}
> +	}
> +}
> +
>  DEFINE_PER_CPU(unsigned, mce_poll_count);
>  
>  /*

Thanks,
H.Seto

