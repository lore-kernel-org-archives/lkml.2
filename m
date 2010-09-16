Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0IPUpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:45:25 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:39571 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0IPUpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:45:24 -0400
X-Greylist: delayed 1671 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 16:45:18 EDT
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Date: Thu, 16 Sep 2010 16:16:14 -0400
Subject: [PATCH] Fix kexec abort due to IPI from panic().
Thread-Topic: [PATCH] Fix kexec abort due to IPI from panic().
Thread-Index: ActV23frgU2iJtDkTHK/vPC8dXBdJAAACVmw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C0979C90E@USINDEVS01.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm Seiji Aguchi.
I work for Hitachi Data Systems.
It's a first time to send a patch to lkml.
Nice to meet you.
 
I found an issue in kexec.
Please give me your comments and suggestions.
 
Kexec abort when two cpus panic at the same time.
An example scenario:
1. Two cpus panic at the same time .
2. One cpu ,cpu0, get kexec_mutex in crash_kexec().
3. The other cpu ,cpu1, can't get kexec_mutex and return from crash_kexec().
4. Cpu0 runs kmsg_dump(KMSG_DUMP_KEXEC).
5. Cpu1 can't get dump_list_lock and return from kmsg_dump(KMSG_DUMP_PANIC).
6. Cpu1 runs smp_send_stop() in panic() and sends IPI to other cpus.
7. Cpu0 may receive IPI from cpu1 while running kmsg_dump(KMSG_DUMP_KEXEC),
   crash_setup_regs(), or crash_save_vmcore().
 
We can solve this issue by disabling external interrupt while getting kexec_mutex 
in crash_kexec().


 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 kernel/kexec.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index c0613f7..9e9f159 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1075,6 +1075,10 @@ void crash_kexec(struct pt_regs *regs)
 	 * sufficient.  But since I reuse the memory...
 	 */
 	if (mutex_trylock(&kexec_mutex)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
@@ -1085,6 +1089,9 @@ void crash_kexec(struct pt_regs *regs)
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
+
+		local_irq_restore(flags);
+
 		mutex_unlock(&kexec_mutex);
 	}
 }
-- 
1.7.2.2


Regards,

Seiji
