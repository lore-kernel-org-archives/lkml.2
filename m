Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1BCPQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:16:17 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56568 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1BCPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:16:15 -0500
Date: Thu, 3 Feb 2011 16:17:21 +0100
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10
 CPUs
Message-ID: <20110203151721.GD24755@aftab>
References: <20110129211531.GA1874@gentoo.trippels.de>
 <20110201185114.GD8418@aftab>
 <20110201192752.GA1589@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201192752.GA1589@gentoo.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 02:27:52PM -0500, Markus Trippelsdorf wrote:
> On 2011.02.01 at 19:51 +0100, Borislav Petkov wrote:
> > On Sat, Jan 29, 2011 at 04:15:31PM -0500, Markus Trippelsdorf wrote:
> > > The EDAC_AMD64 module displays only half the actual memory size, when
> > > RAM is running in ganged mode on F10 CPUs. Fix this by moving the the
> > > conversion factor check out of the if block, where it is never reached.
> > >
> > > With this patch:
> > >
> > > Unganged:
> > >  amd64: DRAM ECC enabled.
> > >  EDAC amd64: F10h detected (node 0).
> > >  EDAC amd64: using x4 syndromes.
> > >  EDAC MC: DCT0 chip selects:
> > >  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
> > >  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
> > >  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
> > >  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
> > >  kernel: EDAC MC: DCT1 chip selects:
> > >  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
> > >  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
> > >  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
> > >  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
> > >  kernel: EDAC amd64: MCT channel count: 2

Ok, you've found a bug but it has to be fixed differently. See, the
above reporting scheme actually doesn't change based on whether we're
ganged or not. In your case, for example, you have 4 2GB dual-ranked
DIMMs and they should always be shown as above, DCT0 has 2 DIMMs, with
chip selects 0 and 1 (aka ranks) being DIMM0 and chip selects 2 and 3
being DIMM2. You have the same config on the other channel, i.e. DCT1.

Now, when we're running ganged, you still have the same physical
configuration with the only difference that we read from the two DCTs in
parallel. Thus, we want to print the above structure independent from
the ganged setting.

Here's a fix, it should correct the reporting on your machine.

Thanks.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 3 Feb 2011 15:59:57 +0100
Subject: [PATCH] amd64_edac: Fix DIMMs per DCTs output

amd64_debug_display_dimm_sizes() reports the distribution of the DIMMs
on each DRAM controller and its chip select sizes. Thus, the last don't
have anything to do with whether we're running in ganged DCT mode or not
- their sizes don't change all of a sudden. Fix that by removing the
ganged-check.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4a5ecc5..ab2cd8a 100644
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
