Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2DPLcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:32:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43621 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2DPLcf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 16 Apr 2012 07:32:35 -0400
Message-Id: <4F8C1F6D020000780007E11A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 16 Apr 2012 12:32:29 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, "Tim Deegan" <tim@xen.org>,
        "Sheng Yang" <sheng@yasker.org>
Subject: Re: [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.04.12 at 20:20, David Vrabel <david.vrabel@citrix.com> wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> The sched clock was considered stable based on the capabilities of the
> underlying hardware.  This does not make sense for Xen PV guests as:
> a) the hardware TSC is not used directly as the clock source; and b)
> guests may migrate to hosts with different hardware capabilities.
> 
> It is not clear to me whether the Xen clock source is supposed to be
> stable and whether it should be stable across migration.  For a clock
> source to be stable it must be: a) monotonic; c) synchronized across
> CPUs; and c) constant rate.
> 
> There have also been reports of systems with apparently unstable
> clocks where clearing sched_clock_stable has fixed problems with
> migrated VMs hanging.
> 
> So, always set the sched clock as unstable when using the Xen clock
> source.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  arch/x86/xen/time.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 0296a95..8469b5a 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -473,6 +473,7 @@ static void __init xen_time_init(void)
>  	do_settimeofday(&tp);
>  
>  	setup_force_cpu_cap(X86_FEATURE_TSC);
> +	sched_clock_stable = 0;

This, unfortunately, is not sufficient afaict: If a CPU gets brought up
post-boot, the variable may need to be cleared again. Instead you
ought to call mark_tsc_unstable().

Jan

>  
>  	xen_setup_runstate_info(cpu);
>  	xen_setup_timer(cpu);
> -- 
> 1.7.2.5



