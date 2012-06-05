Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2FEBT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:19:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51187 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab2FEBT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:19:26 -0400
MIME-Version: 1.0
Date: Tue, 5 Jun 2012 09:19:23 +0800
Message-ID: <CAH3Oq6QKkVGtXdLPH6JMZx2H3s9tWG0-sXA9uOVaF3QPiE83Ww@mail.gmail.com>
Subject: Increment irq count for second edge irq when the first is in progress
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8f234963e4126b04c1af709b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f234963e4126b04c1af709b
Content-Type: text/plain; charset=ISO-8859-1

I've made a another patch based on your conception of irq accounting.
It fixes the corner case in which there comes up a second irq when the
first is still in progress, we'll increment the irq count before we quit.


>From 93960c69e588989346589fac78b311ac62fb7552 Mon Sep 17 00:00:00 2001
From: Ning Jiang <ning.n.jiang@gmail.com>
Date: Mon, 4 Jun 2012 09:54:08 +0800
Subject: [PATCH] genirq: Increment irq count for second edge irq when
the first is in progress

kstat_incr_irqs_this_cpu() records the real number of interruptions
to a certain CPU, regardless of the current irq state. That includes
interrupts which are delivered in a state where the device handler
cannot be called.

For level irq, if its disabled or no action available, we'll skip
irq handling. When it is enabled later, the irq will be retriggered
and kstat_incr_irqs_this_cpu() will be incremented again. This counts
the number of interrupts arrived at the CPU and therefor it counts
TWO in this situation. The CPU is interrupted twice, not once. The
accounting works correctly as expected.

But for edge irq, we have a subtle problem. Suppose a second irq
happens when the first is still in progress, it will mark itself
pending and quit, then it will be handled in the same loop after
the first one has been handled. Thus kstat_incr_irqs_this_cpu()
will only be counted once for two irqs.

Add a check in edge handler if there is a irq already in progress,
we'll first kstat_incr_irqs_this_cpu() before we mask and quit, so
that we can get correct irq count in this case.

