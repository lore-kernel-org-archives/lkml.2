Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0HXRdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:33:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:49073 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab0HXRdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:33:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,263,1280732400"; 
   d="c'?scan'208";a="548282503"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Tue, 24 Aug 2010 10:33:02 -0700
Subject: RE: [PATCH] guard page for stacks that grow upwards
Thread-Topic: [PATCH] guard page for stacks that grow upwards
Thread-Index: ActDrPqXu107GN7KSl6/zjIwfd7cUgABHBFQ
Message-ID: <987664A83D2D224EAE907B061CE93D53015D8130ED@orsmsx505.amr.corp.intel.com>
References: <4c73f3ed34663af90@agluck-desktop.sc.intel.com>
 <AANLkTinQ_0zGJnPHw7AMJ+q+oo4nmA9Z4irw8dqRH9S8@mail.gmail.com>
In-Reply-To: <AANLkTinQ_0zGJnPHw7AMJ+q+oo4nmA9Z4irw8dqRH9S8@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_987664A83D2D224EAE907B061CE93D53015D8130EDorsmsx505amrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_987664A83D2D224EAE907B061CE93D53015D8130EDorsmsx505amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> But the ia64 grows-up case is tested?

Yes. The attached hacky test program reports that the RSE stack
stomps over the mmap'd segment w/o this patch. With it the
program dies with a SIGBUS. Should be easy to adapt to
test on pa-risc (hint, hint to parisc people).

>> The #ifdefs are ugly - suggestions welcome on how to make
>> the code prettier.
>
> One thing I've considered is to get rid of the CONFIG_STACK_GROWSUP
> crap entirely in code, and instead just make the VM_GROWSUP #define be
> 0 for architectures that don't want it. The compiler should then just
> automatically remove all the code that says
>
>   if (vma->vm_flags & VM_GROWSUP) {
>     ...
>
> and the code would look more straightforward. Hmm?

You'd also need some stub declaration for expand_upwards().
But overall that would look cleaner.

-Tony

--_002_987664A83D2D224EAE907B061CE93D53015D8130EDorsmsx505amrc_
Content-Type: text/plain; name="growtest.c"
Content-Description: growtest.c
Content-Disposition: attachment; filename="growtest.c"; size=771;
	creation-date="Tue, 24 Aug 2010 10:26:55 GMT";
	modification-date="Tue, 24 Aug 2010 10:26:55 GMT"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5cy9t
bWFuLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8
c3RyaW5nLmg+Cgp2b2lkIHdhdGNoKGxvbmcgZGVwdGgsIGNoYXIgKm1hcCkKewoJaW50IGk7CgoJ
Zm9yIChpID0gMDsgaSA8IDB4MTAwMDA7IGkrKykgewoJCWlmIChtYXBbaV0pIHsKCQkJcHJpbnRm
KCJGb3VuZCAleCBhdCAlcFxuIiwgbWFwW2ldLCAmbWFwW2ldKTsKCQkJZXhpdCgxKTsKCQl9Cgl9
CglpZiAoKytkZXB0aCAlIDUwMDAgPT0gMCkKCQlwcmludGYoIm5vdyBhdCBzdGFjayBkZXB0aCAl
bGRcbiIsIGRlcHRoKTsKCXdhdGNoKGRlcHRoLCBtYXApOwoKCS8qIHdvbid0IGdldCBoZXJlIC4u
IGJ1dCBzdG9wIGNvbXBpbGVyIGZyb20gZG9pbmcgdGFpbCByZWN1cnNpb24gKi8KCWZvciAoaSA9
IDA7IGkgPCAweDEwMDAwOyBpKyspIHsKCQlpZiAobWFwW2ldKSB7CgkJCXByaW50ZigiRm91bmQg
JXggYXQgJXBcbiIsIG1hcFtpXSwgJm1hcFtpXSk7CgkJCWV4aXQoMSk7CgkJfQoJfQp9CgkKbWFp
bigpCnsKCWNoYXIgKnA7CgoJcCA9IG1tYXAoKHZvaWQgKikweDYwMDgwMDAwMDAwMDAwMDAsIDB4
MTAwMDAsIFBST1RfUkVBRHxQUk9UX1dSSVRFLAoJCU1BUF9BTk9OWU1PVVN8TUFQX1BSSVZBVEUs
IC0xLCAwTCk7CgoJcHJpbnRmKCIlcFxuIiwgcCk7CgltZW1zZXQocCwgJ1wwJywgMHgxMDAwMCk7
CgoJd2F0Y2goMCwgcCk7CgoJcmV0dXJuIDA7Cn0K

--_002_987664A83D2D224EAE907B061CE93D53015D8130EDorsmsx505amrc_--
