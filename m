Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2EKHkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:40:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:23257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2EKHkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:40:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142675455"
Message-ID: <4FACC25B.80305@linux.intel.com>
Date: Fri, 11 May 2012 15:40:11 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] x86/mce: Add instruction recovery signatures to mce-severity
 table
References: <cover.1336674796.git.tony.luck@intel.com> <0e89440bf6444635bde0b876eedd26e5c51f9ca3.1336674796.git.tony.luck@intel.com>
In-Reply-To: <0e89440bf6444635bde0b876eedd26e5c51f9ca3.1336674796.git.tony.luck@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/5/11 2:12, Tony Luck 写道:
> Instruction recovery cases are very similar to the data recovery one
> we already have. Just trade out for a new MCACOD value.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce-severity.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index 0c82091..163c4364ca 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -126,6 +126,16 @@ static struct severity {
>  		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
>  		USER
>  		),
> +	MCESEV(
> +		KEEP, "HT thread notices Action required: instruction fetch error",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
> +		MCGMASK(MCG_STATUS_EIPV, 0)
> +		),
> +	MCESEV(
> +		AR, "Action required: instruction fetch error",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
> +		USER
> +		),
>  #endif
>  	MCESEV(
>  		PANIC, "Action required: unknown MCACOD",

For IFU, on affected logical processors, RIPV and EIPV both are 0,
since now new IFU entries are added into severity table, the old
entry as below should be removed:

/* Neither return not error IP -- no chance to recover -> PANIC */
        MCESEV(
                PANIC, "Neither restart nor error IP",
                MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
                ),

