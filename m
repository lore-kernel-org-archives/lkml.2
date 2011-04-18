Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1DRQkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:40:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:39560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab1DRQka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:40:30 -0400
Date: Mon, 18 Apr 2011 16:40:21 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-c34151a742d84ae65db2088ea30495063f697fbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, stable@kernel.org, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, stable@kernel.org, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <1303134346-5805-4-git-send-email-joerg.roedel@amd.com>
References: <1303134346-5805-4-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, gart: Set DISTLBWALKPRB bit always
Git-Commit-ID: c34151a742d84ae65db2088ea30495063f697fbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Apr 2011 16:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c34151a742d84ae65db2088ea30495063f697fbe
Gitweb:     http://git.kernel.org/tip/c34151a742d84ae65db2088ea30495063f697fbe
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Mon, 18 Apr 2011 15:45:45 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 18 Apr 2011 09:26:48 -0700

x86, gart: Set DISTLBWALKPRB bit always

The DISTLBWALKPRB bit must be set for the GART because the
gatt table is mapped UC. But the current code does not set
the bit at boot when the BIOS setup the aperture correctly.
Fix that by setting this bit when enabling the GART instead
of the other places.

Cc: <stable@kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1303134346-5805-4-git-send-email-joerg.roedel@amd.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/gart.h   |    4 ++--
 arch/x86/kernel/aperture_64.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 88c1ebe..156cd5d 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -66,7 +66,7 @@ static inline void gart_set_size_and_enable(struct pci_dev *dev, u32 order)
 	 * Don't enable translation but enable GART IO and CPU accesses.
 	 * Also, set DISTLBWALKPRB since GART tables memory is UC.
 	 */
-	ctl = DISTLBWALKPRB | order << 1;
+	ctl = order << 1;
 
 	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
@@ -83,7 +83,7 @@ static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 
 	/* Enable GART translation for this hammer. */
 	pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
-	ctl |= GARTEN;
+	ctl |= GARTEN | DISTLBWALKPRB;
 	ctl &= ~(DISGARTCPU | DISGARTIO);
 	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 86d1ad4..73fb469 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -499,7 +499,7 @@ out:
 		 * Don't enable translation yet but enable GART IO and CPU
 		 * accesses and set DISTLBWALKPRB since GART table memory is UC.
 		 */
-		u32 ctl = DISTLBWALKPRB | aper_order << 1;
+		u32 ctl = aper_order << 1;
 
 		bus = amd_nb_bus_dev_ranges[i].bus;
 		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
