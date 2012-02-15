Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2BOL1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:27:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:39338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab2BOL1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:27:04 -0500
Message-ID: <1329305197.2293.50.camel@twins>
Subject: Re: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com,
        seiji.aguchi@hds.com, ak@linux.intel.com, mjg@redhat.com,
        levinsasha928@gmail.com
Date: Wed, 15 Feb 2012 12:26:37 +0100
In-Reply-To: <1329164860-668-3-git-send-email-dzickus@redhat.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
	 <1329164860-668-3-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 15:27 -0500, Don Zickus wrote:
> Due to reschedule changes in v3.3, a WARN_ON has popped up
> because a cpu suddenly became offline without letting anyone
> know.
> 
> This results in the schedule trying to move something to another
> cpu only to find out it isn't there and getting confused.  The splat
> looks something like:

<snip>

> I solved this by re-using the atomic global variable that is set during
> native_smp_stop_other_cpus().  This is the piece of code that causes the
> problem and it sets stopping_cpu to reflect the system is going down.
> 
> If the variable is set do not yell with the WARN_ON, just return.
> 
> v2:  use if-condition for WARN-ON instead of if {WARN_ON(1)}
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/smp.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 48d2b7d..54d570e 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -120,7 +120,8 @@ static bool smp_no_nmi_ipi = false;
>  static void native_smp_send_reschedule(int cpu)
>  {
>  	if (unlikely(cpu_is_offline(cpu))) {
> -		WARN_ON(1);
> +		/* system is not shutting down.. yell */
> +		WARN_ON(atomic_read(&stopping_cpu) == -1)
>  		return;
>  	}
>  	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);


Right, so this fixes this one particular case, I imagine there's tons of
places that could go splat due to this (but don't quite yet for some
reason).

We can't go around annotating everything, nor would we want to simply
shut up all warnings for fear of missing an actual error.

Why can't the normal shut-down path use a less crazy approach to going
down?
