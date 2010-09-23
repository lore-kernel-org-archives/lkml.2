Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0IWI6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:58:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:59307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab0IWI6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:58:32 -0400
Message-ID: <4C9B168A.9000702@kernel.org>
Date: Thu, 23 Sep 2010 10:57:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, CAI Qian <caiqian@redhat.com>
Subject: [GIT PULL] percpu: fixes for v2.6.36-rc5
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 08:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive a percpu fix for
v2.6.36-rc5.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

It contains only one patch to fix incorrect pcpu_last_unit_cpu
initialization.  When the number of possible CPUs isn't power of two,
there can be unused holes at the end of each percpu chunk.  Percpu
init code uses NR_CPUS to mark these holes.  pcpu_last_unit_cpu should
contain the CPU which maps to the last unit in the chunk but when the
above condition occurs, it contained NR_CPUS instead, which makes
percpu code miscalculate the address range covered by a chunk for
per_cpu_ptr_to_phys() and tlb and v[un]map flushses and has potential
to cause weird issues especially on virtual cache architectures.

This problem was discovered by CAI Qian during kvm kdump testing.
Kudos to him for finding this subtle problem.

Thanks.

Tejun Heo (1):
      percpu: fix pcpu_last_unit_cpu

 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 58c572b..c76ef38 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1401,9 +1401,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,

 			if (pcpu_first_unit_cpu == NR_CPUS)
 				pcpu_first_unit_cpu = cpu;
+			pcpu_last_unit_cpu = cpu;
 		}
 	}
-	pcpu_last_unit_cpu = cpu;
 	pcpu_nr_units = unit;

 	for_each_possible_cpu(cpu)