[ Thanks Thomas for his excellent comments ]

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 kernel/irq/chip.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..254b8aa 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -489,6 +489,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
 		     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
 		if (!irq_check_poll(desc)) {
+			if (irqd_irq_inprogress(&desc->irq_data))
+				kstat_incr_irqs_this_cpu(irq, desc);
 			desc->istate |= IRQS_PENDING;
 			mask_ack_irq(desc);
 			goto out_unlock;
@@ -550,6 +552,8 @@ void handle_edge_eoi_irq(unsigned int irq, struct
irq_desc *desc)
 	if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
 		     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
 		if (!irq_check_poll(desc)) {
+			if (irqd_irq_inprogress(&desc->irq_data))
+				kstat_incr_irqs_this_cpu(irq, desc);
 			desc->istate |= IRQS_PENDING;
 			goto out_eoi;
 		}
-- 
1.7.1

--e89a8f234963e4126b04c1af709b
Content-Type: application/octet-stream; 
	name="0001-genirq-Increment-irq-count-for-second-edge-irq-when-.patch"
Content-Disposition: attachment; 
	filename="0001-genirq-Increment-irq-count-for-second-edge-irq-when-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h32a5u5k1

RnJvbSA5Mzk2MGM2OWU1ODg5ODkzNDY1ODlmYWM3OGIzMTFhYzYyZmI3NTUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaW5nIEppYW5nIDxuaW5nLm4uamlhbmdAZ21haWwuY29tPgpE
YXRlOiBNb24sIDQgSnVuIDIwMTIgMDk6NTQ6MDggKzA4MDAKU3ViamVjdDogW1BBVENIXSBnZW5p
cnE6IEluY3JlbWVudCBpcnEgY291bnQgZm9yIHNlY29uZCBlZGdlIGlycSB3aGVuIHRoZSBmaXJz
dCBpcyBpbiBwcm9ncmVzcwoKa3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KCkgcmVjb3JkcyB0aGUg
cmVhbCBudW1iZXIgb2YgaW50ZXJydXB0aW9ucwp0byBhIGNlcnRhaW4gQ1BVLCByZWdhcmRsZXNz
IG9mIHRoZSBjdXJyZW50IGlycSBzdGF0ZS4gVGhhdCBpbmNsdWRlcwppbnRlcnJ1cHRzIHdoaWNo
IGFyZSBkZWxpdmVyZWQgaW4gYSBzdGF0ZSB3aGVyZSB0aGUgZGV2aWNlIGhhbmRsZXIKY2Fubm90
IGJlIGNhbGxlZC4KCkZvciBsZXZlbCBpcnEsIGlmIGl0cyBkaXNhYmxlZCBvciBubyBhY3Rpb24g
YXZhaWxhYmxlLCB3ZSdsbCBza2lwCmlycSBoYW5kbGluZy4gV2hlbiBpdCBpcyBlbmFibGVkIGxh
dGVyLCB0aGUgaXJxIHdpbGwgYmUgcmV0cmlnZ2VyZWQKYW5kIGtzdGF0X2luY3JfaXJxc190aGlz
X2NwdSgpIHdpbGwgYmUgaW5jcmVtZW50ZWQgYWdhaW4uIFRoaXMgY291bnRzCnRoZSBudW1iZXIg
b2YgaW50ZXJydXB0cyBhcnJpdmVkIGF0IHRoZSBDUFUgYW5kIHRoZXJlZm9yIGl0IGNvdW50cwpU
V08gaW4gdGhpcyBzaXR1YXRpb24uIFRoZSBDUFUgaXMgaW50ZXJydXB0ZWQgdHdpY2UsIG5vdCBv
bmNlLiBUaGUKYWNjb3VudGluZyB3b3JrcyBjb3JyZWN0bHkgYXMgZXhwZWN0ZWQuCgpCdXQgZm9y
IGVkZ2UgaXJxLCB3ZSBoYXZlIGEgc3VidGxlIHByb2JsZW0uIFN1cHBvc2UgYSBzZWNvbmQgaXJx
CmhhcHBlbnMgd2hlbiB0aGUgZmlyc3QgaXMgc3RpbGwgaW4gcHJvZ3Jlc3MsIGl0IHdpbGwgbWFy
ayBpdHNlbGYKcGVuZGluZyBhbmQgcXVpdCwgdGhlbiBpdCB3aWxsIGJlIGhhbmRsZWQgaW4gdGhl
IHNhbWUgbG9vcCBhZnRlcgp0aGUgZmlyc3Qgb25lIGhhcyBiZWVuIGhhbmRsZWQuIFRodXMga3N0
YXRfaW5jcl9pcnFzX3RoaXNfY3B1KCkKd2lsbCBvbmx5IGJlIGNvdW50ZWQgb25jZSBmb3IgdHdv
IGlycXMuCgpBZGQgYSBjaGVjayBpbiBlZGdlIGhhbmRsZXIgaWYgdGhlcmUgaXMgYSBpcnEgYWxy
ZWFkeSBpbiBwcm9ncmVzcywKd2UnbGwgZmlyc3Qga3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KCkg
YmVmb3JlIHdlIG1hc2sgYW5kIHF1aXQsIHNvCnRoYXQgd2UgY2FuIGdldCBjb3JyZWN0IGlycSBj
b3VudCBpbiB0aGlzIGNhc2UuCgpbIFRoYW5rcyBUaG9tYXMgZm9yIGhpcyBleGNlbGxlbnQgY29t
bWVudHMgXQoKU2lnbmVkLW9mZi1ieTogTmluZyBKaWFuZyA8bmluZy5uLmppYW5nQGdtYWlsLmNv
bT4KLS0tCiBrZXJuZWwvaXJxL2NoaXAuYyB8ICAgIDQgKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL2lycS9j
aGlwLmMgYi9rZXJuZWwvaXJxL2NoaXAuYwppbmRleCBlZWJkNmQ1Li4yNTRiOGFhIDEwMDY0NAot
LS0gYS9rZXJuZWwvaXJxL2NoaXAuYworKysgYi9rZXJuZWwvaXJxL2NoaXAuYwpAQCAtNDg5LDYg
KzQ4OSw4IEBAIGhhbmRsZV9lZGdlX2lycSh1bnNpZ25lZCBpbnQgaXJxLCBzdHJ1Y3QgaXJxX2Rl
c2MgKmRlc2MpCiAJaWYgKHVubGlrZWx5KGlycWRfaXJxX2Rpc2FibGVkKCZkZXNjLT5pcnFfZGF0
YSkgfHwKIAkJICAgICBpcnFkX2lycV9pbnByb2dyZXNzKCZkZXNjLT5pcnFfZGF0YSkgfHwgIWRl
c2MtPmFjdGlvbikpIHsKIAkJaWYgKCFpcnFfY2hlY2tfcG9sbChkZXNjKSkgeworCQkJaWYgKGly
cWRfaXJxX2lucHJvZ3Jlc3MoJmRlc2MtPmlycV9kYXRhKSkKKwkJCQlrc3RhdF9pbmNyX2lycXNf
dGhpc19jcHUoaXJxLCBkZXNjKTsKIAkJCWRlc2MtPmlzdGF0ZSB8PSBJUlFTX1BFTkRJTkc7CiAJ
CQltYXNrX2Fja19pcnEoZGVzYyk7CiAJCQlnb3RvIG91dF91bmxvY2s7CkBAIC01NTAsNiArNTUy
LDggQEAgdm9pZCBoYW5kbGVfZWRnZV9lb2lfaXJxKHVuc2lnbmVkIGludCBpcnEsIHN0cnVjdCBp
cnFfZGVzYyAqZGVzYykKIAlpZiAodW5saWtlbHkoaXJxZF9pcnFfZGlzYWJsZWQoJmRlc2MtPmly
cV9kYXRhKSB8fAogCQkgICAgIGlycWRfaXJxX2lucHJvZ3Jlc3MoJmRlc2MtPmlycV9kYXRhKSB8
fCAhZGVzYy0+YWN0aW9uKSkgewogCQlpZiAoIWlycV9jaGVja19wb2xsKGRlc2MpKSB7CisJCQlp
ZiAoaXJxZF9pcnFfaW5wcm9ncmVzcygmZGVzYy0+aXJxX2RhdGEpKQorCQkJCWtzdGF0X2luY3Jf
aXJxc190aGlzX2NwdShpcnEsIGRlc2MpOwogCQkJZGVzYy0+aXN0YXRlIHw9IElSUVNfUEVORElO
RzsKIAkJCWdvdG8gb3V0X2VvaTsKIAkJfQotLSAKMS43LjEKCg==
--e89a8f234963e4126b04c1af709b--
