Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2AONks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:40:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53120 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab2AONkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:40:47 -0500
Date: Sun, 15 Jan 2012 14:40:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120115134035.GA24657@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 8030c36d13f030103356709e63638678fdc66fdc x86, atomic: atomic64_read() take a const pointer

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, atomic: atomic64_read() take a const pointer

Jack Steiner (1):
      x86, UV: Update Boot messages for SGI UV2 platform


 arch/x86/include/asm/atomic64_32.h |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 24098aa..fa13f0e 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -82,7 +82,7 @@ static inline void atomic64_set(atomic64_t *v, long long i)
  *
  * Atomically reads the value of @v and returns it.
  */
-static inline long long atomic64_read(atomic64_t *v)
+static inline long long atomic64_read(const atomic64_t *v)
 {
 	long long r;
 	asm volatile(ATOMIC64_ALTERNATIVE(read)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 9d59bba..79b05b8 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -769,7 +769,12 @@ void __init uv_system_init(void)
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
 		uv_possible_blades +=
 		  hweight64(uv_read_local_mmr( UVH_NODE_PRESENT_TABLE + i * 8));
-	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
+
+	/* uv_num_possible_blades() is really the hub count */
+	printk(KERN_INFO "UV: Found %d blades, %d hubs\n",
+			is_uv1_hub() ? uv_num_possible_blades() :
+			(uv_num_possible_blades() + 1) / 2,
+			uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kzalloc(bytes, GFP_KERNEL);
