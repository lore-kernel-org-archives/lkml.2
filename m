Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162767Ab1FAIXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:23:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162751Ab1FAIXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:23:41 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:48 2011
Message-Id: <20110601081148.047678391@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:07 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [097/165] ALSA: hda - Use LPIB for ATI/AMD chipsets as default
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1188
Lines: 37

From: Takashi Iwai <tiwai@suse.de>

commit 50e3bbf9898840eead86f90a43b3625a2b2f4112 upstream.

ATI and AMD chipsets seem not providing the proper position-buffer
information, and it also doesn't provide FIFO register required by
VIACOMBO fix.  It's better to use LPIB for these.

Reported-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2349,9 +2349,16 @@ static int __devinit check_position_fix(
 	/* Check VIA/ATI HD Audio Controller exist */
 	switch (chip->driver_type) {
 	case AZX_DRIVER_VIA:
-	case AZX_DRIVER_ATI:
 		/* Use link position directly, avoid any transfer problem. */
 		return POS_FIX_VIACOMBO;
+	case AZX_DRIVER_ATI:
+		/* ATI chipsets don't work well with position-buffer */
+		return POS_FIX_LPIB;
+	case AZX_DRIVER_GENERIC:
+		/* AMD chipsets also don't work with position-buffer */
+		if (chip->pci->vendor == PCI_VENDOR_ID_AMD)
+			return POS_FIX_LPIB;
+		break;
 	}
 
 	return POS_FIX_AUTO;


