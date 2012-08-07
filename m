Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2HGW2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:28:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab2HGW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steve Sakoman <steve@sakoman.com>, Tony Lindgren <tony@atomide.com>,
        Nishanth Menon <nm@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: [ 019/122] ARM: OMAP2+: OPP: Fix to ensure check of right oppdef after bad one
Date: Tue,  7 Aug 2012 15:25:07 -0700
Message-Id: <20120807221949.963296638@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit b110547e586eb5825bc1d04aa9147bff83b57672 upstream.

Commit 9fa2df6b90786301b175e264f5fa9846aba81a65
(ARM: OMAP2+: OPP: allow OPP enumeration to continue if device is not present)
makes the logic:
for (i = 0; i < opp_def_size; i++) {
	<snip>
	if (!oh || !oh->od) {
		<snip>
		continue;
	}
<snip>
opp_def++;
}

In short, the moment we hit a "Bad OPP", we end up looping the list
comparing against the bad opp definition pointer for the rest of the
iteration count. Instead, increment opp_def in the for loop itself
and allow continue to be used in code without much thought so that
we check the next set of OPP definition pointers :)

Signed-off-by: Nishanth Menon <nm@ti.com>
Cc: Steve Sakoman <steve@sakoman.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/opp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/opp.c
+++ b/arch/arm/mach-omap2/opp.c
@@ -53,7 +53,7 @@ int __init omap_init_opp_table(struct om
 	omap_table_init = 1;
 
 	/* Lets now register with OPP library */
-	for (i = 0; i < opp_def_size; i++) {
+	for (i = 0; i < opp_def_size; i++, opp_def++) {
 		struct omap_hwmod *oh;
 		struct device *dev;
 
@@ -86,7 +86,6 @@ int __init omap_init_opp_table(struct om
 					__func__, opp_def->freq,
 					opp_def->hwmod_name, i, r);
 		}
-		opp_def++;
 	}
 
 	return 0;


