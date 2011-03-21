Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1CUXPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:48 -0400
Received: from kroah.org ([198.145.64.141]:49338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab1CUXP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:12 2011
Message-Id: <20110321230712.047034457@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [28/87] libata: fix hotplug for drivers which dont implement LPM
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit eb0e85e36b971ec31610eda7e3ff5c11c1c44785 upstream.

ata_eh_analyze_serror() suppresses hotplug notifications if LPM is
being used because LPM generates spurious hotplug events.  It compared
whether link->lpm_policy was different from ATA_LPM_MAX_POWER to
determine whether LPM is enabled; however, this is incorrect as for
drivers which don't implement LPM, lpm_policy is always
ATA_LPM_UNKNOWN.  This disabled hotplug detection for all drivers
which don't implement LPM.

Fix it by comparing whether lpm_policy is greater than
ATA_LPM_MAX_POWER.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1618,7 +1618,7 @@ static void ata_eh_analyze_serror(struct
 	 * host links.  For disabled PMP links, only N bit is
 	 * considered as X bit is left at 1 for link plugging.
 	 */
-	if (link->lpm_policy != ATA_LPM_MAX_POWER)
+	if (link->lpm_policy > ATA_LPM_MAX_POWER)
 		hotplug_mask = 0;	/* hotplug doesn't work w/ LPM */
 	else if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
 		hotplug_mask = SERR_PHYRDY_CHG | SERR_DEV_XCHG;


