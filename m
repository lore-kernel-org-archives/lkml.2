Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1LCXIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 18:08:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48979 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1LCXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 18:08:20 -0500
MIME-Version: 1.0
In-Reply-To: <4EDA89F2.9070107@lwfinger.net>
References: <4ED5B70F.606@lwfinger.net> <4ED5C640.8030102@linux.vnet.ibm.com>
 <4ED5D6C5.5050704@lwfinger.net> <4EDA89F2.9070107@lwfinger.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 3 Dec 2011 15:07:56 -0800
X-Google-Sender-Auth: mOOXGiTzO8OLbFAl742PgdluqU8
Message-ID: <CA+55aFwWVeAGT2p3tohRLh7VL8f4ztGwAHZxBmosEAGKJfL+Qg@mail.gmail.com>
Subject: Re: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
To: Larry Finger <Larry.Finger@lwfinger.net>, Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6d7e82a2fc4a804b33829de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d7e82a2fc4a804b33829de
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Dec 3, 2011 at 12:43 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 11/30/2011 01:09 AM, Larry Finger wrote:
>> On 11/29/2011 11:59 PM, Srivatsa S. Bhat wrote:
>>>
>>> Can you please try out the patch posted in
>>> https://lkml.org/lkml/2011/11/28/178 ?

Ugh. I hate that patch.

It's completely stupid. If "rdmsr_safe()" doesn't work at that point
in the boot, then it's pointless to call it.

So this change is pure and utter crap:

  -	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
  +	if (c->x86 >= 0xf)
  +		rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);

because it is misleading as hell: that rdmsr isn't *safe* at all, so
why are we calling "rdmsr_safe()"?

It's wrong.

The right patch would either just remove the "safe" part (and just say
that the register has to be supported if c->x86 >= 0xf), but quite
honestly, I don't see why we do that thing in early_init_amd() AT ALL.
Afaik, the microcode version field isn't really *needed* by the
kernelin the first place, much less is it needed by the *early* boot,
so why isn't this in 'init_amd()' a bit later when the "safe" version
actually *works*?

IOW, I think the patch should be something like the attached (TOTALLY
UNTESTED) patch. Larry, does this work for you? It just moves the
rdmsr_safe() to the later function.

Borislav?

> I just updated mainline to 3.2-rc4, and that patch is not included. Please
> check with Ingo to see why it was not available. It is a real show stopper
> for old AMD CPUs.

Ingo seems to have fallen off the earth for the last two weeks.
There's *one* email form him about 12 hours ago, before that the last
one I see is from early November.

Ingo, everything ok?

                   Linus

--0016e6d7e82a2fc4a804b33829de
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvr8d4630

IGFyY2gveDg2L2tlcm5lbC9jcHUvYW1kLmMgfCAgICA4ICsrKystLS0tCiAxIGZpbGVzIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rZXJuZWwvY3B1L2FtZC5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9hbWQuYwppbmRleCBjN2U0
NmNiMzUzMjcuLjBiYWIyYjE4YmIyMCAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9h
bWQuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2FtZC5jCkBAIC00NDIsOCArNDQyLDYgQEAg
c3RhdGljIHZvaWQgX19jcHVpbml0IGJzcF9pbml0X2FtZChzdHJ1Y3QgY3B1aW5mb194ODYgKmMp
CiAKIHN0YXRpYyB2b2lkIF9fY3B1aW5pdCBlYXJseV9pbml0X2FtZChzdHJ1Y3QgY3B1aW5mb194
ODYgKmMpCiB7Ci0JdTMyIGR1bW15OwotCiAJZWFybHlfaW5pdF9hbWRfbWMoYyk7CiAKIAkvKgpA
QCAtNDczLDEyICs0NzEsMTIgQEAgc3RhdGljIHZvaWQgX19jcHVpbml0IGVhcmx5X2luaXRfYW1k
KHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKIAkJCXNldF9jcHVfY2FwKGMsIFg4Nl9GRUFUVVJFX0VY
VERfQVBJQ0lEKTsKIAl9CiAjZW5kaWYKLQotCXJkbXNyX3NhZmUoTVNSX0FNRDY0X1BBVENIX0xF
VkVMLCAmYy0+bWljcm9jb2RlLCAmZHVtbXkpOwogfQogCiBzdGF0aWMgdm9pZCBfX2NwdWluaXQg
aW5pdF9hbWQoc3RydWN0IGNwdWluZm9feDg2ICpjKQogeworCXUzMiBkdW1teTsKKwogI2lmZGVm
IENPTkZJR19TTVAKIAl1bnNpZ25lZCBsb25nIGxvbmcgdmFsdWU7CiAKQEAgLTY1Nyw2ICs2NTUs
OCBAQCBzdGF0aWMgdm9pZCBfX2NwdWluaXQgaW5pdF9hbWQoc3RydWN0IGNwdWluZm9feDg2ICpj
KQogCQkJY2hlY2tpbmdfd3Jtc3JsKE1TUl9BTUQ2NF9NQ3hfTUFTSyg0KSwgbWFzayk7CiAJCX0K
IAl9CisKKwlyZG1zcl9zYWZlKE1TUl9BTUQ2NF9QQVRDSF9MRVZFTCwgJmMtPm1pY3JvY29kZSwg
JmR1bW15KTsKIH0KIAogI2lmZGVmIENPTkZJR19YODZfMzIK
--0016e6d7e82a2fc4a804b33829de--
