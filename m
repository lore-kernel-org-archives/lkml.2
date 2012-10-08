Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2JHVBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:01:46 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4743 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab2JHVBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:01:44 -0400
Message-ID: <1349730102.1397.24.camel@x61.thuisdomein>
Subject: [PATCH] drm/nv40/pm: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 23:01:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2012 21:01:43.0440 (UTC) FILETIME=[1ED37900:01CDA598]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building nv40_pm.o triggers these GCC warnings:
    drivers/gpu/drm/nouveau/nv40_pm.c: In function 'nv40_pm_clocks_pre':
    drivers/gpu/drm/nouveau/nv40_pm.c:164:41: warning: 'log2P' may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/gpu/drm/nouveau/nv40_pm.c:165:38: warning: 'M2' may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/gpu/drm/nouveau/nv40_pm.c:165:45: warning: 'M1' may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/gpu/drm/nouveau/nv40_pm.c:165:25: warning: 'N2' may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/gpu/drm/nouveau/nv40_pm.c:165:51: warning: 'N1' may be used uninitialized in this function [-Wmaybe-uninitialized]

But these variables seem to be initialized when used there. If the
preceding call of nv40_calc_pll() fails it will return a negative value
and this code will never be run. And if that call succeeds it will
return zero and all those five variables ought to be initialized when
used there.

Anyhow, it turns out that these warnings can be silenced by giving GCC
slightly more detailed information a little earlier. See,
get_pll_limits() returns an error-code integer (ie, negative on failure,
zero on success). And a trivial tweak to nv40_calc_pll() that takes this
into account makes these errors go away.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed these warnings while building recent releases (eg,
v3.6-rc7, v3.6, and v3.6.1) on current Fedora 17, using Fedora's default
config. But I found identical warnings in a build log for release
v3.4-rc1. I didn't bother checking earlier releases.

1) Compile tested only (I do not have the hardware involved at hand).

2) This is not the only place where get_pll_limits()'s return value is
checked. But this is apparently the only place where GCC needs to know
that any non-zero return will be negative.

 drivers/gpu/drm/nouveau/nv40_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c b/drivers/gpu/drm/nouveau/nv40_pm.c
index e66273a..3df30cb 100644
--- a/drivers/gpu/drm/nouveau/nv40_pm.c
+++ b/drivers/gpu/drm/nouveau/nv40_pm.c
@@ -114,7 +114,7 @@ nv40_calc_pll(struct drm_device *dev, u32 reg, struct pll_lims *pll,
 	int ret;
 
 	ret = get_pll_limits(dev, reg, pll);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	if (clk < pll->vco1.maxfreq)
-- 
1.7.11.4

