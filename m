Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab1G0FBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:01:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56222 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1G0FBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:01:48 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/2] [S390] irq: fix show_interrupts() vs cpu hotplug
Date: Wed, 27 Jul 2011 12:56:23 +0800
Message-Id: <1311742583-18633-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311742583-18633-1-git-send-email-yong.zhang0@gmail.com>
References: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
 <1311742583-18633-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current usage of get_online_cpus()/put_online_cpus()
in show_interrupts() is not correct since show_interrupts()
will be called nr_irqs times, during that period, cpu hotplug
could also happen.
Since have moved the protection to upper(patch#1), the pair of
get_online_cpus()/put_online_cpus() could be removed here.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/irq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index e3264f6..57c036d 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -63,7 +63,6 @@ int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;
 
-	get_online_cpus();
 	if (i == 0) {
 		seq_puts(p, "           ");
 		for_each_online_cpu(j)
@@ -83,7 +82,6 @@ int show_interrupts(struct seq_file *p, void *v)
 			seq_printf(p, "  %s", intrclass_names[i].desc);
                 seq_putc(p, '\n');
         }
-	put_online_cpus();
         return 0;
 }
 
-- 
1.7.4.1

