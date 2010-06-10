Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab0FJN3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:29:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40375 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0FJN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ABnNIyOkyUCWzP+AjoMKljgtuIHFmliwgoF5/6Kv5MRq4vFRRALGRGLBf6X7RIPR+B
         mlFJ8xWQEOvdQDpwtTOZAs4Zuw0NpS2949xH9+5SQKQIos1oEUtt0hxC62XHMMIxEnJQ
         eIAGR9w2kluc9KVifMIB5VBnBJtHtoWR08/OE=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 1/2] Cleanup: use for_each_online_cpu in vmstat
Date: Thu, 10 Jun 2010 22:28:46 +0900
Message-Id: <1276176526-2952-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sum_vm_events passes cpumask for for_each_cpu.
But it's useless since we have for_each_online_cpu.
Althougth it's tirival overhead, it's not good about
coding consistency.

Let's use for_each_online_cpu instead of for_each_cpu with
cpumask argument.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
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

