Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1FJIHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:07:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36974 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1FJIHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:07:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF1D0B1.1020302@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 17:07:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 05/10] MCE: Mask out address mask bits below address granuality
References: <4df13c362729376e2@agluck-desktop.sc.intel.com>
In-Reply-To: <4df13c362729376e2@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/10 6:33), Luck, Tony wrote:
> From: Andi Kleen <andi@firstfloor.org>
> 
> SER enabled systems report the address granuality for each
> reported address in a machine check. But the bits below
> the granuality are undefined. Mask them out before
> logging the machine check.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 0349e87..ffc8d11 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -539,8 +539,18 @@ static void mce_read_aux(struct mce *m, int i)
>  {
>  	if (m->status & MCI_STATUS_MISCV)
>  		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
> -	if (m->status & MCI_STATUS_ADDRV)
> +	if (m->status & MCI_STATUS_ADDRV) {
>  		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
> +
> +		/*
> +		 * Mask the reported address by the reported granuality.
> +		 */
> +		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
> +			u8 shift = m->misc & 0x1f;
> +			m->addr >>= shift;
> +			m->addr <<= shift;
> +		}
> +	}
>  }
>  
>  DEFINE_PER_CPU(unsigned, mce_poll_count);

Why do you have to mask it out in kernel, why not in user/logger?

One possible story is:
  "... the brand-new Xeon XXXX has new MCx_***_VALID bit in ****
  register, if it is set the lower bits of MCx_ADDR indicates
  ****, otherwise the bits are undefined ..."

So I think that kernel should convey the raw value from hardware to
userland.  Even if it contains some noise on it, user can determine
whether it is useful or not.  And more, since this is an error record,
there will be no second chance to retrieve the data afterward.


Thanks,
H.Seto

