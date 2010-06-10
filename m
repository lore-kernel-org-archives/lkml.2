Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab0FJNcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:32:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46079 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab0FJNcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rIkcb5VwpKKy/VLKn0D0bCACeVSf5NegCjNUbZkeH33kK3xxRU0wW5dnc038JCkKyD
         /LKCXBKm7Hh4qPDTrRfgustVqT77F2Ht3YIi2OivlIA/046moxmoiXR9JKbuV+IBVmzt
         PEn9BOVPXOqOs024OIq9oOK6xBhIN3nyWHCeo=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>
Subject: [mmotm] Cleanup: use for_each_online_cpu in vmstat
Date: Thu, 10 Jun 2010 22:32:31 +0900
Message-Id: <1276176751-2990-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. It's not [1/2] and I used Chrisopth's old mail address.
Resend. 

--

The sum_vm_events passes cpumask for for_each_cpu.
But it's useless since we have for_each_online_cpu.
Althougth it's tirival overhead, it's not good about
coding consistency.

Let's use for_each_online_cpu instead of for_each_cpu with
cpumask argument.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmstat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7759941..15a14b1 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -22,14 +22,14 @@
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
-static void sum_vm_events(unsigned long *ret, const struct cpumask *cpumask)
+static void sum_vm_events(unsigned long *ret)
 {
 	int cpu;
 	int i;
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu(cpu, cpumask) {
+	for_each_online_cpu(cpu) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
@@ -45,7 +45,7 @@ static void sum_vm_events(unsigned long *ret, const struct cpumask *cpumask)
 void all_vm_events(unsigned long *ret)
 {
 	get_online_cpus();
-	sum_vm_events(ret, cpu_online_mask);
+	sum_vm_events(ret);
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
-- 
1.7.0.5

