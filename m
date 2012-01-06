Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab2AFQtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:49:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59914 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2AFQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:49:38 -0500
Message-ID: <4F07261A.6080403@gmail.com>
Date: Sat, 07 Jan 2012 00:49:30 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Hien Nguyen <hien@us.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Prasanna S Panchamukhi <prasanna@in.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kprobe: fix a memory leak in function pre_handler_kretprobe()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu<liuj97@gmail.com>

In function pre_handler_kretprobe(), the allocated kretprobe_instance object will
be leaked if the entry_handler callback returns non-zero. This may cause all the
preallocated kretprobe_instance objects exhausted. This issue could be reproduced
by changing samples/kprobes/kretprobe_example.c to probe "mutex_unlock". And the
fix is straight forward, just put the allocated kretprobe_instance object back
onto the free_instances list.

Signed-off-by: Jiang Liu<liuj97@gmail.com>
Cc: Hien Nguyen<hien@us.ibm.com>
Cc: Jim Keniston<jkenisto@us.ibm.com>
Cc: Prasanna S Panchamukhi<prasanna@in.ibm.com>
---
  kprobes.c |    6 +++++-
  1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1660,8 +1660,12 @@
                 ri->rp = rp;
                 ri->task = current;

-               if (rp->entry_handler&&  rp->entry_handler(ri, regs))
+               if (rp->entry_handler&&  rp->entry_handler(ri, regs)) {
+                       spin_lock_irqsave(&rp->lock, flags);
+                       hlist_add_head(&ri->hlist,&rp->free_instances);
+                       spin_unlock_irqrestore(&rp->lock, flags);
                         return 0;
+               }

                 arch_prepare_kretprobe(ri, regs);


