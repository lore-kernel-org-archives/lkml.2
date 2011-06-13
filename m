Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1FMSBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:01:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:57058 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1FMSBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,359,1304319600"; 
   d="scan'208";a="13972363"
Message-Id: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 13 Jun 2011 10:58:32 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com
Subject: [patch v4 0/2] enhance stop machine infrastructure for MTRR rendezvous sequence
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch enhance the stop machine infrastructure so that we
can call __stop_machine() from the cpu hotplug path, where the calling
cpu is not yet online. We do allow this for already for !CONFIG_SMP. So this
patch brings the CONFIG_SMP behavior inline with !CONFIG_SMP

Second patch uses the enhanced __stop_machine() to implement the x86 MTRR
init rendezvous sequence and thus remove the duplicate implementation
of stop machine using stop_one_cpu_nowait(). This duplicate implementation
of stop machine can potentially lead to deadlock if there is a parallel
system wide rendezvous using __stop_machine().

Both these address one of the deadlocks mentioned in the
https://bugzilla.novell.com/show_bug.cgi?id=672008

Changes from v1:
* Use stop_cpu thread enabled status to find out if the cpu is online/offline,
  instead of using cpu_online(smp_processor_id()). This avoids a false
  positive of using smp_processor_id() from preemptible section.

Changes from v2:
* Use cpu_all_mask, instead of NULL mask to include the calling cpu that is
  offline.
* Make __stop_cpus static
* Conslidate wait_for_completion/polling code into
  cpu_stop_wait_for_completion() based on Tejun's review.

Changes from v3:
* Make only __stop_machine() to be called from the cpu that is not yet online
* No changes to stop_cpus() API, that can be called only from an online cpu
* Take the stop_cpus_mutex using mutex_trylock when called from the not yet
  online cpu.
* Go back to cpu_online() checks using raw_smp_processor_id() instead
  of stop_cpu thread status to determine whether calling cpu is online/offline.
  This is safe and easier to understand.

thanks,
suresh


