Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2EaLIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:08:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32860 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2EaLIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:08:20 -0400
MIME-Version: 1.0
Date: Thu, 31 May 2012 19:08:17 +0800
Message-ID: <CAH3Oq6SHLWvcdVUFsmPvqNedBC_QQhVSxrvCiyAUL3TgPQn3wQ@mail.gmail.com>
Subject: Make kstat_incr_irqs_this_cpu() called when an irq is actually being handled
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec55240bec6970904c15315cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec55240bec6970904c15315cc
Content-Type: text/plain; charset=ISO-8859-1

The current kstat_incr_irqs_this_cpu() is really confusing to me, so I
made a patch
to count irq number more reliably according to my understanding.
Please share your
comments about it.


>From cf12b680e1363c5c8f99ab6141d832724c8221a6 Mon Sep 17 00:00:00 2001
From: Ning Jiang <ning.n.jiang@gmail.com>
Date: Thu, 31 May 2012 17:41:53 +0800
Subject: [PATCH] genirq: Increase irq count when it is actually being handled

kstat_incr_irqs_this_cpu() is supposed to record the irq number
that is actually taken by a certain cpu. But it failed to do so
in its current form.

For level irq, if its disabled or no action available, we'll skip
irq handling. When it is enabled later, the irq will be retriggered
and kstat_incr_irqs_this_cpu() will be counted twice for this
single irq.

For edge irq, we'll not have the same problem as level irq because
kstat_incr_irqs_this_cpu() is placed after status checking for
disable or no action. But it has its own problem. Suppose a second
irq happens when the first is being handled, it will mark itself
pending and quit, then it will be handled in the same loop after the
first one has been handled. Thus kstat_incr_irqs_this_cpu() will
only be counted once for two irqs.

Place kstat_incr_irqs_this_cpu() in handle_irq_event_percpu() will
give us the exact irq number handled by a certain cpu.

Adjust the kstat_incr_irqs_this_cpu() location in handle_nested_irq()
too because nested irq does not use handle_irq_event_percpu() for its
interrupt processing.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 kernel/irq/chip.c   |   15 ++++-----------
 kernel/irq/handle.c |    2 ++
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..37f18bd 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -272,8 +272,6 @@ void handle_nested_irq(unsigned int irq)

 	raw_spin_lock_irq(&desc->lock);

-	kstat_incr_irqs_this_cpu(irq, desc);
-
 	action = desc->action;
 	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data))) {
 		desc->istate |= IRQS_PENDING;
@@ -283,6 +281,8 @@ void handle_nested_irq(unsigned int irq)
 	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	raw_spin_unlock_irq(&desc->lock);

+	kstat_incr_irqs_this_cpu(irq, desc);
+
 	action_ret = action->thread_fn(action->irq, action->dev_id);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
@@ -324,7 +324,6 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 			goto out_unlock;

 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);

 	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
 		desc->istate |= IRQS_PENDING;
@@ -377,7 +376,6 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 			goto out_unlock;

 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);

 	/*
 	 * If its disabled or no action available
@@ -427,7 +425,6 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 			goto out;

 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);

 	/*
 	 * If its disabled or no action available
@@ -494,7 +491,6 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 			goto out_unlock;
 		}
 	}
-	kstat_incr_irqs_this_cpu(irq, desc);

 	/* Start handling the irq */
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
@@ -554,7 +550,6 @@ void handle_edge_eoi_irq(unsigned int irq, struct
irq_desc *desc)
 			goto out_eoi;
 		}
 	}
-	kstat_incr_irqs_this_cpu(irq, desc);

 	do {
 		if (unlikely(!desc->action))
@@ -583,8 +578,6 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);

-	kstat_incr_irqs_this_cpu(irq, desc);
-
 	if (chip->irq_ack)
 		chip->irq_ack(&desc->irq_data);

@@ -613,11 +606,11 @@ void handle_percpu_devid_irq(unsigned int irq,
struct irq_desc *desc)
 	void *dev_id = __this_cpu_ptr(action->percpu_dev_id);
 	irqreturn_t res;

-	kstat_incr_irqs_this_cpu(irq, desc);
-
 	if (chip->irq_ack)
 		chip->irq_ack(&desc->irq_data);

+	kstat_incr_irqs_this_cpu(irq, desc);
+
 	trace_irq_handler_entry(irq, action);
 	res = action->handler(irq, dev_id);
 	trace_irq_handler_exit(irq, action, res);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index bdb1803..0f21460 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -135,6 +135,8 @@ handle_irq_event_percpu(struct irq_desc *desc,
struct irqaction *action)
 	irqreturn_t retval = IRQ_NONE;
 	unsigned int random = 0, irq = desc->irq_data.irq;

