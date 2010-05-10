Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab0EJX2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:28:45 -0400
Received: from kroah.org ([198.145.64.141]:33385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab0EJWwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:55 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:26 2010
Message-Id: <20100510223326.324421544@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [099/117] sparc64: Use kstack_valid() in die_if_kernel().
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit cb256aa60409efd803806cfb0528a4b3f8397dba ]

This gets rid of a local function (is_kernel_stack()) which tries to
do the same thing, yet poorly in that it doesn't handle IRQ stacks
properly.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/traps_64.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2202,27 +2202,6 @@ void dump_stack(void)
 
 EXPORT_SYMBOL(dump_stack);
 
-static inline int is_kernel_stack(struct task_struct *task,
-				  struct reg_window *rw)
-{
-	unsigned long rw_addr = (unsigned long) rw;
-	unsigned long thread_base, thread_end;
-
-	if (rw_addr < PAGE_OFFSET) {
-		if (task != &init_task)
-			return 0;
-	}
-
-	thread_base = (unsigned long) task_stack_page(task);
-	thread_end = thread_base + sizeof(union thread_union);
-	if (rw_addr >= thread_base &&
-	    rw_addr < thread_end &&
-	    !(rw_addr & 0x7UL))
-		return 1;
-
-	return 0;
-}
-
 static inline struct reg_window *kernel_stack_up(struct reg_window *rw)
 {
 	unsigned long fp = rw->ins[6];
@@ -2251,6 +2230,7 @@ void die_if_kernel(char *str, struct pt_
 	show_regs(regs);
 	add_taint(TAINT_DIE);
 	if (regs->tstate & TSTATE_PRIV) {
+		struct thread_info *tp = current_thread_info();
 		struct reg_window *rw = (struct reg_window *)
 			(regs->u_regs[UREG_FP] + STACK_BIAS);
 
@@ -2258,8 +2238,8 @@ void die_if_kernel(char *str, struct pt_
 		 * find some badly aligned kernel stack.
 		 */
 		while (rw &&
-		       count++ < 30&&
-		       is_kernel_stack(current, rw)) {
+		       count++ < 30 &&
+		       kstack_valid(tp, (unsigned long) rw)) {
 			printk("Caller[%016lx]: %pS\n", rw->ins[7],
 			       (void *) rw->ins[7]);
 


