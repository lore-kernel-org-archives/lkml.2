Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3AHRwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:52:12 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:38358 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3AHRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:52:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130108173747.GF9163@redhat.com>
References: <20130105152208.GA3386@redhat.com> <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
 <alpine.LNX.2.00.1301061037140.28950@eggly.anvils> <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
 <CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
 <CAJd=RBDTvCcYV8qAd-++_DOyDSypQD4Dvt216pG9nTQnWA2uCA@mail.gmail.com>
 <CA+55aFzfUABPycR82aNQhHNasQkL1kmxLN1rD0DJcByFtead3g@mail.gmail.com>
 <20130108163141.GA27555@shutemov.name> <CA+55aFzaTvF7nYxWBT-G_b=xGz+_akRAeJ=U9iHy+Y=ZPo=pbA@mail.gmail.com>
 <20130108173747.GF9163@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Jan 2013 09:51:47 -0800
X-Google-Sender-Auth: 41SkyNd3UC3ATA3ErYcN3mloYi0
Message-ID: <CA+55aFyG26N3_KiA8_cxLW59xFMJBK8SKfG4qL80NMQ3tdh3Nw@mail.gmail.com>
Subject: Re: oops in copy_page_rep()
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: multipart/mixed; boundary=047d7b6daa70b8ee0404d2ca9a58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6daa70b8ee0404d2ca9a58
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 8, 2013 at 9:37 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> The reason it returned to userland and retried the fault is that this
> should be infrequent enough not to worry about it and this was
> marginally simpler but it could be changed.

Yeah, that was my suspicion. And as mentioned, returning to user land
might actually help with scheduling and/or signal handling latencies
etc, so it might be the right thing to do.  Especially if the
alternative is to just busy-loop.

> If we don't want to return to userland we should wait on the splitting
> bit and then take the pte walking routines like if the pmd wasn't
> huge. This is not related to the below though.

How does this patch sound to people? It does the splitting check
before the access bit set (even though I don't think it matters), and
at least talks about the alternatives and the issues a bit.

Hmm?

                 Linus

--047d7b6daa70b8ee0404d2ca9a58
Content-Type: application/octet-stream; name="mm.patch"
Content-Disposition: attachment; filename="mm.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbpc6e9i0

IG1tL21lbW9yeS5jIHwgMTIgKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0
aW9ucygrKQoKZGlmZiAtLWdpdCBhL21tL21lbW9yeS5jIGIvbW0vbWVtb3J5LmMKaW5kZXggNDlm
YjFjZjA4NjExLi5mNWVjM2FlMDNmNDQgMTAwNjQ0Ci0tLSBhL21tL21lbW9yeS5jCisrKyBiL21t
L21lbW9yeS5jCkBAIC0zNzE1LDYgKzM3MTUsMTggQEAgcmV0cnk6CiAJCQkJcmV0dXJuIGRvX2h1
Z2VfcG1kX251bWFfcGFnZShtbSwgdm1hLCBhZGRyZXNzLAogCQkJCQkJCSAgICAgb3JpZ19wbWQs
IHBtZCk7CiAKKwkJCS8qCisJCQkgKiBJZiB0aGUgcG1kIGlzIHNwbGl0dGluZywgcmV0dXJuIGFu
ZCByZXRyeSB0aGUKKwkJCSAqIHRoZSBmYXVsdC4gV2UgKmNvdWxkKiBzZXQganVzdCB0aGUgYWNj
ZXNzZWQgZmxhZywKKwkJCSAqIGJ1dCBpdCdzIGJldHRlciB0byBqdXN0IGF2b2lkIHRoZSByYWNl
cyB3aXRoCisJCQkgKiBzcGxpdHRpbmcgZW50aXJlbHkuCisJCQkgKgorCQkJICogQWx0ZXJuYXRp
dmU6IHdhaXQgdW50aWwgdGhlIHNwbGl0IGlzIGRvbmUsIGFuZAorCQkJICogZ290byByZXRyeS4K
KwkJCSAqLworCQkJaWYgKHBtZF90cmFuc19zcGxpdHRpbmcob3JpZ19wbWQpKQorCQkJCXJldHVy
biAwOworCiAJCQlpZiAoZGlydHkgJiYgIXBtZF93cml0ZShvcmlnX3BtZCkpIHsKIAkJCQlyZXQg
PSBkb19odWdlX3BtZF93cF9wYWdlKG1tLCB2bWEsIGFkZHJlc3MsIHBtZCwKIAkJCQkJCQkgIG9y
aWdfcG1kKTsK
--047d7b6daa70b8ee0404d2ca9a58--
