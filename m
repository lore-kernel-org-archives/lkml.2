Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab2EVLOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:14:45 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38041 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758231Ab2EVLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:14:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205221048140.3231@ionos>
References: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com>
	<alpine.LFD.2.02.1205212308590.3231@ionos>
	<CAH3Oq6S64c9ttsAStn05FTkg+VC0o27Ad4DhHs=b4E7AKjWdjA@mail.gmail.com>
	<alpine.LFD.2.02.1205221048140.3231@ionos>
Date: Tue, 22 May 2012 19:14:41 +0800
Message-ID: <CAH3Oq6T905+3fkF43NAMMFvJvq7dsk_so6T2vQ8ZJrA5xiU3YA@mail.gmail.com>
Subject: Re: Add IRQS_PENDING for nested and simple irq handler as well
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec54eef2011fb3404c09e20a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54eef2011fb3404c09e20a9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2012/5/22 Thomas Gleixner <tglx@linutronix.de>:
> On Tue, 22 May 2012, Ning Jiang wrote:
>
> Please do not top post.
>
>> Sorry that I do not make myself clear.
>>
>> First, we should keep all the handle_*_irq behave in pretty much the
>> same way even just for the beauty of it. Every interrupt disabled in
>> suspend operation needs the ability to abort suspend if there is a
>> pending irq.
>>
>> Second, let's take look at a example:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
>> =A0 =A0 =A0 =A0+---------+
>> =A0 =A0 =A0 =A0 | =A0 INTC =A0|
>> =A0 =A0 =A0 =A0+---------+
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0GPIO_IRQ
>> =A0 =A0 =A0 =A0 =A0 =A0 +------------+
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0| gpio-exp =A0|
>> =A0 =A0 =A0 =A0 =A0 =A0 +------------+
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0 =A0GPIO0_IRQ =A0GPIO1_IRQ
>>
>> In the above diagram, gpio expander has irq number GPIO_IRQ, it is
>> connected with two sub GPIO pins, GPIO0 and GPIO1.
>>
>> During suspend, normally we want to set IRQF_NO_SUSPEND for GPIO_IRQ
>> so that gpio expander driver can handle the sub irq GPIO0_IRQ and
>> GPIO1_IRQ, and these two irqs themselves are handled by simple or
>> nested irq in some drivers(typically gpio and mfd driver), if they are
>> disabled during suspend, we want them to be able to abort suspend too.
>
> Ok, that makes a lot of sense and should be part of the changelog, so
> we know in a year from now why we did this change. Care to resend with
> a fixed up changelog ?
>
> Thanks,
>
> =A0 =A0 =A0 =A0tglx

Thanks for your guidance on commit changelog. It's really helpful.
Here is the comments formatted patch, please help to review.


>From 40c31a11049726761fe5c7c629200f48950d4229 Mon Sep 17 00:00:00 2001
From: Ning Jiang <ning.n.jiang@gmail.com>
Date: Tue, 22 May 2012 00:19:20 +0800
Subject: [PATCH] genirq: Add IRQS_PENDING for nested and simple irq
handler as well

We should keep all the handle_*_irq behave in pretty much the same
way even just for the beauty of it. Every interrupt disabled in
suspend operation needs the ability to abort suspend if there is a
pending irq.

Let's take look at an example:

            |
       +---------+
       |   INTC  |
       +---------+
               | GPIO_IRQ
            +------------+
            |  gpio-exp  |
            +------------+
              |        |
         GPIO0_IRQ  GPIO1_IRQ

In the above diagram, gpio expander has irq number GPIO_IRQ, it is
connected with two sub GPIO pins, GPIO0 and GPIO1.

During suspend, normally we want to set IRQF_NO_SUSPEND for GPIO_IRQ
so that gpio expander driver can handle the sub irq GPIO0_IRQ and
GPIO1_IRQ, and these two irqs themselves can further be handled by
simple or nested irq in some drivers(typically gpio and mfd driver).
If they are disabled during suspend and used as wakeup sources, we
want them to be able to abort suspend too.

Set IRQS_PENDING flag in handle_nested_irq() and handle_simple_irq()
when the irq is disabled will make check_wakeup_irqs() check for irqs
like GPIO0_IRQ and GPIO1_IRQ to abort suspend.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 kernel/irq/chip.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 741f836..5bec667 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -275,8 +275,10 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);

 	action =3D desc->action;
