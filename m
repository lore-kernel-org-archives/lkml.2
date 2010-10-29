Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0J2HYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 03:24:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53434 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0J2HYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 03:24:32 -0400
Date: Fri, 29 Oct 2010 09:24:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H.Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [x86, next] Add mce_sys_info interface for debug.
Message-ID: <20101029072426.GB29995@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jin Dongming <jin.dongming@np.css.fujitsu.com>,
	Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
	"H.Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	LKLM <linux-kernel@vger.kernel.org>
References: <4CCA50AF.1030302@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CCA50AF.1030302@np.css.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 01:42:23PM +0900, Jin Dongming wrote:
> Add mce_sys_info interface for testing mce.
> 
> Following is the reason why the interface is needed:
>   1. Sometimes before testing mce, we want to know the basic
>      information of mce on the test machine. Though there are
>      some provided interfaces, there are some kernel variables
>      which could not be known still.
>   2. When we inject mce data to test mce, the value of some
>      interfaces may be changed. It is hard for everybody to confirm
>      all the information of mce on the system.
> 
> This interface could help us know what has happened and make mce test
> become easier.
> 
> The content of mce_sys_info will be like following:
> 
>   MCE status:                      Original/(Current) Value
>       mce_disabled:                N
> 
>       mce_ser:                     0/1
>       tolerant:                    1/1
>       panic_on_oops:               0/0
>       monarch_timeout:             1000000/1000000 us
>       mce_ignore_ce:               0/0
>       mce_cmci_disabled:           N/N
> 
>   MCG Register:
>       CAP_Reg_Val           BANKS    EXT_CNT    FUNCTIONS
>       0x0000000000000806    0x06     0x00       TES
> 
> Please note that it is used for testing only.
> 
> I tested this patch on Intel64 next-tree.
> 
> Signe-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |  126 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 126 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index ed10e76..91108db 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -97,6 +97,25 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
>  static DEFINE_PER_CPU(struct mce, mces_seen);
>  static int			cpu_missing;
>  
> +#ifdef CONFIG_DEBUG_FS
> +struct mce_sys_info {
> +	int mce_disabled;
> +
> +	u64 mcg_cap_register;
> +
> +	int mce_ser;
> +	int tolerant;
> +	int panic_on_oops;
> +	int monarch_timeout;
> +	int mce_cmci_disable;
> +	int mce_ignore_ce;
> +	int mce_cmci_disabled;

Most of those could be put in a flags vector, thus saving a bunch of
space. Or a bitfield...

-- 
Regards/Gruss,
    Boris.
