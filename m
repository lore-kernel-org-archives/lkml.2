Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0D0SCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:02:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756493Ab0D0R7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:59:37 -0400
Date: Tue, 27 Apr 2010 10:57:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, David.Woodhouse@intel.com,
       dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
       gregkh@suse.de, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
 entries in i915
Message-Id: <20100427105750.1cfe59b9.akpm@linux-foundation.org>
In-Reply-To: <ca2dc2821003250955x211ef2f8la16ded9759ccb6ab@mail.gmail.com>
References: <1268258994.2183.14.camel@carter>
	<ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	<20100319132723.118cc16a.akpm@linux-foundation.org>
	<ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	<20100321135836.GA11661@zhen-devel.sh.intel.com>
	<ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
	<20100322205704.ac4cd9ae.akpm@linux-foundation.org>
	<alpine.DEB.2.01.1003222111070.5493@bogon.housecafe.de>
	<ca2dc2821003230440w3d96612aja0d4e083d3cc8c02@mail.gmail.com>
	<20100324111436.fe5d2906.akpm@linux-foundation.org>
	<ca2dc2821003250955x211ef2f8la16ded9759ccb6ab@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 17:55:56 +0100
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Wed, Mar 24, 2010 at 7:14 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 23 Mar 2010 12:40:05 +0100
> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> >> On Tue, Mar 23, 2010 at 5:14 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> >> > On Mon, 22 Mar 2010 at 20:57, Andrew Morton wrote:
> >> >> On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >> >> > I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.
> >> >
> >> > I believe this[0] is fc61901373987ad61851ed001fe971f3ee8d96a3 upstream:
> >>
> >> Indeed. Also in
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=fc61901373987ad61851ed001fe971f3ee8d96a3
> >
> > Does reverting that patch from the current code fix the crash?
> 
> Yes. In addition, applying the patch I provided also fixes it in current code.
> 

Well great.  A whole pile of new stuff has turned up in linux-next's
drivers/char/agp/intel-agp.c.  As far as I can tell none of it
address the regression which you've reported and your patch no longer
applies at all so I have to drop the patch.

Perhaps "agp/intel: put back check that we have a driver for the
bridge" fixes it, but it isn't tagged for -stable backporting.

Rafael, Maciej: if you're not already tracking this as a 2.6.32->2.6.33
regression then please do so.

David, can you please help us to get this sorted out in both 2.6.33.x
and in mainline?



From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Commit fc61901373987ad61851ed001fe971f3ee8d96a3 ("agp/intel-agp: Clear
entire GTT on startup") (included since 2.6.32.4) crashes (locks up) the
82915G/GV/910GL Controller when intel-agp.c tries to access nonexistent
GTT entries at:

-		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+		for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {

Rationale: I915 (gma900) has 128 MB of video memory (maximum), as per
intel.com (
http://www.intel.com/support/graphics/intel915g/sb/CS-012579.htm ) and
lscpi:

00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics Controller (rev 04) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation Device 4147
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at ff480000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d8000000 (32-bit, prefetchable) [size=128M]
        Region 3: Memory at ff440000 (32-bit, non-prefetchable) [size=256K]
        Capabilities: <access denied>

AFAIK, that implies that its gtt_total_size (in pages) should be 32K (as
num_entries showed before the commit) instead of 64K.

Note: The IS_I915 macro includes 945; however, only GMA900 (I915) had 128
MB as the maximum AFAIK.  Therefore, I divided the IS_I915 macro.  I do
not know about the "E7221" (please check).

How to reproduce: Access kernel.org in iceweasel (Debian Lenny) and the X
server will crash.  Sometimes, the kernel freezes.

The fix should be applied to stable series, as well as 2.6.33 and
2.6.34-rc1.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Eric Anholt <eric@anholt.net>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915
+++ a/drivers/char/agp/intel-agp.c
@@ -74,11 +74,11 @@ EXPORT_SYMBOL(intel_agp_enabled);
 #define PCI_DEVICE_ID_INTEL_SANDYBRIDGE_M_HB  0x0104
 #define PCI_DEVICE_ID_INTEL_SANDYBRIDGE_M_IG  0x0106
 
-/* cover 915 and 945 variants */
 #define IS_I915 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
+		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB)
+
+#define IS_I945 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB)
 
@@ -824,14 +824,14 @@ static void intel_i830_init_gtt_entries(
 			break;
 		case I915_GMCH_GMS_STOLEN_48M:
 			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
+			if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries = MB(48) - KB(size);
 			else
 				gtt_entries = 0;
 			break;
 		case I915_GMCH_GMS_STOLEN_64M:
 			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
+			if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries = MB(64) - KB(size);
 			else
 				gtt_entries = 0;
@@ -1400,6 +1400,8 @@ static int intel_i915_create_gatt_table(
 
 	if (IS_G33)
 	    gtt_map_size = 1024 * 1024; /* 1M on G33 */
+	else if (IS_I915)
+	    gtt_map_size = 128 * 1024; /* 128K on I915 */
 	intel_private.gtt = ioremap(temp2, gtt_map_size);
 	if (!intel_private.gtt)
 		return -ENOMEM;
diff -puN /dev/null /dev/null
_

