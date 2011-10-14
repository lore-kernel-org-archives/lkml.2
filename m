Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1JNErF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:47:05 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48797 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1JNErE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7HYnDVUyLA=FQ-qmuh=J=H=JOQTBMP_wt_zwzOfe9-7Hg@mail.gmail.com>
References: <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
 <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
 <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
 <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
 <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
 <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com>
 <20111010114840.GC17079@elte.hu> <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
 <20111011062253.GA3589@elte.hu> <4E947BC9.7040805@mit.edu>
 <CA+55aFyMXgzywjXCtS1a5F-BDu_XP4ecg3Tw7zLuawZs0QNYaw@mail.gmail.com> <CAObL_7HYnDVUyLA=FQ-qmuh=J=H=JOQTBMP_wt_zwzOfe9-7Hg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Oct 2011 16:46:42 +1200
X-Google-Sender-Auth: 1mDSYOFo3M9EeL7JN_p4-CWQcA4
Message-ID: <CA+55aFzoDi-WP-2Uq-33FAGfMPZbrsvg6_QWEKm1zczET539PQ@mail.gmail.com>
Subject: Re: [RFC] fixing the UML failure root cause
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e64c1ba2bce0ba04af3af237
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64c1ba2bce0ba04af3af237
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13, 2011 at 8:40 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> How does that work? =A0The tricky case is when one of those three words
> spans a page boundary if the access to the first page is valid, but
> the access to the second page is not. =A0When that happens, if we report
> the fault as coming from the first page, then UML is likely to get
> think the fault was spurious and enter an infinite loop.

Hmm. Gaah, I just find that memcpy loop disgusting.

We already have that ugly "uaccess_error" crap in handle_exception(),
we might as well do something like the attached and just say "hey, now
you can catch the page fault information for a get_user/put_user
fault".

Isn't that much nicer?

You don't even have to check each word, you can just take the last
exception info from the thread-info.

              Linus

--0016e64c1ba2bce0ba04af3af237
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtqoxhza0

IGFyY2gveDg2L2luY2x1ZGUvYXNtL3RocmVhZF9pbmZvLmggfCAgICAyICsrCiBhcmNoL3g4Ni9t
bS9mYXVsdC5jICAgICAgICAgICAgICAgIHwgICAgNiArKysrKy0KIDIgZmlsZXMgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3RocmVhZF9pbmZvLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90aHJlYWRfaW5m
by5oCmluZGV4IGExZmU1YzEyN2I1Mi4uZThkMjQ1ZmViZmFlIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Ro
cmVhZF9pbmZvLmgKQEAgLTQxLDYgKzQxLDggQEAgc3RydWN0IHRocmVhZF9pbmZvIHsKIAlfX3U4
CQkJc3VwZXJ2aXNvcl9zdGFja1swXTsKICNlbmRpZgogCWludAkJCXVhY2Nlc3NfZXJyOworCWlu
dAkJCXVhY2Nlc3NfZXJyb3JfY29kZTsKKwl1bnNpZ25lZCBsb25nCQl1YWNjZXNzX2FkZHI7CiB9
OwogCiAjZGVmaW5lIElOSVRfVEhSRUFEX0lORk8odHNrKQkJCVwKZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L21tL2ZhdWx0LmMgYi9hcmNoL3g4Ni9tbS9mYXVsdC5jCmluZGV4IDBkMTdjOGM1MGFjZC4u
YmJiZWU2ZTZhOTViIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9tbS9mYXVsdC5jCisrKyBiL2FyY2gv
eDg2L21tL2ZhdWx0LmMKQEAgLTYyOCw4ICs2MjgsMTIgQEAgbm9fY29udGV4dChzdHJ1Y3QgcHRf
cmVncyAqcmVncywgdW5zaWduZWQgbG9uZyBlcnJvcl9jb2RlLAogCWludCBzaWc7CiAKIAkvKiBB
cmUgd2UgcHJlcGFyZWQgdG8gaGFuZGxlIHRoaXMga2VybmVsIGZhdWx0PyAqLwotCWlmIChmaXh1
cF9leGNlcHRpb24ocmVncykpCisJaWYgKGZpeHVwX2V4Y2VwdGlvbihyZWdzKSkgeworCQlzdHJ1
Y3QgdGhyZWFkX2luZm8gKnRpID0gY3VycmVudF90aHJlYWRfaW5mbygpOworCQl0aS0+dWFjY2Vz
c19lcnJvcl9jb2RlID0gZXJyb3JfY29kZTsKKwkJdGktPnVhY2Nlc3NfYWRkciA9IGFkZHJlc3M7
CiAJCXJldHVybjsKKwl9CiAKIAkvKgogCSAqIDMyLWJpdDoK
--0016e64c1ba2bce0ba04af3af237--
