Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab0IDTyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 15:54:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46656 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0IDTyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 15:54:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=D2rv/IA5YFidlQh33/04y8n1ujlRSaiOu4jNwMmtDPngbo7dd1odP6ZnJGGdczd6l
	TLf4XoGcqibdPVXV1zVaw==
Date: Sat, 4 Sep 2010 12:54:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Pekka Enberg <penberg@kernel.org>
cc: Chris Wilson <chris@chris-wilson.co.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
In-Reply-To: <AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1009041244440.3044@sister.anvils>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org> <89k83a$9hv9li@azsmga001.ch.intel.com> <AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-878568135-1283630086=:3044"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-878568135-1283630086=:3044
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 4 Sep 2010, Pekka Enberg wrote:
> On Sat, =A04 Sep 2010 11:17:14 +0300, Pekka Enberg <penberg@kernel.org> w=
rote:
> >> This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The comm=
it causes
> >> wrong screen resolution on some i915 machines such as MacBook which is=
 a
> >> regression from 2.6.35. The issue has been reported multiple times but=
 no fix
> >> has emerged:
>=20
> On Sat, Sep 4, 2010 at 12:21 PM, Chris Wilson <chris@chris-wilson.co.uk> =
wrote:
> > NAK. You can't simply hide one bug by introducing a much bigger one.
>=20
> Dude, it's a nasty regression from 2.6.35. What exactly are you NAK'ing h=
ere?
>=20
> > As you have an affected machine, find which wait_for_vblank() needs to =
be
> > replaced with a msleep(20|50).
>=20
> The attached patch fixes things here. I'm not a drm developer so I
> don't know if it makes technical sense.

Many thanks to you, Pekka: I also don't know if it makes technical sense,
but it solves the same issue for me, so I can at last use 2.6.36-rc on
this laptop.  I sure hope this or an equivalent makes it into -rc4.

Hugh

From=2053e5840a6abb50f12f9d2b32efa2a472b203d52f Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@kernel.org>
Date: Sat, 4 Sep 2010 19:24:04 +0300
Subject: [PATCH] i915: Fix wrong resolution after boot problem

Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/gpu/drm/i915/intel_tv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_t=
v.c
index d2029ef..7784ff8 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1231,7 +1231,6 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 =09struct drm_encoder *encoder =3D &intel_tv->base.enc;
 =09struct drm_device *dev =3D encoder->dev;
 =09struct drm_i915_private *dev_priv =3D dev->dev_private;
-=09struct intel_crtc *intel_crtc =3D to_intel_crtc(encoder->crtc);
 =09unsigned long irqflags;
 =09u32 tv_ctl, save_tv_ctl;
 =09u32 tv_dac, save_tv_dac;
@@ -1268,11 +1267,11 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 =09=09   DAC_C_0_7_V);
 =09I915_WRITE(TV_CTL, tv_ctl);
 =09I915_WRITE(TV_DAC, tv_dac);
-=09intel_wait_for_vblank(dev, intel_crtc->pipe);
+=09msleep(20);
 =09tv_dac =3D I915_READ(TV_DAC);
 =09I915_WRITE(TV_DAC, save_tv_dac);
 =09I915_WRITE(TV_CTL, save_tv_ctl);
-=09intel_wait_for_vblank(dev, intel_crtc->pipe);
+=09msleep(20);
 =09/*
 =09 *  A B C
 =09 *  0 1 1 Composite
--=20
1.6.3.3
--8323584-878568135-1283630086=:3044--