-	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |=3D IRQS_PENDING;
 		goto out_unlock;
+	}

 	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	raw_spin_unlock_irq(&desc->lock);
@@ -324,8 +326,10 @@ handle_simple_irq(unsigned int irq, struct irq_desc *d=
esc)
 	desc->istate &=3D ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);

-	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |=3D IRQS_PENDING;
 		goto out_unlock;
+	}

 	handle_irq_event(desc);

--=20
1.7.1

Thanks,
Ning

--bcaec54eef2011fb3404c09e20a9
Content-Type: application/octet-stream; 
	name="0001-genirq-Add-IRQS_PENDING-for-nested-and-simple-irq-ha.patch"
Content-Disposition: attachment; 
	filename="0001-genirq-Add-IRQS_PENDING-for-nested-and-simple-irq-ha.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2iv44zr0

RnJvbSA0MGMzMWExMTA0OTcyNjc2MWZlNWM3YzYyOTIwMGY0ODk1MGQ0MjI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaW5nIEppYW5nIDxuaW5nLm4uamlhbmdAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIyIE1heSAyMDEyIDAwOjE5OjIwICswODAwClN1YmplY3Q6IFtQQVRDSF0gZ2Vu
aXJxOiBBZGQgSVJRU19QRU5ESU5HIGZvciBuZXN0ZWQgYW5kIHNpbXBsZSBpcnEgaGFuZGxlciBh
cyB3ZWxsCgpXZSBzaG91bGQga2VlcCBhbGwgdGhlIGhhbmRsZV8qX2lycSBiZWhhdmUgaW4gcHJl
dHR5IG11Y2ggdGhlIHNhbWUKd2F5IGV2ZW4ganVzdCBmb3IgdGhlIGJlYXV0eSBvZiBpdC4gRXZl
cnkgaW50ZXJydXB0IGRpc2FibGVkIGluCnN1c3BlbmQgb3BlcmF0aW9uIG5lZWRzIHRoZSBhYmls
aXR5IHRvIGFib3J0IHN1c3BlbmQgaWYgdGhlcmUgaXMgYQpwZW5kaW5nIGlycS4KCkxldCdzIHRh
a2UgbG9vayBhdCBhbiBleGFtcGxlOgoKICAgICAgICAgICAgfAogICAgICAgKy0tLS0tLS0tLSsK
ICAgICAgIHwgICBJTlRDICB8CiAgICAgICArLS0tLS0tLS0tKwogICAgICAgICAgICAgICB8IEdQ
SU9fSVJRCiAgICAgICAgICAgICstLS0tLS0tLS0tLS0rCiAgICAgICAgICAgIHwgIGdwaW8tZXhw
ICB8CiAgICAgICAgICAgICstLS0tLS0tLS0tLS0rCiAgICAgICAgICAgICAgfCAgICAgICAgfAog
ICAgICAgICBHUElPMF9JUlEgIEdQSU8xX0lSUQoKSW4gdGhlIGFib3ZlIGRpYWdyYW0sIGdwaW8g
ZXhwYW5kZXIgaGFzIGlycSBudW1iZXIgR1BJT19JUlEsIGl0IGlzCmNvbm5lY3RlZCB3aXRoIHR3
byBzdWIgR1BJTyBwaW5zLCBHUElPMCBhbmQgR1BJTzEuCgpEdXJpbmcgc3VzcGVuZCwgbm9ybWFs
bHkgd2Ugd2FudCB0byBzZXQgSVJRRl9OT19TVVNQRU5EIGZvciBHUElPX0lSUQpzbyB0aGF0IGdw
aW8gZXhwYW5kZXIgZHJpdmVyIGNhbiBoYW5kbGUgdGhlIHN1YiBpcnEgR1BJTzBfSVJRIGFuZApH
UElPMV9JUlEsIGFuZCB0aGVzZSB0d28gaXJxcyB0aGVtc2VsdmVzIGNhbiBmdXJ0aGVyIGJlIGhh
bmRsZWQgYnkKc2ltcGxlIG9yIG5lc3RlZCBpcnEgaW4gc29tZSBkcml2ZXJzKHR5cGljYWxseSBn
cGlvIGFuZCBtZmQgZHJpdmVyKS4KSWYgdGhleSBhcmUgZGlzYWJsZWQgZHVyaW5nIHN1c3BlbmQg
YW5kIHVzZWQgYXMgd2FrZXVwIHNvdXJjZXMsIHdlCndhbnQgdGhlbSB0byBiZSBhYmxlIHRvIGFi
b3J0IHN1c3BlbmQgdG9vLgoKU2V0IElSUVNfUEVORElORyBmbGFnIGluIGhhbmRsZV9uZXN0ZWRf
aXJxKCkgYW5kIGhhbmRsZV9zaW1wbGVfaXJxKCkKd2hlbiB0aGUgaXJxIGlzIGRpc2FibGVkIHdp
bGwgbWFrZSBjaGVja193YWtldXBfaXJxcygpIGNoZWNrIGZvciBpcnFzCmxpa2UgR1BJTzBfSVJR
IGFuZCBHUElPMV9JUlEgdG8gYWJvcnQgc3VzcGVuZC4KClNpZ25lZC1vZmYtYnk6IE5pbmcgSmlh
bmcgPG5pbmcubi5qaWFuZ0BnbWFpbC5jb20+Ci0tLQoga2VybmVsL2lycS9jaGlwLmMgfCAgICA4
ICsrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvaXJxL2NoaXAuYyBiL2tlcm5lbC9pcnEvY2hpcC5jCmlu
ZGV4IDc0MWY4MzYuLjViZWM2NjcgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9pcnEvY2hpcC5jCisrKyBi
L2tlcm5lbC9pcnEvY2hpcC5jCkBAIC0yNzUsOCArMjc1LDEwIEBAIHZvaWQgaGFuZGxlX25lc3Rl
ZF9pcnEodW5zaWduZWQgaW50IGlycSkKIAlrc3RhdF9pbmNyX2lycXNfdGhpc19jcHUoaXJxLCBk
ZXNjKTsKIAogCWFjdGlvbiA9IGRlc2MtPmFjdGlvbjsKLQlpZiAodW5saWtlbHkoIWFjdGlvbiB8
fCBpcnFkX2lycV9kaXNhYmxlZCgmZGVzYy0+aXJxX2RhdGEpKSkKKwlpZiAodW5saWtlbHkoIWFj
dGlvbiB8fCBpcnFkX2lycV9kaXNhYmxlZCgmZGVzYy0+aXJxX2RhdGEpKSkgeworCQlkZXNjLT5p
c3RhdGUgfD0gSVJRU19QRU5ESU5HOwogCQlnb3RvIG91dF91bmxvY2s7CisJfQogCiAJaXJxZF9z
ZXQoJmRlc2MtPmlycV9kYXRhLCBJUlFEX0lSUV9JTlBST0dSRVNTKTsKIAlyYXdfc3Bpbl91bmxv
Y2tfaXJxKCZkZXNjLT5sb2NrKTsKQEAgLTMyNCw4ICszMjYsMTAgQEAgaGFuZGxlX3NpbXBsZV9p
cnEodW5zaWduZWQgaW50IGlycSwgc3RydWN0IGlycV9kZXNjICpkZXNjKQogCWRlc2MtPmlzdGF0
ZSAmPSB+KElSUVNfUkVQTEFZIHwgSVJRU19XQUlUSU5HKTsKIAlrc3RhdF9pbmNyX2lycXNfdGhp
c19jcHUoaXJxLCBkZXNjKTsKIAotCWlmICh1bmxpa2VseSghZGVzYy0+YWN0aW9uIHx8IGlycWRf
aXJxX2Rpc2FibGVkKCZkZXNjLT5pcnFfZGF0YSkpKQorCWlmICh1bmxpa2VseSghZGVzYy0+YWN0
aW9uIHx8IGlycWRfaXJxX2Rpc2FibGVkKCZkZXNjLT5pcnFfZGF0YSkpKSB7CisJCWRlc2MtPmlz
dGF0ZSB8PSBJUlFTX1BFTkRJTkc7CiAJCWdvdG8gb3V0X3VubG9jazsKKwl9CiAKIAloYW5kbGVf
aXJxX2V2ZW50KGRlc2MpOwogCi0tIAoxLjcuMQoK
--bcaec54eef2011fb3404c09e20a9--
