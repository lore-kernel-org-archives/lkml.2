Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2FKJ4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:56:41 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:44166 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FKJ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:56:40 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ido Yariv <ido@wizery.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: [PATCH v5 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Mon, 11 Jun 2012 12:56:41 +0300
Message-ID: <2230701.XSbLcxrZ9Q@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.3 (Linux/3.2.0-24-generic; KDE/4.8.3; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pls., consider applying this patch series.
It contains the following changes:
 - Adds two new macros DEFINE_EARLY_PER_CPU_READ_MOSTLY() and
   DECLARE_EARLY_PER_CPU_READ_MOSTLY().
 - Adds "read-mostly" qualifier to the following variables in smp.h:
  - cpu_sibling_map
  - cpu_core_map
  - cpu_llc_shared_map
  - cpu_llc_id
  - cpu_number
  - x86_cpu_to_apicid
  - x86_bios_cpu_apicid
  - x86_cpu_to_logical_apicid

As long as all the variables above are only written during the initialization,
this change is meant to prevent the false sharing. More specifically, on vSMP 
Foundation platform x86_cpu_to_apicid shared the same internode_cache_line 
with frequently written lapic_events.

>From the analysis of the first 33 per_cpu variables  out of 219 (memories they 
describe, to be more specific) the 8 have read_mostly nature 
(tlb_vector_offset, cpu_loops_per_jiffy, xen_debug_irq, etc.) and 25 are 
frequently written (irq_stack_union, gdt_page, exception_stacks, idt_desc, 
etc.). Assuming that the spread of the rest of the per_cpu variables is 
similar, identifying the read mostly memories will make more sense in terms of 
long-term code maintenance comparing to identifying frequently written 
memories.

v5 changes:
- Changed the description of the patch series and patch 2:
  added the analysis of the current per-cpu varibles spread
  between the read-mostly and frequently written groups.

v4 changes:
- Fixed the authors signatures in the patches.

v3 changes:
- Added the missing definitions of DEFINE_EARLY_PER_CPU_READ_MOSTLY()
  and DECLARE_EARLY_PER_CPU_READ_MOSTLY() macros in the !CONFIG_SMP code
  path in arch/x86/include/asm/percpu.h.

thanks,
vlad

