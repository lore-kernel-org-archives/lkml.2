Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1FJIHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:07:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36967 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab1FJIHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:07:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF1D08B.100@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 17:06:35 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 02/10] MCE: save most severe error information
References: <4df13b81272475cf94@agluck-desktop.sc.intel.com>
In-Reply-To: <4df13b81272475cf94@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/10 6:30), Luck, Tony wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> monarch clears all of the per cpu "mces_seen", so we must keep a copy
> to use after mce_end()

Could you clarify why we have to use mces_seen after mce_end(), please?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 3385ea2..ed1542a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1046,6 +1046,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  		}
>  	}
>  
> +	/* Save our worst error locally, monarch will clear mces_seen */
> +	m = *final;
> +
>  	if (!no_way_out)
>  		mce_clear_state(toclear);
>  
> @@ -1064,7 +1067,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	 * support MCE broadcasting or it has been disabled.
>  	 */
>  	if (no_way_out && tolerant < 3)
> -		mce_panic("Fatal machine check on current CPU", final, msg);
> +		mce_panic("Fatal machine check on current CPU", &m, msg);
>  
>  	/*
>  	 * If the error seems to be unrecoverable, something should be

At least the mce_panic here is called only when there is no monarch
due to no broadcast or failed rendezvous. Otherwise if there is a monarch,
the monarch should check all "mces_seen" before clearing them and call
a single mce_panic() for the system from mce_end() by itself, rather than
having multiple mce_panic() from some of subjects after mce_end().


Thanks,
H.Seto

