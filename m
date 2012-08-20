Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2HTEEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:04:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab2HTEBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: [ 40/46] KVM: PIC: call ack notifiers for irqs that are dropped form irr
Date: Sun, 19 Aug 2012 20:59:16 -0700
Message-Id: <20120820035837.834733550@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

(cherry picked from commit aea218f3cbbcaac249b6b2c98930a00d6d931f1e)

After commit 242ec97c358256 PIT interrupts are no longer delivered after
PIC reset. It happens because PIT injects interrupt only if previous one
was acked, but since on PIC reset it is dropped from irr it will never
be delivered and hence acknowledged. Fix that by calling ack notifier on
PIC reset.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/i8259.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -305,6 +305,11 @@ static void pic_ioport_write(void *opaqu
 	addr &= 1;
 	if (addr == 0) {
 		if (val & 0x10) {
+			u8 edge_irr = s->irr & ~s->elcr;
+			int i;
+			bool found;
+			struct kvm_vcpu *vcpu;
+
 			s->init4 = val & 1;
 			s->last_irr = 0;
 			s->irr &= s->elcr;
@@ -322,6 +327,18 @@ static void pic_ioport_write(void *opaqu
 			if (val & 0x08)
 				pr_pic_unimpl(
 					"level sensitive irq not supported");
+
+			kvm_for_each_vcpu(i, vcpu, s->pics_state->kvm)
+				if (kvm_apic_accept_pic_intr(vcpu)) {
+					found = true;
+					break;
+				}
+
+
+			if (found)
+				for (irq = 0; irq < PIC_NUM_PINS/2; irq++)
+					if (edge_irr & (1 << irq))
+						pic_clear_isr(s, irq);
 		} else if (val & 0x08) {
 			if (val & 0x04)
 				s->poll = 1;


