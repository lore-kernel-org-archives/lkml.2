Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2HTEJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:09:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2HTD74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:59:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [ 04/46] drm/mgag200: fix G200ER pll picking algorithm
Date: Sun, 19 Aug 2012 20:58:40 -0700
Message-Id: <20120820035832.862360251@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@gmail.com>

commit 9830605d4c070b16ec5c24a75503877cc7698409 upstream.

The original code was misported from the X driver,

a) an int went to unsigned int, breaking the downward counting testm code
b) the port did the vco/computed clock bits completely wrong.

This fixes an infinite loop on modprobe on some Dell servers with the G200ER
chipset variant.

Found in internal testing.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -468,10 +468,11 @@ static int mga_g200er_set_plls(struct mg
 {
 	unsigned int vcomax, vcomin, pllreffreq;
 	unsigned int delta, tmpdelta;
-	unsigned int testr, testn, testm, testo;
+	int testr, testn, testm, testo;
 	unsigned int p, m, n;
-	unsigned int computed;
+	unsigned int computed, vco;
 	int tmp;
+	const unsigned int m_div_val[] = { 1, 2, 4, 8 };
 
 	m = n = p = 0;
 	vcomax = 1488000;
@@ -490,12 +491,13 @@ static int mga_g200er_set_plls(struct mg
 				if (delta == 0)
 					break;
 				for (testo = 5; testo < 33; testo++) {
-					computed = pllreffreq * (testn + 1) /
+					vco = pllreffreq * (testn + 1) /
 						(testr + 1);
-					if (computed < vcomin)
+					if (vco < vcomin)
 						continue;
-					if (computed > vcomax)
+					if (vco > vcomax)
 						continue;
+					computed = vco / (m_div_val[testm] * (testo + 1));
 					if (computed > clock)
 						tmpdelta = computed - clock;
 					else


