Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1FJJnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:43:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54656 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab1FJJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:42:59 -0400
Date: Fri, 10 Jun 2011 11:42:42 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 05/10] MCE: Mask out address mask bits below address
 granuality
Message-ID: <20110610094242.GC1621@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
 <4df13c362729376e2@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df13c362729376e2@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 05:33:42PM -0400, Luck, Tony wrote:
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

s/granuality/granularity/g;

I would very much like to know how you guys got 'granularity' wrong
_three_ times in one small patch?!!

:-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
