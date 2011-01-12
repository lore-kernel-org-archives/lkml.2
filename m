Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1ALUyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:54:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020Ab1ALUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:54:08 -0500
MIME-Version: 1.0
In-Reply-To: <4D2E1010.4080706@redhat.com>
References: <4D2ACFA7.6000502@redhat.com> <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
 <4D2C21FE.3000406@redhat.com> <4D2E1010.4080706@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 12:53:14 -0800
Message-ID: <AANLkTimLJnV9oJwnaN+jdvNus4cxuqvgUqHUwi7vpqBe@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
To: Rik van Riel <riel@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000325575c96fdc4e30499ac64d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000325575c96fdc4e30499ac64d2
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 12, 2011 at 12:33 PM, Rik van Riel <riel@redhat.com> wrote:
>
> Now that we have FAULT_FLAG_ALLOW_RETRY, the async
> pagefault patches can be a little smaller.

I suspect you do still want a new page flag, to say that
FAULT_FLAG_ALLOW_RETRY shouldn't actually wait for the page that it
allows retry for.

But even then, that flag should not be named "MINOR", it should be
about what the behaviour is actually all about ("NOWAIT_RETRY" or
whatever - it presumably would also cause us to not drop the
mmap_sem).

IOW, these days I suspect the patch _should_ look something like the attached.

Anyway, with this, you should be able to use

  FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT

to basically get a non-waiting page fault (and it will return the
VM_FAULT_RETRY error code if it failed).

NOTE! TOTALLY UNTESTED!

                       Linus

--000325575c96fdc4e30499ac64d2
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_giupg9oa0

IGluY2x1ZGUvbGludXgvbW0uaCB8ICAgIDEgKwogbW0vZmlsZW1hcC5jICAgICAgIHwgICAgNiAr
KysrLS0KIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW0uaCBiL2luY2x1ZGUvbGludXgvbW0uaAppbmRl
eCA3MjFmNDUxLi5kYzgzNTY1IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L21tLmgKKysrIGIv
aW5jbHVkZS9saW51eC9tbS5oCkBAIC0xNDUsNiArMTQ1LDcgQEAgZXh0ZXJuIHBncHJvdF90IHBy
b3RlY3Rpb25fbWFwWzE2XTsKICNkZWZpbmUgRkFVTFRfRkxBR19OT05MSU5FQVIJMHgwMgkvKiBG
YXVsdCB3YXMgdmlhIGEgbm9ubGluZWFyIG1hcHBpbmcgKi8KICNkZWZpbmUgRkFVTFRfRkxBR19N
S1dSSVRFCTB4MDQJLyogRmF1bHQgd2FzIG1rd3JpdGUgb2YgZXhpc3RpbmcgcHRlICovCiAjZGVm
aW5lIEZBVUxUX0ZMQUdfQUxMT1dfUkVUUlkJMHgwOAkvKiBSZXRyeSBmYXVsdCBpZiBibG9ja2lu
ZyAqLworI2RlZmluZSBGQVVMVF9GTEFHX1JFVFJZX05PV0FJVAkweDEwCS8qIERvbid0IGRyb3Ag
bW1hcF9zZW0gYW5kIHdhaXQgd2hlbiByZXRyeWluZyAqLwogCiAvKgogICogVGhpcyBpbnRlcmZh
Y2UgaXMgdXNlZCBieSB4ODYgUEFUIGNvZGUgdG8gaWRlbnRpZnkgYSBwZm4gbWFwcGluZyB0aGF0
IGlzCmRpZmYgLS1naXQgYS9tbS9maWxlbWFwLmMgYi9tbS9maWxlbWFwLmMKaW5kZXggY2EzODkz
OS4uMTBlZWNmNyAxMDA2NDQKLS0tIGEvbW0vZmlsZW1hcC5jCisrKyBiL21tL2ZpbGVtYXAuYwpA
QCAtNjIxLDggKzYyMSwxMCBAQCBpbnQgX19sb2NrX3BhZ2Vfb3JfcmV0cnkoc3RydWN0IHBhZ2Ug
KnBhZ2UsIHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLAogCQlfX2xvY2tfcGFnZShwYWdlKTsKIAkJcmV0
dXJuIDE7CiAJfSBlbHNlIHsKLQkJdXBfcmVhZCgmbW0tPm1tYXBfc2VtKTsKLQkJd2FpdF9vbl9w
YWdlX2xvY2tlZChwYWdlKTsKKwkJaWYgKCEoZmxhZ3MgJiBGQVVMVF9GTEFHX1JFVFJZX05PV0FJ
VCkpIHsKKwkJCXVwX3JlYWQoJm1tLT5tbWFwX3NlbSk7CisJCQl3YWl0X29uX3BhZ2VfbG9ja2Vk
KHBhZ2UpOworCQl9CiAJCXJldHVybiAwOwogCX0KIH0K
--000325575c96fdc4e30499ac64d2--