+	kstat_incr_irqs_this_cpu(irq, desc);
+
 	do {
 		irqreturn_t res;

-- 
1.7.1

--bcaec55240bec6970904c15315cc
Content-Type: application/octet-stream; 
	name="0001-genirq-Increase-irq-count-when-it-is-actually-being-.patch"
Content-Disposition: attachment; 
	filename="0001-genirq-Increase-irq-count-when-it-is-actually-being-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2vpwn450

RnJvbSBjZjEyYjY4MGUxMzYzYzVjOGY5OWFiNjE0MWQ4MzI3MjRjODIyMWE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaW5nIEppYW5nIDxuaW5nLm4uamlhbmdAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDMxIE1heSAyMDEyIDE3OjQxOjUzICswODAwClN1YmplY3Q6IFtQQVRDSF0gZ2Vu
aXJxOiBJbmNyZWFzZSBpcnEgY291bnQgd2hlbiBpdCBpcyBhY3R1YWxseSBiZWluZyBoYW5kbGVk
Cgprc3RhdF9pbmNyX2lycXNfdGhpc19jcHUoKSBpcyBzdXBwb3NlZCB0byByZWNvcmQgdGhlIGly
cSBudW1iZXIKdGhhdCBpcyBhY3R1YWxseSB0YWtlbiBieSBhIGNlcnRhaW4gY3B1LiBCdXQgaXQg
ZmFpbGVkIHRvIGRvIHNvCmluIGl0cyBjdXJyZW50IGZvcm0uCgpGb3IgbGV2ZWwgaXJxLCBpZiBp
dHMgZGlzYWJsZWQgb3Igbm8gYWN0aW9uIGF2YWlsYWJsZSwgd2UnbGwgc2tpcAppcnEgaGFuZGxp
bmcuIFdoZW4gaXQgaXMgZW5hYmxlZCBsYXRlciwgdGhlIGlycSB3aWxsIGJlIHJldHJpZ2dlcmVk
CmFuZCBrc3RhdF9pbmNyX2lycXNfdGhpc19jcHUoKSB3aWxsIGJlIGNvdW50ZWQgdHdpY2UgZm9y
IHRoaXMKc2luZ2xlIGlycS4KCkZvciBlZGdlIGlycSwgd2UnbGwgbm90IGhhdmUgdGhlIHNhbWUg
cHJvYmxlbSBhcyBsZXZlbCBpcnEgYmVjYXVzZQprc3RhdF9pbmNyX2lycXNfdGhpc19jcHUoKSBp
cyBwbGFjZWQgYWZ0ZXIgc3RhdHVzIGNoZWNraW5nIGZvcgpkaXNhYmxlIG9yIG5vIGFjdGlvbi4g
QnV0IGl0IGhhcyBpdHMgb3duIHByb2JsZW0uIFN1cHBvc2UgYSBzZWNvbmQKaXJxIGhhcHBlbnMg
d2hlbiB0aGUgZmlyc3QgaXMgYmVpbmcgaGFuZGxlZCwgaXQgd2lsbCBtYXJrIGl0c2VsZgpwZW5k
aW5nIGFuZCBxdWl0LCB0aGVuIGl0IHdpbGwgYmUgaGFuZGxlZCBpbiB0aGUgc2FtZSBsb29wIGFm
dGVyIHRoZQpmaXJzdCBvbmUgaGFzIGJlZW4gaGFuZGxlZC4gVGh1cyBrc3RhdF9pbmNyX2lycXNf
dGhpc19jcHUoKSB3aWxsCm9ubHkgYmUgY291bnRlZCBvbmNlIGZvciB0d28gaXJxcy4KClBsYWNl
IGtzdGF0X2luY3JfaXJxc190aGlzX2NwdSgpIGluIGhhbmRsZV9pcnFfZXZlbnRfcGVyY3B1KCkg
d2lsbApnaXZlIHVzIHRoZSBleGFjdCBpcnEgbnVtYmVyIGhhbmRsZWQgYnkgYSBjZXJ0YWluIGNw
dS4KCkFkanVzdCB0aGUga3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KCkgbG9jYXRpb24gaW4gaGFu
ZGxlX25lc3RlZF9pcnEoKQp0b28gYmVjYXVzZSBuZXN0ZWQgaXJxIGRvZXMgbm90IHVzZSBoYW5k
bGVfaXJxX2V2ZW50X3BlcmNwdSgpIGZvciBpdHMKaW50ZXJydXB0IHByb2Nlc3NpbmcuCgpTaWdu
ZWQtb2ZmLWJ5OiBOaW5nIEppYW5nIDxuaW5nLm4uamlhbmdAZ21haWwuY29tPgotLS0KIGtlcm5l
bC9pcnEvY2hpcC5jICAgfCAgIDE1ICsrKystLS0tLS0tLS0tLQoga2VybmVsL2lycS9oYW5kbGUu
YyB8ICAgIDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvaXJxL2NoaXAuYyBiL2tlcm5lbC9pcnEvY2hpcC5j
CmluZGV4IGVlYmQ2ZDUuLjM3ZjE4YmQgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9pcnEvY2hpcC5jCisr
KyBiL2tlcm5lbC9pcnEvY2hpcC5jCkBAIC0yNzIsOCArMjcyLDYgQEAgdm9pZCBoYW5kbGVfbmVz
dGVkX2lycSh1bnNpZ25lZCBpbnQgaXJxKQogCiAJcmF3X3NwaW5fbG9ja19pcnEoJmRlc2MtPmxv
Y2spOwogCi0Ja3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KGlycSwgZGVzYyk7Ci0KIAlhY3Rpb24g
PSBkZXNjLT5hY3Rpb247CiAJaWYgKHVubGlrZWx5KCFhY3Rpb24gfHwgaXJxZF9pcnFfZGlzYWJs
ZWQoJmRlc2MtPmlycV9kYXRhKSkpIHsKIAkJZGVzYy0+aXN0YXRlIHw9IElSUVNfUEVORElORzsK
QEAgLTI4Myw2ICsyODEsOCBAQCB2b2lkIGhhbmRsZV9uZXN0ZWRfaXJxKHVuc2lnbmVkIGludCBp
cnEpCiAJaXJxZF9zZXQoJmRlc2MtPmlycV9kYXRhLCBJUlFEX0lSUV9JTlBST0dSRVNTKTsKIAly
YXdfc3Bpbl91bmxvY2tfaXJxKCZkZXNjLT5sb2NrKTsKIAorCWtzdGF0X2luY3JfaXJxc190aGlz
X2NwdShpcnEsIGRlc2MpOworCiAJYWN0aW9uX3JldCA9IGFjdGlvbi0+dGhyZWFkX2ZuKGFjdGlv
bi0+aXJxLCBhY3Rpb24tPmRldl9pZCk7CiAJaWYgKCFub2lycWRlYnVnKQogCQlub3RlX2ludGVy
cnVwdChpcnEsIGRlc2MsIGFjdGlvbl9yZXQpOwpAQCAtMzI0LDcgKzMyNCw2IEBAIGhhbmRsZV9z
aW1wbGVfaXJxKHVuc2lnbmVkIGludCBpcnEsIHN0cnVjdCBpcnFfZGVzYyAqZGVzYykKIAkJCWdv
dG8gb3V0X3VubG9jazsKIAogCWRlc2MtPmlzdGF0ZSAmPSB+KElSUVNfUkVQTEFZIHwgSVJRU19X
QUlUSU5HKTsKLQlrc3RhdF9pbmNyX2lycXNfdGhpc19jcHUoaXJxLCBkZXNjKTsKIAogCWlmICh1
bmxpa2VseSghZGVzYy0+YWN0aW9uIHx8IGlycWRfaXJxX2Rpc2FibGVkKCZkZXNjLT5pcnFfZGF0
YSkpKSB7CiAJCWRlc2MtPmlzdGF0ZSB8PSBJUlFTX1BFTkRJTkc7CkBAIC0zNzcsNyArMzc2LDYg
QEAgaGFuZGxlX2xldmVsX2lycSh1bnNpZ25lZCBpbnQgaXJxLCBzdHJ1Y3QgaXJxX2Rlc2MgKmRl
c2MpCiAJCQlnb3RvIG91dF91bmxvY2s7CiAKIAlkZXNjLT5pc3RhdGUgJj0gfihJUlFTX1JFUExB
WSB8IElSUVNfV0FJVElORyk7Ci0Ja3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KGlycSwgZGVzYyk7
CiAKIAkvKgogCSAqIElmIGl0cyBkaXNhYmxlZCBvciBubyBhY3Rpb24gYXZhaWxhYmxlCkBAIC00
MjcsNyArNDI1LDYgQEAgaGFuZGxlX2Zhc3Rlb2lfaXJxKHVuc2lnbmVkIGludCBpcnEsIHN0cnVj
dCBpcnFfZGVzYyAqZGVzYykKIAkJCWdvdG8gb3V0OwogCiAJZGVzYy0+aXN0YXRlICY9IH4oSVJR
U19SRVBMQVkgfCBJUlFTX1dBSVRJTkcpOwotCWtzdGF0X2luY3JfaXJxc190aGlzX2NwdShpcnEs
IGRlc2MpOwogCiAJLyoKIAkgKiBJZiBpdHMgZGlzYWJsZWQgb3Igbm8gYWN0aW9uIGF2YWlsYWJs
ZQpAQCAtNDk0LDcgKzQ5MSw2IEBAIGhhbmRsZV9lZGdlX2lycSh1bnNpZ25lZCBpbnQgaXJxLCBz
dHJ1Y3QgaXJxX2Rlc2MgKmRlc2MpCiAJCQlnb3RvIG91dF91bmxvY2s7CiAJCX0KIAl9Ci0Ja3N0
YXRfaW5jcl9pcnFzX3RoaXNfY3B1KGlycSwgZGVzYyk7CiAKIAkvKiBTdGFydCBoYW5kbGluZyB0
aGUgaXJxICovCiAJZGVzYy0+aXJxX2RhdGEuY2hpcC0+aXJxX2FjaygmZGVzYy0+aXJxX2RhdGEp
OwpAQCAtNTU0LDcgKzU1MCw2IEBAIHZvaWQgaGFuZGxlX2VkZ2VfZW9pX2lycSh1bnNpZ25lZCBp
bnQgaXJxLCBzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2MpCiAJCQlnb3RvIG91dF9lb2k7CiAJCX0KIAl9
Ci0Ja3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KGlycSwgZGVzYyk7CiAKIAlkbyB7CiAJCWlmICh1
bmxpa2VseSghZGVzYy0+YWN0aW9uKSkKQEAgLTU4Myw4ICs1NzgsNiBAQCBoYW5kbGVfcGVyY3B1
X2lycSh1bnNpZ25lZCBpbnQgaXJxLCBzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2MpCiB7CiAJc3RydWN0
IGlycV9jaGlwICpjaGlwID0gaXJxX2Rlc2NfZ2V0X2NoaXAoZGVzYyk7CiAKLQlrc3RhdF9pbmNy
X2lycXNfdGhpc19jcHUoaXJxLCBkZXNjKTsKLQogCWlmIChjaGlwLT5pcnFfYWNrKQogCQljaGlw
LT5pcnFfYWNrKCZkZXNjLT5pcnFfZGF0YSk7CiAKQEAgLTYxMywxMSArNjA2LDExIEBAIHZvaWQg
aGFuZGxlX3BlcmNwdV9kZXZpZF9pcnEodW5zaWduZWQgaW50IGlycSwgc3RydWN0IGlycV9kZXNj
ICpkZXNjKQogCXZvaWQgKmRldl9pZCA9IF9fdGhpc19jcHVfcHRyKGFjdGlvbi0+cGVyY3B1X2Rl
dl9pZCk7CiAJaXJxcmV0dXJuX3QgcmVzOwogCi0Ja3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KGly
cSwgZGVzYyk7Ci0KIAlpZiAoY2hpcC0+aXJxX2FjaykKIAkJY2hpcC0+aXJxX2FjaygmZGVzYy0+
aXJxX2RhdGEpOwogCisJa3N0YXRfaW5jcl9pcnFzX3RoaXNfY3B1KGlycSwgZGVzYyk7CisKIAl0
cmFjZV9pcnFfaGFuZGxlcl9lbnRyeShpcnEsIGFjdGlvbik7CiAJcmVzID0gYWN0aW9uLT5oYW5k
bGVyKGlycSwgZGV2X2lkKTsKIAl0cmFjZV9pcnFfaGFuZGxlcl9leGl0KGlycSwgYWN0aW9uLCBy
ZXMpOwpkaWZmIC0tZ2l0IGEva2VybmVsL2lycS9oYW5kbGUuYyBiL2tlcm5lbC9pcnEvaGFuZGxl
LmMKaW5kZXggYmRiMTgwMy4uMGYyMTQ2MCAxMDA2NDQKLS0tIGEva2VybmVsL2lycS9oYW5kbGUu
YworKysgYi9rZXJuZWwvaXJxL2hhbmRsZS5jCkBAIC0xMzUsNiArMTM1LDggQEAgaGFuZGxlX2ly
cV9ldmVudF9wZXJjcHUoc3RydWN0IGlycV9kZXNjICpkZXNjLCBzdHJ1Y3QgaXJxYWN0aW9uICph
Y3Rpb24pCiAJaXJxcmV0dXJuX3QgcmV0dmFsID0gSVJRX05PTkU7CiAJdW5zaWduZWQgaW50IHJh
bmRvbSA9IDAsIGlycSA9IGRlc2MtPmlycV9kYXRhLmlycTsKIAorCWtzdGF0X2luY3JfaXJxc190
aGlzX2NwdShpcnEsIGRlc2MpOworCiAJZG8gewogCQlpcnFyZXR1cm5fdCByZXM7CiAKLS0gCjEu
Ny4xCgo=
--bcaec55240bec6970904c15315cc--
