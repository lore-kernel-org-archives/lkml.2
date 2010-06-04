Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab0FDByM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:54:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756498Ab0FDByK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:54:10 -0400
Date: Thu, 3 Jun 2010 18:54:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: mmotm 2010-06-03-16-36 uploaded
Message-Id: <20100603185401.1851c94e.akpm@linux-foundation.org>
In-Reply-To: <AANLkTilX_Fbc_pR1jtgQJsvu7RbMfgyhJYCxqV725T18@mail.gmail.com>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
	<AANLkTilX_Fbc_pR1jtgQJsvu7RbMfgyhJYCxqV725T18@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 09:41:58 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> On Fri, Jun 4, 2010 at 7:36 AM,  <akpm@linux-foundation.org> wrote:
> > The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to
> >
> > __ http://userweb.kernel.org/~akpm/mmotm/
> >
> 
> Hi, intel_idle build fails:
> 
> drivers/idle/intel_idle.c: In function ___intel_idle___:
> drivers/idle/intel_idle.c:234: error: too few arguments to function ___trace_power
> _start___
> make[2]: *** [drivers/idle/intel_idle.o] Error 1
> make[1]: *** [drivers/idle] Error 2
> make[1]: *** Waiting for unfinished jobs....
> 

Caused by
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent.patch
which changed trace_power_start().

drivers/idle/intel_idle.c wasn't there when Thomas wrote that patch.

this, I guess:

--- a/drivers/idle/intel_idle.c~x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix
+++ a/drivers/idle/intel_idle.c
@@ -231,7 +231,7 @@ static int intel_idle(struct cpuidle_dev
 
 	stop_critical_timings();
 #ifndef MODULE
-	trace_power_start(POWER_CSTATE, (eax >> 4) + 1);
+	trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
 #endif
 	if (!need_resched()) {
 
_


it's a bit odd that all trace_power_start() callers just pass in
smp_processor_id().  Why not do it within trace_power_start() itself?


