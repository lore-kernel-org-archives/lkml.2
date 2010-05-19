Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0ESSCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:02:22 -0400
Received: from claw.goop.org ([74.207.240.146]:48281 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0ESSCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:02:21 -0400
Message-ID: <4BF427AB.4080301@goop.org>
Date: Wed, 19 May 2010 11:02:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: ensure timer tick is resumed even on
 CPU	driving the resume
References: <1274283134.14939.205.camel@zakaz.uk.xensource.com> <1274283417-5224-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1274283417-5224-1-git-send-email-ian.campbell@citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 08:36 AM, Ian Campbell wrote:
> The core suspend/resume code is run from stop_machine on CPU0 but
> parts of the suspend/resume machinery (including xen_arch_resume) are
> run on whichever CPU happened to schedule the xenwatch kernel thread.
>
> As part of the non-core resume code xen_arch_resume is called in order
> to restart the timer tick on non-boot processors. The boot processor
> itself is taken care of by core timekeeping code.
>
> xen_arch_resume uses smp_call_function which does not call the given
> function on the current processor. This means that we can end up with
> one CPU not receiving timer ticks if the xenwatch thread happened to
> be scheduled on CPU > 0.
>
> Use on_each_cpu instead of smp_call_function to ensure the timer tick
> is resumed everywhere.
>   

Argh, that seems to be a pretty common trap to fall into.  Looks OK (but
unfortunately doesn't fix my other problem).

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J

> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Stable Kernel <stable@kernel.org>
> ---
>  arch/x86/xen/suspend.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
> index 987267f..a9c6611 100644
> --- a/arch/x86/xen/suspend.c
> +++ b/arch/x86/xen/suspend.c
> @@ -60,6 +60,6 @@ static void xen_vcpu_notify_restore(void *data)
>  
>  void xen_arch_resume(void)
>  {
> -	smp_call_function(xen_vcpu_notify_restore,
> -			       (void *)CLOCK_EVT_NOTIFY_RESUME, 1);
> +	on_each_cpu(xen_vcpu_notify_restore,
> +		    (void *)CLOCK_EVT_NOTIFY_RESUME, 1);
>  }
>   

