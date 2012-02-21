Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2BUCG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:06:27 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63257 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2BUCGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:06:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.229.136.72 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86: Cleanup and simplify cpu-specific data
Date: Mon, 20 Feb 2012 22:06:01 -0400
Message-Id: <1329789966-693-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120217115627.GA25601@elte.hu>
References: <20120217115627.GA25601@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various per-cpu fields are define in arch/x86/kernel/smpboot.c that are
basically equivalent to the cpu-specific data in struct cpuinfo_x86.
By moving these fields into the structure, a number of codepaths can be
simplified since they no longer need to care about those fields not
existing on !SMP builds.

The size effects on allno (UP) and allyes (MAX_SMP) kernels are as
follows:

   text	   	data	    	bss	    	dec	    	hex	filename
1586721	 	304864	 	506208		2397793	 	249661	vmlinux.allno
1588517	 	304928	 	505920		2399365	 	249c85	vmlinux.allno.after
84706053	13212311	42434560	140352924	85d9d9c	vmlinux.allyes
84705333	13213799	42434560	140353692	85da09c	vmlinux.allyes.afte

As can be seen, the kernels get slighly larger, but the code reduction/
simplification should be enough to compensate for it.

Kevin Winchester (5):
  x86: Move per cpu cpu_llc_shared_map to a field in struct cpuinfo_x86
  x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
  x86: Move per cpu cpu_sibling_map to a field in struct cpuinfo_x86
  x86: Move per cpu cpu_core_map to a field in struct cpuinfo_x86
  x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings
    into common.c

 arch/x86/include/asm/perf_event_p4.h  |    9 +--
 arch/x86/include/asm/processor.h      |    7 +++
 arch/x86/include/asm/smp.h            |   26 +---------
 arch/x86/include/asm/topology.h       |   10 ++--
 arch/x86/kernel/apic/apic_numachip.c  |    2 +-
 arch/x86/kernel/cpu/amd.c             |   18 ++-----
 arch/x86/kernel/cpu/common.c          |    7 ++-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   19 ++-----
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 ++-
 arch/x86/kernel/cpu/proc.c            |    8 +--
 arch/x86/kernel/cpu/topology.c        |    2 -
 arch/x86/kernel/process.c             |    3 +-
 arch/x86/kernel/smpboot.c             |   95 +++++++++++++--------------------
 arch/x86/oprofile/nmi_int.c           |    6 --
 arch/x86/oprofile/op_model_p4.c       |   11 +----
 arch/x86/xen/smp.c                    |    6 --
 drivers/cpufreq/acpi-cpufreq.c        |    2 +-
 drivers/cpufreq/p4-clockmod.c         |    4 +-
 drivers/cpufreq/powernow-k8.c         |   13 +----
 drivers/cpufreq/speedstep-ich.c       |    6 +-
 drivers/hwmon/coretemp.c              |    6 +--
 21 files changed, 86 insertions(+), 181 deletions(-)

-- 
1.7.9

