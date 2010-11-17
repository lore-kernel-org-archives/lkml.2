Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935599Ab0KQWXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:23:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935556Ab0KQWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:23:46 -0500
MIME-Version: 1.0
In-Reply-To: <20101117140526.d532b373.randy.dunlap@oracle.com>
References: <201011172159.oAHLx1tu001236@hera.kernel.org> <20101117140526.d532b373.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Nov 2010 14:23:23 -0800
Message-ID: <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
Subject: Re: BKL: remove extraneous #include <smp_lock.h>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: multipart/mixed; boundary=00221532cb504bb5b004954720ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00221532cb504bb5b004954720ba
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 17, 2010 at 2:05 PM, Randy Dunlap <randy.dunlap@oracle.com> wro=
te:
>
> smp_lock.h was removed from hardirq.h. =A0smp_lock.h provided the functio=
n prototype
> for kernel_locked(). =A0Should source files now #include <linux/smp_lock.=
h> ?
> even when not being built for SMP?

Hmm. I think that part was a mistake, but I suspect the simplest fix
for it is to simply get rid of "kernel_locked()". It has no other
users than the hardirq.h one, so let's just move it there.

Something like the attached?

NOTE! The reason I _only_ take the CONFIG_LOCK_KERNEL version from
smp_lock.h is because:

 - LOCK_KERNEL is defined by init/Kconfig as "(SMP || PREEMPT) && BKL"

 - inside hardirq.h we only use "kernel_locked()" inside "PREEMPT && BKL"

 - so "PREEMPT && BKL" implies "LOCK_KERNEL"

 - so the !LOCK_KERNEL kernel_locked() case is irrelevant.

unless I did a thinko somewhere.

Does this work in all configurations? TOTALLY UNTESTED! Caveat emptor.

                 Linus

--00221532cb504bb5b004954720ba
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ggms2wcx0

IGluY2x1ZGUvbGludXgvaGFyZGlycS5oICB8ICAgIDIgKy0KIGluY2x1ZGUvbGludXgvc21wX2xv
Y2suaCB8ICAgIDMgLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2hhcmRpcnEuaCBiL2luY2x1ZGUv
bGludXgvaGFyZGlycS5oCmluZGV4IDhmM2Y0NjcuLmJlYTE2MTIgMTAwNjQ0Ci0tLSBhL2luY2x1
ZGUvbGludXgvaGFyZGlycS5oCisrKyBiL2luY2x1ZGUvbGludXgvaGFyZGlycS5oCkBAIC05Niw3
ICs5Niw3IEBACiAjZGVmaW5lIGluX25taSgpCShwcmVlbXB0X2NvdW50KCkgJiBOTUlfTUFTSykK
IAogI2lmIGRlZmluZWQoQ09ORklHX1BSRUVNUFQpICYmIGRlZmluZWQoQ09ORklHX0JLTCkKLSMg
ZGVmaW5lIFBSRUVNUFRfSU5BVE9NSUNfQkFTRSBrZXJuZWxfbG9ja2VkKCkKKyMgZGVmaW5lIFBS
RUVNUFRfSU5BVE9NSUNfQkFTRSAoY3VycmVudC0+bG9ja19kZXB0aCA+PSAwKQogI2Vsc2UKICMg
ZGVmaW5lIFBSRUVNUFRfSU5BVE9NSUNfQkFTRSAwCiAjZW5kaWYKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvc21wX2xvY2suaCBiL2luY2x1ZGUvbGludXgvc21wX2xvY2suaAppbmRleCAyOTFm
NzIxLi4zYTE5ODgyIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3NtcF9sb2NrLmgKKysrIGIv
aW5jbHVkZS9saW51eC9zbXBfbG9jay5oCkBAIC00LDggKzQsNiBAQAogI2lmZGVmIENPTkZJR19M
T0NLX0tFUk5FTAogI2luY2x1ZGUgPGxpbnV4L3NjaGVkLmg+CiAKLSNkZWZpbmUga2VybmVsX2xv
Y2tlZCgpCQkoY3VycmVudC0+bG9ja19kZXB0aCA+PSAwKQotCiBleHRlcm4gaW50IF9fbG9ja2Z1
bmMgX19yZWFjcXVpcmVfa2VybmVsX2xvY2sodm9pZCk7CiBleHRlcm4gdm9pZCBfX2xvY2tmdW5j
IF9fcmVsZWFzZV9rZXJuZWxfbG9jayh2b2lkKTsKIApAQCAtNTgsNyArNTYsNiBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgY3ljbGVfa2VybmVsX2xvY2sodm9pZCkKICNkZWZpbmUgbG9ja19rZXJuZWwo
KQogI2RlZmluZSB1bmxvY2tfa2VybmVsKCkKICNkZWZpbmUgY3ljbGVfa2VybmVsX2xvY2soKQkJ
CWRvIHsgfSB3aGlsZSgwKQotI2RlZmluZSBrZXJuZWxfbG9ja2VkKCkJCQkJMQogI2VuZGlmIC8q
IENPTkZJR19CS0wgKi8KIAogI2RlZmluZSByZWxlYXNlX2tlcm5lbF9sb2NrKHRhc2spCQlkbyB7
IH0gd2hpbGUoMCkK
--00221532cb504bb5b004954720ba--
