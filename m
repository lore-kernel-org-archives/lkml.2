Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0LBRGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:06:30 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55545 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0LBRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:06:29 -0500
Date: Thu, 2 Dec 2010 18:06:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202170610.GE27263@aftab>
References: <1291201307.3029.21.camel@Tobias-Karnat>
 <20101201123921.GA15530@a1.tnic>
 <1291209888.12511.11.camel@Tobias-Karnat>
 <20101201143329.GB18074@a1.tnic>
 <1291225614.8646.4.camel@Tobias-Karnat>
 <20101201193508.GA4916@liondog.tnic>
 <1291280613.10626.22.camel@Tobias-Karnat>
 <20101202152106.GA29301@a1.tnic>
 <1291306872.3898.7.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291306872.3898.7.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 11:21:12AM -0500, Tobias Karnat wrote:
> Am Donnerstag, den 02.12.2010, 16:21 +0100 schrieb Borislav Petkov:
> > Well, thanks for the photos. I don't have an idea what might cause this
> > workqueue corruption I'm seeing, all reg/unreg paths look ok. The only
> > change that came in between .35 and .36.1 I can think of being relevant
> > is 00740c58541b6087d78418cebca1fcb86dc6077d. You could try backing that
> > one out to see whether it fixes the issue.
> 
> Yes, reverting this fixed the issue!
> 
> But why?

Dang, I know why. This whole ->op_state fumbling is pretty fragile and
needs de-fragilizing :o).

Please try out the one below after re-reverting
00740c58541b6087d78418cebca1fcb86dc6077d (i.e., ontop of .36.1).

Thanks.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 2 Dec 2010 17:48:35 +0100
Subject: [PATCH] EDAC: Fix workqueue-related crashes

00740c58541b6087d78418cebca1fcb86dc6077d changed edac_core to
un-/register a workqueue item only if a lowlevel driver supplies a
polling routine. Normally, when we remove a polling low-level driver,
we go and teardown the workqueue and cancel all the queued work.
However, the workqueue unreg happens based on the ->op_state setting,
and edac_mc_del_mc() sets this to OP_OFFLINE _before_ we cancel the work
item, leading to NULL ptr oops on the workqueue list.

Fix it by putting the unreg stuff in proper order.

Cc: <stable@kernel.org> #36.x
Reported-by: Tobias Karnat <tobias.karnat@googlemail.com>
LKML-Reference: <1291201307.3029.21.camel@Tobias-Karnat>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mc.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 6b21e25..6d2e34d 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -578,14 +578,16 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 		return NULL;
 	}
 
-	/* marking MCI offline */
-	mci->op_state = OP_OFFLINE;
-
 	del_mc_from_global_list(mci);
 	mutex_unlock(&mem_ctls_mutex);
 
-	/* flush workq processes and remove sysfs */
+	/* flush workq processes */
 	edac_mc_workq_teardown(mci);
+
+	/* marking MCI offline */
+	mci->op_state = OP_OFFLINE;
+
+	/* remove from sysfs */
 	edac_remove_sysfs_mci_device(mci);
 
 	edac_printk(KERN_INFO, EDAC_MC,
-- 
1.7.3.1.50.g1e633


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
