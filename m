Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab0I3XTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:19:22 -0400
Received: from www.tglx.de ([62.245.132.106]:43647 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913Ab0I3XTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:19:18 -0400
Message-Id: <20100930221740.154366183@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 17/47] genirq-update-kerneldoc.patch
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-update-kerneldoc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/DocBook/genericirq.tmpl |   82 +++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 31 deletions(-)

Index: linux-2.6-tip/Documentation/DocBook/genericirq.tmpl
===================================================================
--- linux-2.6-tip.orig/Documentation/DocBook/genericirq.tmpl
+++ linux-2.6-tip/Documentation/DocBook/genericirq.tmpl
@@ -28,7 +28,7 @@
   </authorgroup>
 
   <copyright>
-   <year>2005-2006</year>
+   <year>2005-2010</year>
    <holder>Thomas Gleixner</holder>
   </copyright>
   <copyright>
@@ -100,6 +100,10 @@
 	  <listitem><para>Edge type</para></listitem>
 	  <listitem><para>Simple type</para></listitem>
 	</itemizedlist>
+	During the implementation we identified another type:
+	<itemizedlist>
+	  <listitem><para>Fast EOIU type</para></listitem>
+	</itemizedlist>
 	In the SMP world of the __do_IRQ() super-handler another type
 	was identified:
 	<itemizedlist>
@@ -153,6 +157,7 @@
 	is still available. This leads to a kind of duality for the time
 	being. Over time the new model should be used in more and more
 	architectures, as it enables smaller and cleaner IRQ subsystems.
+	It's deprecated for three years now and about to be removed.
 	</para>
   </chapter>
   <chapter id="bugs">
@@ -217,6 +222,7 @@
 	  <itemizedlist>
 	  <listitem><para>handle_level_irq</para></listitem>
 	  <listitem><para>handle_edge_irq</para></listitem>
+	  <listitem><para>handle_fasteoi_irq</para></listitem>
 	  <listitem><para>handle_simple_irq</para></listitem>
 	  <listitem><para>handle_percpu_irq</para></listitem>
 	  </itemizedlist>
@@ -233,33 +239,33 @@
 		are used by the default flow implementations.
 		The following helper functions are implemented (simplified excerpt):
 		<programlisting>
-default_enable(irq)
+default_enable(struct irq_data *data)
 {
-	desc->chip->unmask(irq);
+	desc->chip->irq_unmask(data);
 }
 
-default_disable(irq)
+default_disable(struct irq_data *data)
 {
-	if (!delay_disable(irq))
-		desc->chip->mask(irq);
+	if (!delay_disable(data))
+		desc->chip->irq_mask(data);
 }
 
-default_ack(irq)
+default_ack(struct irq_data *data)
 {
-	chip->ack(irq);
+	chip->irq_ack(data);
 }
 
-default_mask_ack(irq)
+default_mask_ack(struct irq_data *data)
 {
-	if (chip->mask_ack) {
-		chip->mask_ack(irq);
+	if (chip->irq_mask_ack) {
+		chip->irq_mask_ack(data);
 	} else {
-		chip->mask(irq);
-		chip->ack(irq);
+		chip->irq_mask(data);
+		chip->irq_ack(data);
 	}
 }
 
-noop(irq)
+noop(struct irq_data *data))
 {
 }
 
@@ -278,9 +284,24 @@ noop(irq)
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-desc->chip->start();
+desc->chip->irq_mask();
+handle_IRQ_event(desc->action);
+desc->chip->irq_unmask();
+		</programlisting>
+		</para>
+   	    </sect3>
+	    <sect3 id="Default_FASTEOI_IRQ_flow_handler">
+	 	<title>Default Fast EOI IRQ flow handler</title>
+		<para>
+		handle_fasteoi_irq provides a generic implementation
+		for interrupts, which only need an EOI at the end of
+		the handler
+		</para>
+		<para>
+		The following control flow is implemented (simplified excerpt):
+		<programlisting>
 handle_IRQ_event(desc->action);
-desc->chip->end();
+desc->chip->irq_eoi();
 		</programlisting>
 		</para>
    	    </sect3>
@@ -294,20 +315,19 @@ desc->chip->end();
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
 if (desc->status &amp; running) {
-	desc->chip->hold();
+	desc->chip->irq_mask();
 	desc->status |= pending | masked;
 	return;
 }
-desc->chip->start();
+desc->chip->irq_ack();
 desc->status |= running;
 do {
 	if (desc->status &amp; masked)
-		desc->chip->enable();
+		desc->chip->irq_unmask();
 	desc->status &amp;= ~pending;
 	handle_IRQ_event(desc->action);
 } while (status &amp; pending);
 desc->status &amp;= ~running;
-desc->chip->end();
 		</programlisting>
 		</para>
    	    </sect3>
@@ -342,9 +362,9 @@ handle_IRQ_event(desc->action);
 		<para>
 		The following control flow is implemented (simplified excerpt):
 		<programlisting>
-desc->chip->start();
 handle_IRQ_event(desc->action);
-desc->chip->end();
+if (desc->chip->irq_eoi)
+        desc->chip->irq_eoi();
 		</programlisting>
 		</para>
    	    </sect3>
@@ -375,8 +395,7 @@ desc->chip->end();
 	mechanism. (It's necessary to enable CONFIG_HARDIRQS_SW_RESEND when
 	you want to use the delayed interrupt disable feature and your
 	hardware is not capable of retriggering	an interrupt.)
-	The delayed interrupt disable can be runtime enabled, per interrupt,
-	by setting the IRQ_DELAYED_DISABLE flag in the irq_desc status field.
+	The delayed interrupt disable is not configurable.
 	</para>
 	</sect2>
     </sect1>
@@ -387,13 +406,13 @@ desc->chip->end();
 	contains all the direct chip relevant functions, which
 	can be utilized by the irq flow implementations.
 	  <itemizedlist>
-	  <listitem><para>ack()</para></listitem>
-	  <listitem><para>mask_ack() - Optional, recommended for performance</para></listitem>
-	  <listitem><para>mask()</para></listitem>
-	  <listitem><para>unmask()</para></listitem>
-	  <listitem><para>retrigger() - Optional</para></listitem>
-	  <listitem><para>set_type() - Optional</para></listitem>
-	  <listitem><para>set_wake() - Optional</para></listitem>
+	  <listitem><para>irq_ack()</para></listitem>
+	  <listitem><para>irq_mask_ack() - Optional, recommended for performance</para></listitem>
+	  <listitem><para>irq_mask()</para></listitem>
+	  <listitem><para>irq_unmask()</para></listitem>
+	  <listitem><para>irq_retrigger() - Optional</para></listitem>
+	  <listitem><para>irq_set_type() - Optional</para></listitem>
+	  <listitem><para>irq_set_wake() - Optional</para></listitem>
 	  </itemizedlist>
 	These primitives are strictly intended to mean what they say: ack means
 	ACK, masking means masking of an IRQ line, etc. It is up to the flow
@@ -449,6 +468,7 @@ desc->chip->end();
      This chapter contains the autogenerated documentation of the kernel API functions
       which are exported.
      </para>
+!Ekernel/irq/irqdesc.c
 !Ekernel/irq/manage.c
 !Ekernel/irq/chip.c
   </chapter>


