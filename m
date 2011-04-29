Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab1D2S6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:16 -0400
Received: from kroah.org ([198.145.64.141]:50202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab1D2S6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.555863907@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>,
        Joerg Roedel <joerg.roedel@amd.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [10/55] x86, gart: Set DISTLBWALKPRB bit always
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit c34151a742d84ae65db2088ea30495063f697fbe upstream.

The DISTLBWALKPRB bit must be set for the GART because the
gatt table is mapped UC. But the current code does not set
the bit at boot when the BIOS setup the aperture correctly.
Fix that by setting this bit when enabling the GART instead
of the other places.

Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1303134346-5805-4-git-send-email-joerg.roedel@amd.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/gart.h   |    4 ++--
 arch/x86/kernel/aperture_64.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -66,7 +66,7 @@ static inline void gart_set_size_and_ena
 	 * Don't enable translation but enable GART IO and CPU accesses.
 	 * Also, set DISTLBWALKPRB since GART tables memory is UC.
 	 */
-	ctl = DISTLBWALKPRB | order << 1;
+	ctl = order << 1;
 
 	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
@@ -83,7 +83,7 @@ static inline void enable_gart_translati
 
         /* Enable GART translation for this hammer. */
         pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
-        ctl |= GARTEN;
+        ctl |= GARTEN | DISTLBWALKPRB;
         ctl &= ~(DISGARTCPU | DISGARTIO);
         pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -500,7 +500,7 @@ out:
 		 * Don't enable translation yet but enable GART IO and CPU
 		 * accesses and set DISTLBWALKPRB since GART table memory is UC.
 		 */
-		u32 ctl = DISTLBWALKPRB | aper_order << 1;
+		u32 ctl = aper_order << 1;
 
 		bus = amd_nb_bus_dev_ranges[i].bus;
 		dev_base = amd_nb_bus_dev_ranges[i].dev_base;


