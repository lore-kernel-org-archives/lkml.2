Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2JQPeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:34:22 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48099 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2JQPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:34:21 -0400
Date: Wed, 17 Oct 2012 11:35:06 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: perf: p6 PMU working by accident, should we fix it and KNC?
Message-ID: <alpine.DEB.2.02.1210171125040.23371@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

quick summary: the p6 code looks to be buggy and is only currently
   working by luck.  I'm trying to work out how to best fix the KNC
   code which is based on the p6 PMU driver.

While working on the KNC PMU we ran into the following problem.

Between 2.6.33 and 2.6.34 the kernel was changed to have a much
more elaborate PMU initialization routine.

The new x86_pmu_enable() routine starts with cpuc->enabled set to 0.
  It then calls x86_pmu_start(event)
  Which then calls x86_pmu.enable(event)

On both p6 and KNC, x86_pmu.enable(event) is conditioned not to do
anything unless cpuc->enabled is set to 1 (the generic x86 enable does not 
have this limitation).

Only at the end of x86_pmu_enable() is cpuc->enabled set to 1.

On KNC this means that the counter setup does not happen properly.

This should also be the case on P6, but mysteriously things *do* work, as 
I just verified by brining my poor PII machine out of retirement.

This is by accident; it looks like the code does 
   val |= ARCH_PERFMON_EVENTSEL_ENABLE;
in p6_pmu_disable_event() so that events are never truly disabled
(is this a bug?  should it be &=~ instead?).  
This doesn't cause problems because P6_NOP_EVENT
is used in the disabled case so no spurious counts are generated.

So I have two questions:
  1.  Is it worth fixing the p6 code?
  2.  Is it OK to drop the cpuc->enabled test in KNC for event 
      enable/disable?  The driver works fine with that dropped, and
      the regular intel x86 driver doesn't have those tests.

Thanks,

Vince
