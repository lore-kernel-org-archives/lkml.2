Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0F3THN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:07:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0F3THJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:07:09 -0400
Message-ID: <4C2B960A.7090503@colorfullife.com>
Date: Wed, 30 Jun 2010 21:07:54 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: 2.6.35-rc3: System unresponsive under load
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <20100621200118.GA4021@nb-core2.darkstar.lan> <4C223657.3030507@colorfullife.com> <AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com> <AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com> <4C251AFF.70803@colorfullife.com> <AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com> <4C2620F4.7030900@colorfullife.com> <AANLkTikSh0FZYPppDcF2YDoyDBkIZcAdTBj7iN_9Cta4@mail.gmail.com>
In-Reply-To: <AANLkTikSh0FZYPppDcF2YDoyDBkIZcAdTBj7iN_9Cta4@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080107080308030300070804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080107080308030300070804
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Luca,

On 06/26/2010 06:47 PM, Luca Tettamanti wrote:
>
> Confirmed here: your test program freezes the system for a while under
> 2.6.35-rc3, while vanilla 2.6.34 copes fine.
> sysrq-t was responsive during the freeze, so I took a snapshot during
> it, file is attached.
>
>    
Ignore my test program:
If the master thread is interrupted in the right place, then there are 
400 runnable tasks in the runqueue.
It seems that the scheduler just processes these 400 tasks first instead 
of the keventd/ksoftirqd that is necessary for the keyboard handling.

Attached is a new idea, could you try it with your httpd test?

Perhaps the race is actually a race in the user space:
The exit path of semtimedop() does not contain an explicit memory barrier.
For the kernel, it does not matter: It merely reads one integer value.
If sysret is also no memory barrier, then user space might observe stale 
data.

Which cpu do you have? I was unable to show any misbehavior on a Phenom X4.

--
     Manfred

--------------080107080308030300070804
Content-Type: text/plain;
 name="patch-IN_WAKEUP-v2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch-IN_WAKEUP-v2"

