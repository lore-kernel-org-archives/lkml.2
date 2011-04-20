Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1DTU2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:28:13 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45673 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1DTU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:28:11 -0400
Subject: Re: x86: tsc: make TSC calibration more immune to interrupts
From: john stultz <johnstul@us.ibm.com>
To: Kasper Pedersen <kernel@kasperkp.dk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <4DAF37B4.3040408@kasperkp.dk>
References: <4DAF2B57.6010100@kasperkp.dk>
	 <1303326959.2796.136.camel@work-vm>  <4DAF37B4.3040408@kasperkp.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 13:28:00 -0700
Message-ID: <1303331280.2796.154.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 21:44 +0200, Kasper Pedersen wrote:
> With the delayed workqueue patch, I see a wonderful 0.4ppm
> offset _almost_ all of the time.
> 
> Very rarely though (about 1 in 3000) the value output by
> "Refined TSC .." jumps. It can jump no further than
> 50000/F_TSC/delayed_time, so on a modern machine it jumps
> no further than 20ppm.
> 
> This can happen when a short irq occurs between
> *p = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
> and
> t2 = get_cycles();
> 
> 
> Without the delayed workqueue patch 30ppm is insignificant.

Thanks for the additional details!

In that case, the patch seems reasonable to me.

If the additional ~200us (I suspect 100us is a little low, as acpi pm
can take ~3.5us access time * 5 * 8 = 140us) is an issue, you could
probably add a "good vs best" flag, which would decide between returning
the first value that is under the SMI_THRESHOLD vs your method of
returning the best value with the lowest uncertainty. This would allow
us to only use it in the refined calibration where the smaller noise
reduction makes a difference.

Ingo, Thomas, any other complaints?

thanks
-john


