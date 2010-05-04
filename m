Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab0EDAXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:23:41 -0400
Received: from mx1.corp.avencall.com ([91.194.178.12]:51242 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0EDAXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:23:39 -0400
Date: Tue, 4 May 2010 02:23:33 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Guillaume Knispel <gknispel@proformatique.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <linux@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 2/2] genirq: update doc
Message-Id: <20100504022333.7dbf61eb.gknispel@proformatique.com>
In-Reply-To: <20100504021941.ff7579c1.gknispel@proformatique.com>
References: <20100504021941.ff7579c1.gknispel@proformatique.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following "genirq: always build resend_irqs" and previous changes, this
commit updates the genirq DocBook.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
CC: linux-kernel@vger.kernel.org
CC: Linuxppc-dev@lists.ozlabs.org
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lars-Peter Clausen <lars@metafoo.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/DocBook/genericirq.tmpl |   73 ++++++++++++++++++--------------
 1 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
index 1448b33..7df5274 100644
--- a/Documentation/DocBook/genericirq.tmpl
+++ b/Documentation/DocBook/genericirq.tmpl
@@ -240,8 +240,6 @@ default_enable(irq)
 
 default_disable(irq)
 {
-	if (!delay_disable(irq))
-		desc->chip->mask(irq);
 }
 
 default_ack(irq)
@@ -264,7 +262,11 @@ noop(irq)
 }
 
 		</programlisting>
-	        </para>
+	        Note: default_disable() is empty so that an edge-triggered
+		interrupt happening between a disable_irq() and an enable_irq()
+		is caught by the kernel for later replay. See
+		<xref linkend="Delayed_interrupt_disable"/> for details.
+		</para>
 	    </sect3>
 	</sect2>
 	<sect2 id="Default_flow_handler_implementations">
@@ -278,9 +280,14 @@ noop(irq)
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-desc->chip->start();
+desc->chip->mask_ack();
+if (desc->status &amp; inprogress)
+	return;
+desc->status |= inprogress;
 handle_IRQ_event(desc->action);
-desc->chip->end();
+desc->status &amp;= inprogress;
+if (!(desc->status &amp; disabled))
+	desc->chip->unmask_ack();
 		</programlisting>
 		</para>
    	    </sect3>
@@ -293,21 +300,23 @@ desc->chip->end();
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-if (desc->status &amp; running) {
-	desc->chip->hold();
+if (desc->status &amp; (inprogress | disabled)) {
 	desc->status |= pending | masked;
+	desc->chip->mask_ack();
 	return;
 }
-desc->chip->start();
-desc->status |= running;
+desc->chip->ack();
+desc->status |= inprogress;
 do {
-	if (desc->status &amp; masked)
-		desc->chip->enable();
+	if ((desc->status &amp; (pending | masked | disabled))
+			     == (pending | masked)) {
+		desc->chip->unmask();
+		desc->status &amp;= ~masked;
+	}
 	desc->status &amp;= ~pending;
 	handle_IRQ_event(desc->action);
-} while (status &amp; pending);
-desc->status &amp;= ~running;
-desc->chip->end();
+} while ((status &amp; (pending | disabled)) == pending);
+desc->status &amp;= inprogress;
 		</programlisting>
 		</para>
    	    </sect3>
@@ -342,9 +351,9 @@ handle_IRQ_event(desc->action);
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-desc->chip->start();
+desc->chip->ack();
 handle_IRQ_event(desc->action);
-desc->chip->end();
+desc->chip->eoi();
 		</programlisting>
 		</para>
    	    </sect3>
@@ -361,22 +370,20 @@ desc->chip->end();
 	<sect2 id="Delayed_interrupt_disable">
 	<title>Delayed interrupt disable</title>
 	<para>
-	This per interrupt selectable feature, which was introduced by Russell
-	King in the ARM interrupt implementation, does not mask an interrupt
-	at the hardware level when disable_irq() is called. The interrupt is
-	kept enabled and is masked in the flow handler when an interrupt event
-	happens. This prevents losing edge interrupts on hardware which does
-	not store an edge interrupt event while the interrupt is disabled at
-	the hardware level. When an interrupt arrives while the IRQ_DISABLED
-	flag is set, then the interrupt is masked at the hardware level and
-	the IRQ_PENDING bit is set. When the interrupt is re-enabled by
-	enable_irq() the pending bit is checked and if it is set, the
-	interrupt is resent either via hardware or by a software resend
-	mechanism. (It's necessary to enable CONFIG_HARDIRQS_SW_RESEND when
-	you want to use the delayed interrupt disable feature and your
-	hardware is not capable of retriggering	an interrupt.)
-	The delayed interrupt disable can be runtime enabled, per interrupt,
-	by setting the IRQ_DELAYED_DISABLE flag in the irq_desc status field.
+	At least when using default_disable as the ->disable() callback of a
+	chip handler, an interrupt is not masked at the hardware level when
+	disable_irq() is called. The interrupt is kept enabled and is masked
+	in the flow handler when an interrupt event happens. This prevents
+	losing edge interrupts on hardware which does not store an edge
+	interrupt event while the interrupt is disabled at the hardware level.
+	This makes use of the replay mechanism that is mandatory anyway to
+	prevent potential race conditions between an interrupt event and a call
+	to disable_irq() at the same time. When an interrupt arrives in
+	handle_edge_irq() while the IRQ_DISABLED flag is set, then the
+	interrupt is masked at the hardware level and the IRQ_PENDING bit is
+	set. When the interrupt is re-enabled by enable_irq() the pending bit
+	is checked and if it is set, the interrupt is resent either via
+	hardware or by a software resend mechanism.
 	</para>
 	</sect2>
     </sect1>
@@ -387,6 +394,8 @@ desc->chip->end();
 	contains all the direct chip relevant functions, which
 	can be utilized by the irq flow implementations.
 	  <itemizedlist>
+	  <listitem><para>disable() - Optional</para></listitem>
+	  <listitem><para>enable() - Optional</para></listitem>
 	  <listitem><para>ack()</para></listitem>
 	  <listitem><para>mask_ack() - Optional, recommended for performance</para></listitem>
 	  <listitem><para>mask()</para></listitem>
-- 
1.6.2
