Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2FGRrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:47:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37708 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2FGRrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120607144204.GD21339@redhat.com>
References: <20120607041406.GA13233@kroah.com> <20120607040337.622672845@linuxfoundation.org>
 <CA+5PVA6A0K3WYBQJH8z3ddd2X3=fQm1a34z+fWSYGcUg4TR9+A@mail.gmail.com> <20120607144204.GD21339@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 10:46:44 -0700
X-Google-Sender-Auth: 7XitsKAfLtFd-YJ3KuzN-eg2TX4
Message-ID: <CA+55aFzv-z0njtAnpgOsVES70+igwV7HCteQbQ6M6uTsYvn5WQ@mail.gmail.com>
Subject: Re: [ 08/82] mm: pmd_read_atomic: fix 32bit PAE pmd walk vs
 pmd_populate SMP race condition
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulrich Obergfell <uobergfe@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Larry Woodman <lwoodman@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Rik van Riel <riel@redhat.com>
Content-Type: multipart/mixed; boundary=0016e6dab700d3697d04c1e578be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6dab700d3697d04c1e578be
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jun 7, 2012 at 7:42 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> From the oops it looks like atomic64_read trips on a dangling pmdp
> pointer, but if the problem doesn't happen with Xen then the pointer
> value shouldn't be the problem, and in turn the lock cmpxchg8b used to
> access the pointer is likely the problem.

So I assume that Xen just turns the page tables read-only in order to
track them, and then assumes that nobody modifies them in the
particular section. And the cmpxchg64 looks like a modification, even
if we only use it to read things.

Andrea, do we have any guarantees like "once it has turned into a
regular page table, we won't see it turn back if we hold the mmap
sem"? Or anything like that? Because it is possible that we could do
this entirely with some ordering guarantee - something like the
attached patch?

Totally untested, of course.

                         Linus

--0016e6dab700d3697d04c1e578be
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h364bcia0

IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BndGFibGUtM2xldmVsLmggfCAyOSArKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDE0IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BndGFibGUtM2xl
dmVsLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlLTNsZXZlbC5oCmluZGV4IDQzODc2
ZjE2Y2FmMS4uNGQ2YmY5ZjU0YmFkIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9w
Z3RhYmxlLTNsZXZlbC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BndGFibGUtM2xldmVs
LmgKQEAgLTUzLDMzICs1MywzNCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgbmF0aXZlX3NldF9wdGUo
cHRlX3QgKnB0ZXAsIHB0ZV90IHB0ZSkKICAqCiAgKiBXaXRoIFRIUCBpZiB0aGUgbW1hcF9zZW0g
aXMgaG9sZCBmb3IgcmVhZGluZywgdGhlIHBtZCBjYW4gYmVjb21lCiAgKiBUSFAgb3IgbnVsbCBv
ciBwb2ludCB0byBhIHB0ZSAoYW5kIGluIHR1cm4gYmVjb21lICJzdGFibGUiKSBhdCBhbnkKLSAq
IHRpbWUgdW5kZXIgcG1kX3JlYWRfYXRvbWljLCBzbyBpdCdzIG1hbmRhdG9yeSB0byByZWFkIGl0
IGF0b21pY2FsbHkKLSAqIHdpdGggY21weGNoZzhiLgorICogdGltZSB1bmRlciBwbWRfcmVhZF9h
dG9taWMsIHNvIHdlIGhhdmUgdG8gYmUgcmVhbGx5IGNhcmVmdWwuIFdlJ2xsCisgKiByZS1yZWFk
IHRoZSBsb3cgd29yZCB0byBjaGVjayB0aGF0IGl0IGhhc24ndCBiZWNvbWUgTlVMTCBvciB0dXJu
ZWQKKyAqIGludG8gYSBwdGUuCiAgKi8KLSNpZm5kZWYgQ09ORklHX1RSQU5TUEFSRU5UX0hVR0VQ
QUdFCiBzdGF0aWMgaW5saW5lIHBtZF90IHBtZF9yZWFkX2F0b21pYyhwbWRfdCAqcG1kcCkKIHsK
IAlwbWR2YWxfdCByZXQ7Ci0JdTMyICp0bXAgPSAodTMyICopcG1kcDsKKwl1MzIgbG93LCBoaWdo
dCwgKnRtcCA9ICh1MzIgKilwbWRwOwogCi0JcmV0ID0gKHBtZHZhbF90KSAoKnRtcCk7Ci0JaWYg
KHJldCkgeworcmVwZWF0OgorCWxvdyA9IHRtcFswXTsKKwloaWdoID0gMDsKKwlpZiAobG93KSB7
CiAJCS8qCiAJCSAqIElmIHRoZSBsb3cgcGFydCBpcyBudWxsLCB3ZSBtdXN0IG5vdCByZWFkIHRo
ZSBoaWdoIHBhcnQKIAkJICogb3Igd2UgY2FuIGVuZCB1cCB3aXRoIGEgcGFydGlhbCBwbWQuCiAJ
CSAqLwogCQlzbXBfcm1iKCk7Ci0JCXJldCB8PSAoKHBtZHZhbF90KSoodG1wICsgMSkpIDw8IDMy
OworCQloaWdoID0gdG1wWzFdOworCQlpZiAoSVNfRU5BQkxFRChDT05GSUdfVFJBTlNQQVJFTlRf
SFVHRVBBR0UpKSB7CisJCQlzbXBfcm1iKCk7CisJCQlpZiAobG93ICE9IHRtcFswXSkKKwkJCQln
b3RvIHJlcGVhdDsKKwkJfQogCX0KIAotCXJldHVybiAocG1kX3QpIHsgcmV0IH07CisJcmV0dXJu
IChwbWRfdCkgeyBsb3cgKyAoKHU2NCloaWdoIDw8IDMyKSB9OwogfQotI2Vsc2UgLyogQ09ORklH
X1RSQU5TUEFSRU5UX0hVR0VQQUdFICovCi1zdGF0aWMgaW5saW5lIHBtZF90IHBtZF9yZWFkX2F0
b21pYyhwbWRfdCAqcG1kcCkKLXsKLQlyZXR1cm4gKHBtZF90KSB7IGF0b21pYzY0X3JlYWQoKGF0
b21pYzY0X3QgKilwbWRwKSB9OwotfQotI2VuZGlmIC8qIENPTkZJR19UUkFOU1BBUkVOVF9IVUdF
UEFHRSAqLwogCiBzdGF0aWMgaW5saW5lIHZvaWQgbmF0aXZlX3NldF9wdGVfYXRvbWljKHB0ZV90
ICpwdGVwLCBwdGVfdCBwdGUpCiB7Cg==
--0016e6dab700d3697d04c1e578be--
