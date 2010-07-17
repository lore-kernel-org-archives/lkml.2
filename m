Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab0GQTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 15:16:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760106Ab0GQTQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 15:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <4C41FD6E.9090603@superonline.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
	<AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
	<89khjo$fr177d@orsmga002.jf.intel.com>
	<AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com>
	<AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
	<4C2D180C.5050805@superonline.com>
	<AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com>
	<AANLkTilOWu6ZwWjwPfHvNXDhyjb6n4N5KV1rUx6byJmq@mail.gmail.com>
	<AANLkTilfkCBfZtRQlybQ721PSF4lSlqeOKL3rYnEz2G1@mail.gmail.com>
	<AANLkTikpw42jE5Eh0EkXuRh70mb9x3njX6R4JNshawe5@mail.gmail.com>
	<4C41FD6E.9090603@superonline.com>
Date: Sat, 17 Jul 2010 12:15:54 -0700
Message-ID: <AANLkTikqSwnLqJXPYGjMP0NS8TJ4D2uOBLDipoV89Qwc@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: Dave Airlie <airlied@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        earny@net4u.de, Roman Jarosz <kedgedev@gmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        jcnengel@googlemail.com, "A. Boulan" <arnaud.boulan@libertysurf.fr>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
        michael@reinelt.co.at, stable@kernel.org
Content-Type: multipart/mixed; boundary=000e0cd5198616a7b9048b9a2a7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd5198616a7b9048b9a2a7d
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Jul 17, 2010 at 11:58 AM, M. Vefa Bicakci
<bicave@superonline.com> wrote:
>
> The kernel with d8e0902806c0bd2ccc4f6a267ff52565a3ec933b reverted
> was able to hibernate/thaw at least 40 times in one go, while
> the one with your fix applied was able to hibernate/thaw at most
> 17 times (in two separate trials) after which it crashed during
> the next thaw.

Ok. I do wonder if the bug is possibly something entirely different,
and the allocation patterns just happen to expose/hide it. Reverting
the original commit should be pretty darn close to applying my fix.
Any remaining issues would seem to be more about the actual bug in the
original code (racing on changing that mapping->gfp_mask witthout any
locking) than about anything else.

> Is there anything I can do find out the correct flags to use
> in addition to GFP_HIGHUSER ? Can I do something like a bisection
> for the flags one by one starting from the pre 2.6.32.8 state?
> If you could outline a procedure to do this, I would be glad to
> follow it.

You can try adding __GFP_RECLAIMABLE | __GFP_NOMEMALLOC to the set of
flags in i915_gem_object_get_pages(). That's what the old code had
(and then it played games with NORETRY|NOWARN). I've attached a patch
(UNTESTED! Maybe it won't compile).

Now, I don't see why those flags would matter, but NOMEMALLOC in
particular does make a difference for memory allocation patterns under
low memory conditions, so maybe it could make a difference.

And if it _does_ make a difference, it would be interesting to know
which of the two flags matter. So try both flags first, and see if
that gets you something reliable. And if it does, remove one of them
and try again - just to see _which_ flag it is that the i915 driver
would care about. That would hopefully give us a hint.

> Sorry to bug you again about this problem because of incomplete
> testing on my part.

Oh, never be sorry for testing even more, and testing something nobody
else bothered to test.

             Linus

--000e0cd5198616a7b9048b9a2a7d
Content-Type: application/octet-stream; name=diff
Content-Disposition: attachment; filename=diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbqu8fn00

IGRyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZ2VtLmMgfCAgICAyICsrCiAxIGZpbGVzIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2dwdS9kcm0vaTkxNS9pOTE1X2dlbS5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9nZW0u
YwppbmRleCAwNzQzODU4Li45ODQ5NmQ0IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9pOTE1X2dlbS5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZ2VtLmMKQEAgLTIy
NDEsNiArMjI0MSw4IEBAIGk5MTVfZ2VtX29iamVjdF9nZXRfcGFnZXMoc3RydWN0IGRybV9nZW1f
b2JqZWN0ICpvYmosCiAJCXBhZ2UgPSByZWFkX2NhY2hlX3BhZ2VfZ2ZwKG1hcHBpbmcsIGksCiAJ
CQkJCSAgIEdGUF9ISUdIVVNFUiB8CiAJCQkJCSAgIF9fR0ZQX0NPTEQgfAorCQkJCQkgICBfX0dG
UF9SRUNMQUlNQUJMRSB8CisJCQkJCSAgIF9fR0ZQX05PTUVNQUxMT0MgfAogCQkJCQkgICBnZnBt
YXNrKTsKIAkJaWYgKElTX0VSUihwYWdlKSkKIAkJCWdvdG8gZXJyX3BhZ2VzOwo=
--000e0cd5198616a7b9048b9a2a7d--
