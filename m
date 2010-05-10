Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab0EJWzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:55:22 -0400
Received: from kroah.org ([198.145.64.141]:33382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab0EJWwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:54 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:26 2010
Message-Id: <20100510223326.235702413@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [098/117] sparc64: Fix hardirq tracing in trap return path.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 28a1f533ae8606020238b840b82ae70a3f87609e ]

We can overflow the hardirq stack if we set the %pil here
so early, just let the normal control flow do it.

This is fine as we are allowed to do the actual IRQ enable
at any point after we call trace_hardirqs_on.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/rtrap_64.S |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/sparc/kernel/rtrap_64.S
+++ b/arch/sparc/kernel/rtrap_64.S
@@ -172,7 +172,17 @@ rtrap_xcall:
 		 nop
 		call			trace_hardirqs_on
 		 nop
-		wrpr			%l4, %pil
+		/* Do not actually set the %pil here.  We will do that
+		 * below after we clear PSTATE_IE in the %pstate register.
+		 * If we re-enable interrupts here, we can recurse down
+		 * the hardirq stack potentially endlessly, causing a
+		 * stack overflow.
+		 *
+		 * It is tempting to put this test and trace_hardirqs_on
+		 * call at the 'rt_continue' label, but that will not work
+		 * as that path hits unconditionally and we do not want to
+		 * execute this in NMI return paths, for example.
+		 */
 #endif
 rtrap_no_irq_enable:
 		andcc			%l1, TSTATE_PRIV, %l3


