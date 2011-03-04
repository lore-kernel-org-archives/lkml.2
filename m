Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab1CDU3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:29:12 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:48908 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760139Ab1CDU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:29:10 -0500
Date: Fri, 4 Mar 2011 12:29:05 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] matroxfb: remove incorrect Matrox G200eV support
Message-ID: <20110304202905.GB27190@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110301175026.GA18770@us.ibm.com> <AANLkTikwSXN8VgDaoUqfHcxoTNxW9uA4D2fUtRLuLbHo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikwSXN8VgDaoUqfHcxoTNxW9uA4D2fUtRLuLbHo@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 10:29:23AM -0800, Linus Torvalds wrote:
> On Tue, Mar 1, 2011 at 9:50 AM, Gary Hade <garyhade@us.ibm.com> wrote:
> >
> > Remove incorrect Matrox G200eV support that was previously added
> > by commit e3a1938805d2e81b27d3d348788644f3bad004f2
> 
> That commit goes back to 2.6.28 (and is dated Oct 2008).
> 
> That means that you really need to describe the problem more:
> 
> > One serious issue with the G200eV support that I have reproduced
> > on a Matrox G200eV equipped IBM x3650 M2 is the lack of text (login
> > banner, login prompt, etc) on the console when X not running and
> > lack of text on all of the virtual consoles after X is started.

On an IBM x3650m2, loading the matroxfb-base fb driver for the builtin Matrox
G200eV VGA chip results in no usable analog signal coming out of the VGA port.
I noticed the "outputs=" parameter to that driver, and forced all outputs on;
when I did that, the display showed a crazed jumble of static and powered off.
The display would not power on again until I removed and reinserted the power
plug.  Other displays reacted less violently but not functionally, either.

> .. but without the commit, you get no fb at all, right? So even with
> the commit, at worst you'd just be able to not use the matroxfb
> driver, right?

Yep.  We contacted Matrox to see if they would help us sort out the output
misprogramming issue, and they declined.  Evidently they're no longer
interested in matroxfb support.

> What I'm trying to say is that I suspect there are G200eV users that
> likely prefer having the support in - even though it's not perfect.
> And the fact that the commit has been there for 2.5 years without
> comments makes me very loath to just revert it.

This is all quite strange -- 2.5 years ago when I wrote the patch it seemed to
work ok.  On newer revisions of the x3650M2 it seems broken.  The original
machine I wrote it for was cut up ages ago.

I suppose we could simply blacklist any G200eV with a subsystem vendor ID of
0x1014 (IBM) until we figure out how to correct the driver.  Our customers will
be deprived, but as it seems to be broken across most of our product lines I
doubt any of them are making serious use of it anyway. :)

Something like this?
--
matroxfb: Blacklist IBM G200eV chips

On an IBM x3650m2, loading the matroxfb-base fb driver for the builtin Matrox
G200eV VGA chip results in no usable analog signal coming out of the VGA port.
I noticed the "outputs=" parameter to that driver, and forced all outputs on;
when I did that, the display showed a crazed jumble of static and powered off.
The display would not power on again until I removed and reinserted the power
plug.  Other displays reacted less violently but not functionally, either.

For now, don't talk to the G200eV if it has an IBM subvendor ID.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/video/matrox/matroxfb_base.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index a082deb..a86e401 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -1385,6 +1385,17 @@ static struct video_board vbG400		= {0x2000000, 0x1000000, FB_ACCEL_MATROX_MGAG4
 #define DEVF_G450	(DEVF_GCORE | DEVF_ANY_VXRES | DEVF_SUPPORT32MB | DEVF_TEXT16B | DEVF_CRTC2 | DEVF_G450DAC | DEVF_SRCORG | DEVF_DUALHEAD)
 #define DEVF_G550	(DEVF_G450)
 
+static struct blacklisted_board {
+	unsigned short vendor, device, svid, sid;
+		} black_list[] = {
+#ifdef CONFIG_FB_MATROX_G
+	/* Onboard G200eV in IBM servers cause display failures */
+	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,
+	 PCI_VENDOR_ID_IBM, 0},
+#endif
+	{0, 0, 0, 0},
+};
+
 static struct board {
 	unsigned short vendor, device, rev, svid, sid;
 	unsigned int flags;
@@ -2012,10 +2023,11 @@ static void matroxfb_unregister_device(struct matrox_fb_info* minfo) {
 
 static int matroxfb_probe(struct pci_dev* pdev, const struct pci_device_id* dummy) {
 	struct board* b;
+	struct blacklisted_board *d;
 	u_int16_t svid;
 	u_int16_t sid;
 	struct matrox_fb_info* minfo;
-	int err;
+	int err, ignore;
 	u_int32_t cmd;
 	DBG(__func__)
 
@@ -2025,6 +2037,17 @@ static int matroxfb_probe(struct pci_dev* pdev, const struct pci_device_id* dumm
 		if ((b->vendor != pdev->vendor) || (b->device != pdev->device) || (b->rev < pdev->revision)) continue;
 		if (b->svid)
 			if ((b->svid != svid) || (b->sid != sid)) continue;
+		ignore = 0;
+		for (d = black_list; d->vendor; d++)
+			if (d->vendor == pdev->vendor &&
+			    d->device == pdev->device &&
+			    d->svid == svid &&
+			    (!d->sid || d->sid == sid)) {
+				ignore = 1;
+				break;
+			}
+		if (ignore)
+			continue;
 		break;
 	}
 	/* not match... */
