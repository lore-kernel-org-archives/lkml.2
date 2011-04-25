Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab1DYKld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:41:33 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:56462 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab1DYKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:41:32 -0400
Message-ID: <4DB54FD3.2090007@linux.vnet.ibm.com>
Date: Mon, 25 Apr 2011 16:11:23 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 11/18] cpuidle: stop using pm_idle
References: <alpine.LFD.2.02.1104010020280.2797@x980> <1301725380-10579-1-git-send-email-lenb@kernel.org>  <5f8cf82855ca448698efe66f48779972ad08ffc0.1301724243.git.len.brown@intel.com>
In-Reply-To: <5f8cf82855ca448698efe66f48779972ad08ffc0.1301724243.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/02/2011 11:52 AM, Len Brown wrote:
> From: Len Brown<len.brown@intel.com>
>
> pm_idle does not scale as an idle handler registration mechanism.
> Don't use it for cpuidle.  Instead, call cpuidle directly, and
> allow architectures to use pm_idle as an arch-specific default
> if they need it.  ie.
>
> cpu_idle()
> 	...
> 	if(cpuidle_call_idle())
> 		pm_idle();
>

Hi Len,

This doesn't compile right now for ARM. The patch below
(on top of your series) is required to compile on arm, sh

Thanks,
-Trinabh

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index d7ee0d4..1a347f4 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -197,7 +197,7 @@ void cpu_idle(void)
  				cpu_relax();
  			} else {
  				stop_critical_timings();
-				if (cpuidle_call_idle())
+				if (cpuidle_idle_call())
  					pm_idle();
  				start_critical_timings();
  				/*
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 9c7099e..1db1968 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -101,7 +101,7 @@ void cpu_idle(void)
  			local_irq_disable();
  			/* Don't trace irqs off for idle */
  			stop_critical_timings();
-			if (cpuidle_call_idle())
+			if (cpuidle_idle_call())
  				pm_idle();
  			/*
  			 * Sanity check to ensure that pm_idle() returns
