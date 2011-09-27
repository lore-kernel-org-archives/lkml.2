Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1I0MUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:20:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51212 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1I0MUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:20:48 -0400
Date: Tue, 27 Sep 2011 14:20:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: linux-next: manual merge of the rcu tree with Linus' tree
Message-ID: <20110927122041.GL18553@somewhere>
References: <20110927160411.7bcec0906847959fb6e88a81@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927160411.7bcec0906847959fb6e88a81@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 04:04:11PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rcu tree got a conflict in
> arch/x86/kernel/process_64.c between commit a0bfa1373859 ("cpuidle: stop
> depending on pm_idle") from Linus' tree and commit 18349ca4b42e ("x86:
> Enter rcu extended qs after idle notifier call") from the rcu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/x86/kernel/process_64.c
> index f693e44,dee2e6c..0000000
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@@ -137,8 -136,12 +137,14 @@@ void cpu_idle(void
>   			enter_idle();
>   			/* Don't trace irqs off for idle */
>   			stop_critical_timings();
> - 			if (cpuidle_idle_call())
> + 
>  -			/* enter_idle() needs rcu for notifiers */
>  -			rcu_enter_nohz();
>  -			pm_idle();
>  -			rcu_exit_nohz();
> ++			if (cpuidle_idle_call()) {
> ++				/* enter_idle() needs rcu for notifiers */
> ++				rcu_enter_nohz();
>  +				pm_idle();
> ++				rcu_exit_nohz();
> ++			}
> + 
>   			start_critical_timings();
>   
>   			/* In many cases the interrupt that ended idle

Looks good, thanks!
