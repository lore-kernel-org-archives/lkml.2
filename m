Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2EKHi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab2EKHiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:38:22 -0400
Date: Fri, 11 May 2012 10:38:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 4/7] x86: eoi micro-optimization
Message-ID: <766cee729b1198bf37ac3e8a34c56f0d45768e95.1336679924.git.mst@redhat.com>
References: <cover.1336679924.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336679924.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We know both register and value for eoi beforehand,
so there's no need to check it and no need to do math
to calculate the msr. Saves instructions/branches
on each EOI when using x2apic.

I'm not sure what kind of tests should one run
to check whether this patch is good for performance.

Some data below: in case it's insufficient,
this patch can be dropped from the series for now:

I looked at the objdump output to verify that the generated code
looks right and actually is shorter.

Some benchmark results below show a tiny
but measureable improvement. The tests were run on
an AMD box with 24 cpus.

- A clean kernel build after reboot shows
a tiny but measureable improvement in system time
which means lower CPU overhead (though not measureable
in total time - that is dominated by user time and fluctuates
too much):

linux# reboot -f
...
linux# make clean
linux# time make -j 64 LOCALVERSION= 2>&1 > /dev/null

Before:

real    2m52.244s
user    35m53.833s
sys     6m7.194s

After:

real    2m52.827s
user    35m48.916s
sys     6m2.305s

- perf micro-benchmarks seem to consistently show
  a tiny improvement in total time as well but it's below
  the confidence level of 3 std deviations:

# ./tools/perf/perf   stat --sync --repeat 100 --null perf bench sched messaging
...
       0.414666797 seconds time elapsed ( +-  1.29% )

Performance counter stats for 'perf bench sched messaging' (100 runs):

       0.395370891 seconds time elapsed
( +-  1.04% )


# ./tools/perf/perf   stat --sync --repeat 100 --null perf bench sched pipe -l 10000
       0.307019664 seconds time elapsed
( +-  0.10% )

       0.304738024 seconds time elapsed
( +-  0.08% )


Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/apic.h           |    5 +++++
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 74efb8d..5eb6d56 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -138,6 +138,11 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 	wrmsr(APIC_BASE_MSR + (reg >> 4), v, 0);
 }
 
+static inline void native_apic_msr_eoi_write(u32 reg, u32 v)
+{
+	wrmsr(APIC_BASE_MSR + (APIC_EOI >> 4), APIC_EOI_ACK, 0);
+}
+
 static inline u32 native_apic_msr_read(u32 reg)
 {
 	u64 msr;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index a5baa78..ff35cff 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -260,7 +260,7 @@ static struct apic apic_x2apic_cluster = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
-	.eoi_write			= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8340356..c17e982 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -172,7 +172,7 @@ static struct apic apic_x2apic_phys = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
-	.eoi_write			= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 5b0e3d0..c6d03f7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -404,7 +404,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
-	.eoi_write			= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
-- 
MST

