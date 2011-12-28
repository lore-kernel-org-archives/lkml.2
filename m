Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1L1AKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 19:10:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1L1AKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 19:10:35 -0500
Date: Tue, 27 Dec 2011 16:10:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yanmin_zhang@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
        len.brown@intel.com, mingmingx.zhang@intel.com
Subject: Re: [Fwd: [patch] intel_idle: Delete meaningless
 local_irq_disable() call in intel_idle.c.]
Message-Id: <20111227161034.1969c006.akpm@linux-foundation.org>
In-Reply-To: <1324862905.3860.1.camel@ymzhang>
References: <1324862905.3860.1.camel@ymzhang>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011 09:28:20 +0800
Yanmin Zhang <yanmin_zhang@linux.intel.com> wrote:

> Andrew,
> 
> Would you like to accept the patch into your testing tree?

hm, that's three indel_idle patches which I have now.  Someone wake up
lenb!

> intel_idle.c is a bit misleading in a sense that local_irq_disable,it
> actually does nothing. Real irq disable happens earlier in process_32.c:cpu_idle.
> Basically, cpuidle_state->enter is called, cpu irq is disabled.
> cpuidle_state->enter would turn on irq when exiting.
> 
> intel_idle doesn't follow this assumption. Although it doesn't
> cause real issue, it misleads developers. Below patch deletes
> the calling to local_irq_disable() at entry.
> 
> Signed-off-by: mzha38X <mingmingx.zhang@intel.com>
> ---
>  drivers/idle/intel_idle.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 5d2f8e1..28f0394 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -247,8 +247,6 @@ static int intel_idle(struct cpuidle_device *dev,
>  
>  	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
>  
> -	local_irq_disable();
> -
>  	/*
>  	 * leave_mm() to avoid costly and often unnecessary wakeups
>  	 * for flushing the user TLB's associated with the active mm.

I'd suggest adding this as well:

--- a/drivers/idle/intel_idle.c~drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call-fix
+++ a/drivers/idle/intel_idle.c
@@ -232,6 +232,7 @@ static int get_driver_data(int cstate)
  * @drv: cpuidle driver
  * @index: index of cpuidle state
  *
+ * Must be called under local_irq_disable().
  */
 static int intel_idle(struct cpuidle_device *dev,
 		struct cpuidle_driver *drv, int index)
_

