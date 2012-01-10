Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2AJQBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:01:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56764 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab2AJQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:01:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfpegu6BrLbmMSbf0QnKRe5rq0HgZYtYBEW8F+qehZC9GpQ8w@mail.gmail.com>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu> <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk> <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard> <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
 <20120110013434.GA23916@ZenIV.linux.org.uk> <CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
 <CAJfpegu6BrLbmMSbf0QnKRe5rq0HgZYtYBEW8F+qehZC9GpQ8w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 08:00:30 -0800
X-Google-Sender-Auth: z1EXGKoIMQKw04sNBwqfZJzNGcE
Message-ID: <CA+55aFxszjhj5MatYe_KXJ=vYyf-05kzBbtmY1vgoGUio0DXuQ@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Content-Type: multipart/mixed; boundary=bcaec53d550d22dcda04b62ea195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec53d550d22dcda04b62ea195
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2012 at 2:05 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> I tested Dave's patch and the bug can still be easily reproduced.
>
> And that's to be expected, as the intermediate "being on the lru"
> state that Dave's patch eliminates doesn't play a fundamental part in
> the mechanism of the livelock. =A0It does eliminate one trylock, but
> that's not the one critical to this bug (removing it is a very good
> idea anyway).
>
> The critical trylock here is the one in dentry_kill() which tries to
> lock the parent.

Ok. Here's your patch munged for current -git. You've got most of a
changelog, can you send this out with the right subject and a
sign-off, and re-test with the current git just to make sure.

Al, do you want to handle this or should I take it directly? I'm
assuming nobody has any objections to Miklos' patch?

                                    Linus

--bcaec53d550d22dcda04b62ea195
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx93whep0

IGZzL2RjYWNoZS5jICAgICAgICAgICAgfCAgICA4ICsrKysrLS0tCiBpbmNsdWRlL2xpbnV4L2Rj
YWNoZS5oIHwgICAgMSArCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9kY2FjaGUuYyBiL2ZzL2RjYWNoZS5jCmluZGV4IDNj
NmQzMTEzYTI1NS4uNjQ3N2FmMjRmZjBkIDEwMDY0NAotLS0gYS9mcy9kY2FjaGUuYworKysgYi9m
cy9kY2FjaGUuYwpAQCAtMjQzLDYgKzI0Myw3IEBAIHN0YXRpYyB2b2lkIGRlbnRyeV9scnVfYWRk
KHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIHN0YXRpYyB2b2lkIF9fZGVudHJ5X2xydV9kZWwoc3Ry
dWN0IGRlbnRyeSAqZGVudHJ5KQogewogCWxpc3RfZGVsX2luaXQoJmRlbnRyeS0+ZF9scnUpOwor
CWRlbnRyeS0+ZF9mbGFncyAmPSB+RENBQ0hFX1NIUklOS19MSVNUOwogCWRlbnRyeS0+ZF9zYi0+
c19ucl9kZW50cnlfdW51c2VkLS07CiAJZGVudHJ5X3N0YXQubnJfdW51c2VkLS07CiB9CkBAIC04
MDYsNiArODA3LDcgQEAgcmVsb2NrOgogCQkJc3Bpbl91bmxvY2soJmRlbnRyeS0+ZF9sb2NrKTsK
IAkJfSBlbHNlIHsKIAkJCWxpc3RfbW92ZV90YWlsKCZkZW50cnktPmRfbHJ1LCAmdG1wKTsKKwkJ
CWRlbnRyeS0+ZF9mbGFncyB8PSBEQ0FDSEVfU0hSSU5LX0xJU1Q7CiAJCQlzcGluX3VubG9jaygm
ZGVudHJ5LT5kX2xvY2spOwogCQkJaWYgKCEtLWNvdW50KQogCQkJCWJyZWFrOwpAQCAtMTA5OCwx
MSArMTEwMCwxMSBAQCByZXN1bWU6CiAJCS8qCiAJCSAqIG1vdmUgb25seSB6ZXJvIHJlZiBjb3Vu
dCBkZW50cmllcyB0byB0aGUgZGlzcG9zZSBsaXN0LgogCQkgKi8KLQkJaWYgKCFkZW50cnktPmRf
Y291bnQpIHsKKwkJaWYgKGRlbnRyeS0+ZF9jb3VudCkgeworCQkJZGVudHJ5X2xydV9kZWwoZGVu
dHJ5KTsKKwkJfSBlbHNlIGlmKCEoZGVudHJ5LT5kX2ZsYWdzICYgRENBQ0hFX1NIUklOS19MSVNU
KSkgewogCQkJZGVudHJ5X2xydV9tb3ZlX2xpc3QoZGVudHJ5LCBkaXNwb3NlKTsKIAkJCWZvdW5k
Kys7Ci0JCX0gZWxzZSB7Ci0JCQlkZW50cnlfbHJ1X2RlbChkZW50cnkpOwogCQl9CiAKIAkJLyoK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZGNhY2hlLmggYi9pbmNsdWRlL2xpbnV4L2RjYWNo
ZS5oCmluZGV4IGE0N2JkYTVmNzZkYi4uMzFmNzMyMjBlN2Q3IDEwMDY0NAotLS0gYS9pbmNsdWRl
L2xpbnV4L2RjYWNoZS5oCisrKyBiL2luY2x1ZGUvbGludXgvZGNhY2hlLmgKQEAgLTIwMyw2ICsy
MDMsNyBAQCBzdHJ1Y3QgZGVudHJ5X29wZXJhdGlvbnMgewogCiAjZGVmaW5lIERDQUNIRV9DQU5U
X01PVU5UCTB4MDEwMAogI2RlZmluZSBEQ0FDSEVfR0VOT0NJREUJCTB4MDIwMAorI2RlZmluZSBE
Q0FDSEVfU0hSSU5LX0xJU1QJMHgwNDAwCiAKICNkZWZpbmUgRENBQ0hFX05GU0ZTX1JFTkFNRUQJ
MHgxMDAwCiAgICAgIC8qIHRoaXMgZGVudHJ5IGhhcyBiZWVuICJzaWxseSByZW5hbWVkIiBhbmQg
aGFzIHRvIGJlIGRlbGV0ZWQgb24gdGhlIGxhc3QK
--bcaec53d550d22dcda04b62ea195--
