Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1ABHv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:51:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:35759 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1ABHXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 134/260] percpu: fix pcpu_last_unit_cpu
Date: Sun,  2 Jan 2011 02:17:10 -0500
Message-Id: <1293952756-15010-135-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:36.0946 (UTC) FILETIME=[D4CADF20:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 46b30ea9bc3698bc1d1e6fd726c9601d46fa0a91 upstream.

pcpu_first/last_unit_cpu are used to track which cpu has the first and
last units assigned.  This in turn is used to determine the span of a
chunk for man/unmap cache flushes and whether an address belongs to
the first chunk or not in per_cpu_ptr_to_phys().

When the number of possible CPUs isn't power of two, a chunk may
contain unassigned units towards the end of a chunk.  The logic to
determine pcpu_last_unit_cpu was incorrect when there was an unused
unit at the end of a chunk.  It failed to ignore the unused unit and
assigned the unused marker NR_CPUS to pcpu_last_unit_cpu.

This was discovered through kdump failure which was caused by
malfunctioning per_cpu_ptr_to_phys() on a kvm setup with 50 possible
CPUs by CAI Qian.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 6e09741..717cc6e 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1750,9 +1750,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 			if (pcpu_first_unit_cpu == NR_CPUS)
 				pcpu_first_unit_cpu = cpu;
+			pcpu_last_unit_cpu = cpu;
 		}
 	}
-	pcpu_last_unit_cpu = cpu;
 	pcpu_nr_units = unit;
 
 	for_each_possible_cpu(cpu)
-- 
1.7.3.3

