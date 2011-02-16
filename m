Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab1BPPrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:47:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995Ab1BPPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:47:12 -0500
MIME-Version: 1.0
In-Reply-To: <1297854842.3201.197.camel@edumazet-laptop>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com> <1297854842.3201.197.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 07:46:20 -0800
Message-ID: <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc5
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=00221534d727e2fcb9049c682fb3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00221534d727e2fcb9049c682fb3
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Feb 16, 2011 at 3:14 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Using this kernel on my dev machine (2x4x2 cpus), I hit BUG_ON() in
> fs/namei.c:1461 on my kernel build (make -j16)

Uhhuh. We replaced one BUG_ON() with another.

And I think it's a really silly problem too: when Al moved the

        /* We drop rcu-walk here */
        if (nameidata_dentry_drop_rcu_maybe(nd, path->dentry))
                return -ECHILD;

test into do_follow_link(), he _should_ have moved the BUG_ON() in
there too, methinks. He didn't, and as a result the BUG_ON() is now
before the "drop_rcu_maybe".

This patch should fix it. Al? Comments?

(Of course, we could just remove the BUG_ON() entirely, but
considering that this is still fragile new code I'd rather leave it
in)

                               Linus

--00221534d727e2fcb9049c682fb3
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk8ex5po0

IGZzL25hbWVpLmMgfCAgICA5ICsrKystLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvbmFtZWkuYyBiL2ZzL25hbWVp
LmMKaW5kZXggOWU3MDFlMi4uMDA4N2NmOSAxMDA2NDQKLS0tIGEvZnMvbmFtZWkuYworKysgYi9m
cy9uYW1laS5jCkBAIC03OTUsNyArNzk1LDcgQEAgX19kb19mb2xsb3dfbGluayhjb25zdCBzdHJ1
Y3QgcGF0aCAqbGluaywgc3RydWN0IG5hbWVpZGF0YSAqbmQsIHZvaWQgKipwKQogICogV2l0aG91
dCB0aGF0IGtpbmQgb2YgdG90YWwgbGltaXQsIG5hc3R5IGNoYWlucyBvZiBjb25zZWN1dGl2ZQog
ICogc3ltbGlua3MgY2FuIGNhdXNlIGFsbW9zdCBhcmJpdHJhcmlseSBsb25nIGxvb2t1cHMuIAog
ICovCi1zdGF0aWMgaW5saW5lIGludCBkb19mb2xsb3dfbGluayhzdHJ1Y3QgcGF0aCAqcGF0aCwg
c3RydWN0IG5hbWVpZGF0YSAqbmQpCitzdGF0aWMgaW5saW5lIGludCBkb19mb2xsb3dfbGluayhz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgcGF0aCAqcGF0aCwgc3RydWN0IG5hbWVpZGF0YSAq
bmQpCiB7CiAJdm9pZCAqY29va2llOwogCWludCBlcnIgPSAtRUxPT1A7CkBAIC04MDMsNiArODAz
LDcgQEAgc3RhdGljIGlubGluZSBpbnQgZG9fZm9sbG93X2xpbmsoc3RydWN0IHBhdGggKnBhdGgs
IHN0cnVjdCBuYW1laWRhdGEgKm5kKQogCS8qIFdlIGRyb3AgcmN1LXdhbGsgaGVyZSAqLwogCWlm
IChuYW1laWRhdGFfZGVudHJ5X2Ryb3BfcmN1X21heWJlKG5kLCBwYXRoLT5kZW50cnkpKQogCQly
ZXR1cm4gLUVDSElMRDsKKwlCVUdfT04oaW5vZGUgIT0gcGF0aC0+ZGVudHJ5LT5kX2lub2RlKTsK
IAogCWlmIChjdXJyZW50LT5saW5rX2NvdW50ID49IE1BWF9ORVNURURfTElOS1MpCiAJCWdvdG8g
bG9vcDsKQEAgLTE0MTMsOCArMTQxNCw3IEBAIGV4ZWNfYWdhaW46CiAJCQlnb3RvIG91dF9kcHV0
OwogCiAJCWlmIChpbm9kZS0+aV9vcC0+Zm9sbG93X2xpbmspIHsKLQkJCUJVR19PTihpbm9kZSAh
PSBuZXh0LmRlbnRyeS0+ZF9pbm9kZSk7Ci0JCQllcnIgPSBkb19mb2xsb3dfbGluaygmbmV4dCwg
bmQpOworCQkJZXJyID0gZG9fZm9sbG93X2xpbmsoaW5vZGUsICZuZXh0LCBuZCk7CiAJCQlpZiAo
ZXJyKQogCQkJCWdvdG8gcmV0dXJuX2VycjsKIAkJCW5kLT5pbm9kZSA9IG5kLT5wYXRoLmRlbnRy
eS0+ZF9pbm9kZTsKQEAgLTE0NTgsOCArMTQ1OCw3IEBAIGxhc3RfY29tcG9uZW50OgogCQkJYnJl
YWs7CiAJCWlmIChpbm9kZSAmJiB1bmxpa2VseShpbm9kZS0+aV9vcC0+Zm9sbG93X2xpbmspICYm
CiAJCSAgICAobG9va3VwX2ZsYWdzICYgTE9PS1VQX0ZPTExPVykpIHsKLQkJCUJVR19PTihpbm9k
ZSAhPSBuZXh0LmRlbnRyeS0+ZF9pbm9kZSk7Ci0JCQllcnIgPSBkb19mb2xsb3dfbGluaygmbmV4
dCwgbmQpOworCQkJZXJyID0gZG9fZm9sbG93X2xpbmsoaW5vZGUsICZuZXh0LCBuZCk7CiAJCQlp
ZiAoZXJyKQogCQkJCWdvdG8gcmV0dXJuX2VycjsKIAkJCW5kLT5pbm9kZSA9IG5kLT5wYXRoLmRl
bnRyeS0+ZF9pbm9kZTsK
--00221534d727e2fcb9049c682fb3--
