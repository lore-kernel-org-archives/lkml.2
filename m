Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab1DAEYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:24:19 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:54460 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DAEYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:24:17 -0400
Date: Fri, 01 Apr 2011 00:24:08 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] x86 idle cruft removal - v2
In-reply-to: <1301551404-8263-1-git-send-email-lenb@kernel.org>
Message-id: <alpine.LFD.2.02.1104010020280.2797@x980>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
 <1301551404-8263-1-git-send-email-lenb@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review feedback that this change is too sudden.
How about this plan with a 4-month delay?

cheers,
-Len Brown, Intel Open Source Technology Center

2.6.39-rc1
----------

x86 idle: deprecate floppy disable_hlt
	feature-removal.txt for 2.6.40 (4 months)
	WARN_ONCE on use
	cc: stable@kernel.org

x86 idle APM: deprecate apm_cpu_idle
	feature-removal.txt for 2.6.40 (4 months)
	#warning on CONFIG_APM_CPU_IDLE remove in 2.6.40
	WARN_ONCE in apm_cpu_idle()
	cc: stable@kernel.org

x86 idle: export pm_idle only for CONFIG_APM_MODULE
	like we do for default_idle(),
	EXPORT_SYMBOL(pm_idle) only on CONFIG_APM_MODULE

x86 idle: deprecate "no-hlt" cmdline param
	feature-removal.txt for 2.6.40 (4 months)
	cc stable@kernel.org
	WARN_ONCE if used, ask if idle=poll is sufficient
	same as idle=poll, except no-hlt also disables
		HLT in machine_halt().

x86 idle: deprecate "idle=mwait"
	feature-removal.txt for 2.6.40 (4 months)
	cc stable@kernel.org
	WARN_ONCE on invocation

x86 idle: re-name ce1_idle
	rename for clarity, no functional change

2.6.40-merge
------
x86 idle: move mwait_idle_with_hints()
	out of process.c to cstate.c, make static

x86 idle floppy: remove deprecated disable_hlt/enable_hlt

x86 idle: delete deprecated idle=mwait
	default_idle() can use HLT

cpuidle: add cmdline "cpuidle=off"
	allow falling back to native default_idle

x86 idle xen: stop touching pm_idle and default_idle
	Xen Dom0 kernel only needs HLT, but include
	CPU_IDLE, ACPI etc for running on bare hardware.
	So when running in Xen Dom0 mode, disable cpuidle
	to fall back to default_idle.

x86 idle APM: remove deprecated apm_cpu_idle()
	and its use of pm_idle

x86 idle cpuidle: delete public use of pm_idle
	make pm_idle and default_idle static to process.c
	add return value from cpu_idle_call()
	invoke cpu_idle_call from cpu_idle() rather than via pm_idle

	cpu_idle() {
		...
		if (cpu_idle_call())
			pm_idle();	/* non cpuidle default */
	}

x86 idle: remove "no-hlt" cmdline param
	remove deprecated "no-hlt"
	use idle=poll instead

x86 idle: remove cpuinfo_x86.hlt_works_ok flag
	it became a NOP when "no-hlt" was removed

x86 idle: remove hlt_works()
	it became a NOP when cpuinfo_x86.hlt_works_ok was removed
