Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0IXQwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:52:25 -0400
Received: from kroah.org ([198.145.64.141]:38397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab0IXQ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:33 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.880742629@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>
Subject: [46/80] percpu: fix pcpu_last_unit_cpu
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1413,9 +1413,9 @@ int __init pcpu_setup_first_chunk(const
 
 			if (pcpu_first_unit_cpu == NR_CPUS)
 				pcpu_first_unit_cpu = cpu;
+			pcpu_last_unit_cpu = cpu;
 		}
 	}
-	pcpu_last_unit_cpu = cpu;
 	pcpu_nr_units = unit;
 
 	for_each_possible_cpu(cpu)


