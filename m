Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1LPIOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:14:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58115 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870Ab1LPION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:14:13 -0500
Date: Fri, 16 Dec 2011 09:14:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 4/6] x86, mce: Add mechanism to safely save information
 in MCE handler
Message-ID: <20111216081410.GA9508@aftab>
References: <cover.1323979146.git.tony.luck@intel.com>
 <5d6588ab3dadabd8334cffee06b3e87abe3b81b7.1323979146.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6588ab3dadabd8334cffee06b3e87abe3b81b7.1323979146.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 03:55:20PM -0800, Tony Luck wrote:
> Machine checks on Intel cpus interrupt execution on all cpus, regardless
> of interrupt masking.  We have a need to save some data about the cause
> of the machine check (physical address) in the machine check handler that
> can be retrieved later to attempt recovery in a more flexible execution
> state.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   43 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 645070f..7d7303a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -887,6 +887,49 @@ static void mce_clear_state(unsigned long *toclear)
>  }
>  
>  /*
> + * Need to save faulting physical address associated with a process
> + * in the machine check handler some place where we can grab it back
> + * later in mce_notify_process()
> + */
> +#define	MAX_MCE_INFO	16
> +
> +struct mce_info {
> +	atomic_t		inuse;
> +	struct task_struct	*t;
> +	__u64			paddr;
> +} mce_info[MAX_MCE_INFO];
> +
> +static void mce_save_info(__u64 addr)
> +{
> +	struct mce_info *mi;
> +
> +	for (mi = mce_info; mi < &mce_info[MAX_MCE_INFO]; mi++) {

This looks strange, although valid. I thought we do

	for (i = 0; i < MCE_INFO_MAX; i++) {
		struct mce_info *mi = &mce_info[i];

		...

in such loops. Just a nitpick I guess.

> +		if (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) {
> +			mi->t = current;
> +			mi->paddr = addr;
> +			return;
> +		}
> +	}
> +
> +	mce_panic("Too many concurrent recoverable errors", NULL, NULL);

So we're setting an artificial limit of 16 in-flight AR errors and if >
16, we're panicking? Do we really want to do that? I guess we do... I got
nothing better anyway.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
