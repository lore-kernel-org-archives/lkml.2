Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab1FIWil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:38:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:19160 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1FIWih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="12231289"
Message-Id: <20110609223211.006948233@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 09 Jun 2011 15:32:11 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com
Subject: [patch v3 0/2] enhance stop machine infrastructure for MTRR rendezvous sequence
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

Both these address the deadlock mentioned in the
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

thanks,
suresh


