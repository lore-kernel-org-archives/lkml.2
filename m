Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab2GaEvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48875 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725Ab2GaEvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:09 -0400
Message-Id: <20120731044315.770748839@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nishanth Menon <nm@ti.com>,
        Steve Sakoman <steve@sakoman.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>
Subject: [ 28/73] ARM: OMAP2+: OPP: Fix to ensure check of right oppdef after bad one
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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

Cc: Steve Sakoman <steve@sakoman.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-omap2/opp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/opp.c b/arch/arm/mach-omap2/opp.c
index de6d464..d8f6dbf 100644
--- a/arch/arm/mach-omap2/opp.c
+++ b/arch/arm/mach-omap2/opp.c
@@ -53,7 +53,7 @@ int __init omap_init_opp_table(struct omap_opp_def *opp_def,
 	omap_table_init = 1;
 
 	/* Lets now register with OPP library */
-	for (i = 0; i < opp_def_size; i++) {
+	for (i = 0; i < opp_def_size; i++, opp_def++) {
 		struct omap_hwmod *oh;
 		struct device *dev;
 
@@ -86,7 +86,6 @@ int __init omap_init_opp_table(struct omap_opp_def *opp_def,
 					__func__, opp_def->freq,
 					opp_def->hwmod_name, i, r);
 		}
-		opp_def++;
 	}
 
 	return 0;


