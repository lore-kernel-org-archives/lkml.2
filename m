Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2FGESj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab2FGESf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:35 -0400
Message-Id: <20120607040342.445926602@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:18 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 42/82] x86: Reset the debug_stack update counter
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit c0525a6972d3f1fb83058ef503e183475d6e4e26 upstream.

When an NMI goes off and it sees that it preempted the debug stack,
to keep the debug stack safe, it changes the IDT to point to one that
does not modify the stack on breakpoint (to allow breakpoints in NMIs).

But the variable that gets set to know to undo it on exit never gets
cleared on exit. Thus every NMI will reset it on exit the first time
it is done even if it does not need to be reset.

[ Added H. Peter Anvin's suggestion to use this_cpu_read/write ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/nmi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -491,14 +491,16 @@ static inline void nmi_nesting_preproces
 	 */
 	if (unlikely(is_debug_stack(regs->sp))) {
 		debug_stack_set_zero();
-		__get_cpu_var(update_debug_stack) = 1;
+		this_cpu_write(update_debug_stack, 1);
 	}
 }
 
 static inline void nmi_nesting_postprocess(void)
 {
-	if (unlikely(__get_cpu_var(update_debug_stack)))
+	if (unlikely(this_cpu_read(update_debug_stack))) {
 		debug_stack_reset();
+		this_cpu_write(update_debug_stack, 0);
+	}
 }
 #endif
 


