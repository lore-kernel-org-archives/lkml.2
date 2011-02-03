Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1BCRIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:08:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43291 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1BCRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:08:22 -0500
Date: Thu, 3 Feb 2011 18:09:32 +0100
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10
 CPUs
Message-ID: <20110203170932.GB26261@aftab>
References: <20110129211531.GA1874@gentoo.trippels.de>
 <20110201185114.GD8418@aftab>
 <20110201192752.GA1589@gentoo.trippels.de>
 <20110203151721.GD24755@aftab>
 <20110203155951.GA1594@gentoo.trippels.de>
 <20110203163600.GA26261@aftab>
 <20110203164203.GB1594@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203164203.GB1594@gentoo.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:42:03AM -0500, Markus Trippelsdorf wrote:
> > Of course it doesn't, doh!, we need the DRAM chip selects from the
> > second DCT too. Can you please run this little script as root so that I
> > can verify that BIOS is actually programming sensible values in those in
> > ganged mode? (Yeah, leave your DCT setting to ganged in BIOS).
> > 
> > --
> > #!/bin/bash
> > 
> > i=0x140
> > 
> > while (( $i <= 0x15c )); do
> >         reg=$(printf "0x%x" $i)
> >         setpci -s 18.2 $reg.l
> >         i=$(($i+4))
> > done
> 
> 00000000
> 00000000
> 00000000
> 00000000
> 00000000
> 00000000
> 00000000
> 00000000

Ok, can you please try the following one,

Thanks.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 3 Feb 2011 15:59:57 +0100
Subject: [PATCH] amd64_edac: Fix DIMMs per DCTs output

amd64_debug_display_dimm_sizes() reports the distribution of the DIMMs
on each DRAM controller and its chip select sizes. Thus, the last don't
have anything to do with whether we're running in ganged DCT mode or not
- their sizes don't change all of a sudden. Fix that by removing the
ganged-check and dump DCT0's config for DCT1 when in ganged mode since
they're identical.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4a5ecc5..23e0355 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -826,8 +826,6 @@ static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 /* Display and decode various NB registers for debug purposes. */
 static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 {
-	int ganged;
-
 	debugf1("F3xE8 (NB Cap): 0x%08x\n", pvt->nbcap);
 
 	debugf1("  NB two channel DRAM capable: %s\n",
@@ -851,28 +849,19 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 	debugf1("  DramHoleValid: %s\n",
 		(pvt->dhar & DHAR_VALID) ? "yes" : "no");
 
+	amd64_debug_display_dimm_sizes(0, pvt);
+
 	/* everything below this point is Fam10h and above */
-	if (boot_cpu_data.x86 == 0xf) {
-		amd64_debug_display_dimm_sizes(0, pvt);
+	if (boot_cpu_data.x86 == 0xf)
 		return;
-	}
+
+	amd64_debug_display_dimm_sizes(1, pvt);
 
 	amd64_info("using %s syndromes.\n", ((pvt->syn_type == 8) ? "x8" : "x4"));
 
 	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
 		amd64_dump_dramcfg_low(pvt->dclr1, 1);
-
-	/*
-	 * Determine if ganged and then dump memory sizes for first controller,
-	 * and if NOT ganged dump info for 2nd controller.
-	 */
-	ganged = dct_ganging_enabled(pvt);
-
-	amd64_debug_display_dimm_sizes(0, pvt);
-
-	if (!ganged)
-		amd64_debug_display_dimm_sizes(1, pvt);
 }
 
 /* Read in both of DBAM registers */
@@ -1644,11 +1633,10 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 		       WARN_ON(ctrl != 0);
 	}
 
-	debugf1("F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n",
-		ctrl, ctrl ? pvt->dbam1 : pvt->dbam0);
+	dbam = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dbam1 : pvt->dbam0;
+	dcsb = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dcsb1 : pvt->dcsb0;
 
-	dbam = ctrl ? pvt->dbam1 : pvt->dbam0;
-	dcsb = ctrl ? pvt->dcsb1 : pvt->dcsb0;
+	debugf1("F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n", ctrl, dbam);
 
 	edac_printk(KERN_DEBUG, EDAC_MC, "DCT%d chip selects:\n", ctrl);
 
-- 
1.7.4.rc2


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