RnJvbTogTWFuZnJlZCBTcHJhdWwgPG1hbmZyZWRAY29sb3JmdWxsaWZlLmNvbT4KClRoZSBs
YXN0IGNoYW5nZSB0byBpbXByb3ZlIHRoZSBzY2FsYWJpbGl0eSBtb3ZlZCB0aGUgYWN0dWFs
IHdha2UtdXAgb3V0IG9mCnRoZSBzZWN0aW9uIHRoYXQgaXMgcHJvdGVjdGVkIGJ5IHNwaW5f
bG9jayhzbWEtPnNlbV9wZXJtLmxvY2spLgoKVGhpcyBtZWFucyB0aGF0IElOX1dBS0VVUCBj
YW4gYmUgaW4gcXVldWUuc3RhdHVzIGV2ZW4gd2hlbiB0aGUgc3BpbmxvY2sgaXMKYWNxdWly
ZWQgYnkgdGhlIGN1cnJlbnQgdGFzay4gIFRodXMgdGhlIHNhbWUgbG9vcCB0aGF0IGlzIHBl
cmZvcm1lZCB3aGVuCnF1ZXVlLnN0YXR1cyBpcyByZWFkIHdpdGhvdXQgdGhlIHNwaW5sb2Nr
IGFjcXVpcmVkIG11c3QgYmUgcGVyZm9ybWVkIHdoZW4KdGhlIHNwaW5sb2NrIGlzIGFjcXVp
cmVkLgoKSW4gYWRkaXRpb24sIHVzZXIgc3BhY2UgbWF5IGFzc3VtZSB0aGF0IHNlbXRpbWVk
b3AoKSBpcyBhIG1lbW9yeQpiYXJyaWVyKCkuIFRodXMgYWRkIGEgc21wX21iKCkgaW50byB0
aGUgbG9ja2xlc3MgcmV0dXJuIHBhdGggLSBvdGhlcndpc2UKdGhlIGNvZGUgd291bGQgcmV0
dXJuIGFmdGVyIGFjcXVpcmluZyBhIHNlbWFwaG9yZSB3aXRob3V0IGEgbWVtb3J5CmJhcnJp
ZXIuClRoYW5rcyB0byBrYW1lemF3YS5oaXJveXVAanAuZnVqaXRzdS5jb20gZm9yIG5vdGlj
aW5nIGxhY2sgb2YgdGhlIG1lbW9yeQpiYXJyaWVyLgoKQWRkcmVzc2VzIGh0dHBzOi8vYnVn
emlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MTYyNTUKCltha3BtQGxpbnV4LWZv
dW5kYXRpb24ub3JnOiBjbGVhbiB1cCBrZXJuZWxkb2MsIGNoZWNrcGF0Y2ggd2FybmluZyBh
bmQgd2hpdGVzcGFjZV0KClNpZ25lZC1vZmYtYnk6IE1hbmZyZWQgU3ByYXVsIDxtYW5mcmVk
QGNvbG9yZnVsbGlmZS5jb20+ClJlcG9ydGVkLWJ5OiBMdWNhIFRldHRhbWFudGkgPGtyb25v
cy5pdEBnbWFpbC5jb20+ClJlcG9ydGVkLWJ5OiBDaHJpc3RvcGggTGFtZXRlciA8Y2xAbGlu
dXgtZm91bmRhdGlvbi5vcmc+CkNjOiBNYWNpZWogUnV0ZWNraSA8bWFjaWVqLnJ1dGVja2lA
Z21haWwuY29tPgotLS0KZGlmZiAtLWdpdCBhL2lwYy9zZW0uYyBiL2lwYy9zZW0uYwppbmRl
eCA1MDZjODQ5Li40MGE4ZjQ2IDEwMDY0NAotLS0gYS9pcGMvc2VtLmMKKysrIGIvaXBjL3Nl
bS5jCkBAIC0xMjU2LDYgKzEyNTYsMzMgQEAgb3V0OgogCXJldHVybiB1bjsKIH0KIAorCisv
KioKKyAqIGdldF9xdWV1ZV9yZXN1bHQgLSBSZXRyaWV2ZSB0aGUgcmVzdWx0IGNvZGUgZnJv
bSBzZW1fcXVldWUKKyAqIEBxOiBQb2ludGVyIHRvIHF1ZXVlIHN0cnVjdHVyZQorICoKKyAq
IFJldHJpZXZlIHRoZSByZXR1cm4gY29kZSBmcm9tIHRoZSBwZW5kaW5nIHF1ZXVlLiBJZiBJ
Tl9XQUtFVVAgaXMgZm91bmQgaW4KKyAqIHEtPnN0YXR1cywgdGhlbiB3ZSBtdXN0IGxvb3Ag
dW50aWwgdGhlIHZhbHVlIGlzIHJlcGxhY2VkIHdpdGggdGhlIGZpbmFsCisgKiB2YWx1ZTog
VGhpcyBtYXkgaGFwcGVuIGlmIGEgdGFzayBpcyB3b2tlbiB1cCBieSBhbiB1bnJlbGF0ZWQg
ZXZlbnQgKGUuZy4KKyAqIHNpZ25hbCkgYW5kIGluIHBhcmFsbGVsIHRoZSB0YXNrIGlzIHdv
a2VuIHVwIGJ5IGFub3RoZXIgdGFzayBiZWNhdXNlIGl0IGdvdAorICogdGhlIHJlcXVlc3Rl
ZCBzZW1hcGhvcmVzLgorICoKKyAqIFRoZSBmdW5jdGlvbiBjYW4gYmUgY2FsbGVkIHdpdGgg
b3Igd2l0aG91dCBob2xkaW5nIHRoZSBzZW1hcGhvcmUgc3BpbmxvY2suCisgKi8KK3N0YXRp
YyBpbnQgZ2V0X3F1ZXVlX3Jlc3VsdChzdHJ1Y3Qgc2VtX3F1ZXVlICpxKQoreworCWludCBl
cnJvcjsKKworCWVycm9yID0gcS0+c3RhdHVzOworCXdoaWxlICh1bmxpa2VseShlcnJvciA9
PSBJTl9XQUtFVVApKSB7CisJCWNwdV9yZWxheCgpOworCQllcnJvciA9IHEtPnN0YXR1czsK
Kwl9CisKKwlyZXR1cm4gZXJyb3I7Cit9CisKKwogU1lTQ0FMTF9ERUZJTkU0KHNlbXRpbWVk
b3AsIGludCwgc2VtaWQsIHN0cnVjdCBzZW1idWYgX191c2VyICosIHRzb3BzLAogCQl1bnNp
Z25lZCwgbnNvcHMsIGNvbnN0IHN0cnVjdCB0aW1lc3BlYyBfX3VzZXIgKiwgdGltZW91dCkK
IHsKQEAgLTE0MDksMTUgKzE0MzYsMTggQEAgU1lTQ0FMTF9ERUZJTkU0KHNlbXRpbWVkb3As
IGludCwgc2VtaWQsIHN0cnVjdCBzZW1idWYgX191c2VyICosIHRzb3BzLAogCWVsc2UKIAkJ
c2NoZWR1bGUoKTsKIAotCWVycm9yID0gcXVldWUuc3RhdHVzOwotCXdoaWxlKHVubGlrZWx5
KGVycm9yID09IElOX1dBS0VVUCkpIHsKLQkJY3B1X3JlbGF4KCk7Ci0JCWVycm9yID0gcXVl
dWUuc3RhdHVzOwotCX0KKwllcnJvciA9IGdldF9xdWV1ZV9yZXN1bHQoJnF1ZXVlKTsKIAog
CWlmIChlcnJvciAhPSAtRUlOVFIpIHsKIAkJLyogZmFzdCBwYXRoOiB1cGRhdGVfcXVldWUg
YWxyZWFkeSBvYnRhaW5lZCBhbGwgcmVxdWVzdGVkCi0JCSAqIHJlc291cmNlcyAqLworCQkg
KiByZXNvdXJjZXMuCisJCSAqIFBlcmZvcm0gYSBzbXBfbWIoKTogVXNlciBzcGFjZSBjb3Vs
ZCBhc3N1bWUgdGhhdCBzZW1vcCgpCisJCSAqIGlzIGEgbWVtb3J5IGJhcnJpZXI6IFdpdGhv
dXQgdGhlIG1iKCksIHRoZSBjcHUgY291bGQKKwkJICogc3BlY3VsYXRpdmVseSByZWFkIGlu
IHVzZXIgc3BhY2Ugc3RhbGUgZGF0YSB0aGF0IHdhcworCQkgKiBvdmVyd3JpdHRlbiBieSB0
aGUgcHJldmlvdXMgb3duZXIgb2YgdGhlIHNlbWFwaG9yZS4KKwkJICovCisJCXNtcF9tYigp
OworCiAJCWdvdG8gb3V0X2ZyZWU7CiAJfQogCkBAIC0xNDI3LDEwICsxNDU3LDEyIEBAIFNZ
U0NBTExfREVGSU5FNChzZW10aW1lZG9wLCBpbnQsIHNlbWlkLCBzdHJ1Y3Qgc2VtYnVmIF9f
dXNlciAqLCB0c29wcywKIAkJZ290byBvdXRfZnJlZTsKIAl9CiAKKwllcnJvciA9IGdldF9x
dWV1ZV9yZXN1bHQoJnF1ZXVlKTsKKwogCS8qCiAJICogSWYgcXVldWUuc3RhdHVzICE9IC1F
SU5UUiB3ZSBhcmUgd29rZW4gdXAgYnkgYW5vdGhlciBwcm9jZXNzCiAJICovCi0JZXJyb3Ig
PSBxdWV1ZS5zdGF0dXM7CisKIAlpZiAoZXJyb3IgIT0gLUVJTlRSKSB7CiAJCWdvdG8gb3V0
X3VubG9ja19mcmVlOwogCX0K
--------------080107080308030300070804--
