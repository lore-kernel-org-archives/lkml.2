Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0IUGNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:13:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:34796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab0IUGNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:13:10 -0400
Message-ID: <4C984D27.3050102@kernel.org>
Date: Tue, 21 Sep 2010 08:13:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>, lkml <linux-kernel@vger.kernel.org>
CC: graff yang <graff.yang@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        sonic adi <sonic.adi@gmail.com>,
        Chris Lalancette <clalance@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [PATCH] percpu: fix pcpu_last_unit_cpu
References: <1848241872.1438141285029613564.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1848241872.1438141285029613564.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 06:12:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
This is pretty subtle and has the potential to cause mysterious
problems on vcache architectuers.  Thanks a lot for discovering it and
your patience.  I'll put it out in linux-next for a couple of days and
push it to Linus and stable.

Thanks.

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
-- 
1.7.1

