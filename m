Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1IEJTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:19:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:42886 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1IEJT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,332,1312182000"; 
   d="scan'208";a="45638361"
Message-ID: <4E64941B.2070708@linux.intel.com>
Date: Mon, 05 Sep 2011 17:19:23 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/5] mce: mask out undefined bits from MCi_ADDR
References: <4e5eb4e821049d6d79@agluck-desktop.sc.intel.com>
In-Reply-To: <4e5eb4e821049d6d79@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/9/1 6:25, Luck, Tony 写道:
> From: Tony Luck<tony.luck@intel.com>
>
> Move duplicate copies of the code that reads ADDR/MISC registers
> to a function. Add masking code for systems that have undefined
> low-order bits in the MCi_ADDR register.
>
> Based on original code by Andi Kleen
>
> Signed-off-by: Tony Luck<tony.luck@intel.com>
> ---
>
> Andi originally posted this as two patches - one to move the common
> code to the new function "mce_read_aux()", the second to add the
> masking.
> Seto-san objected to the masking on the grounds that the bits might
> contain something useful - but after some thought, I agree with Andi
> that it is better to drop undefined bits.
>
>   arch/x86/kernel/cpu/mcheck/mce.c |   31 +++++++++++++++++++++++--------
>   1 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 91bb983..1ce64c3 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -490,6 +490,27 @@ static void mce_report_event(struct pt_regs *regs)
>   	irq_work_queue(&__get_cpu_var(mce_irq_work));
>   }
>
> +/*
> + * Read ADDR and MISC registers.
> + */
> +static void mce_read_aux(struct mce *m, int i)
> +{
> +	if (m->status&  MCI_STATUS_MISCV)
> +		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
> +	if (m->status&  MCI_STATUS_ADDRV) {
> +		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
> +
> +		/*
> +		 * Mask the reported address by the reported granuality.
> +		 */
> +		if (mce_ser&&  (m->status&  MCI_STATUS_MISCV)) {
> +			u8 shift = m->misc&  0x1f;

According to SDM, here it should be "m->misc & 0x3f"

