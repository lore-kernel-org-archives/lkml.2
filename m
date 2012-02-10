Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab2BJXUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:20:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760509Ab2BJWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:10 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.088663066@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiang Liu <jiang.liu@huawei.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 23/86] kprobes: fix a memory leak in function pre_handler_kretprobe()
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 55ca6140e9bb307efc97a9301a4f501de02a6fd6 upstream.

In function pre_handler_kretprobe(), the allocated kretprobe_instance
object will get leaked if the entry_handler callback returns non-zero.
This may cause all the preallocated kretprobe_instance objects exhausted.

This issue can be reproduced by changing
samples/kprobes/kretprobe_example.c to probe "mutex_unlock".  And the fix
is straightforward: just put the allocated kretprobe_instance object back
onto the free_instances list.

[akpm@linux-foundation.org: use raw_spin_lock/unlock]
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1673,8 +1673,12 @@ static int __kprobes pre_handler_kretpro
 		ri->rp = rp;
 		ri->task = current;
 
-		if (rp->entry_handler && rp->entry_handler(ri, regs))
+		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
+			raw_spin_lock_irqsave(&rp->lock, flags);
+			hlist_add_head(&ri->hlist, &rp->free_instances);
+			raw_spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
+		}
 
 		arch_prepare_kretprobe(ri, regs);
 


