Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1DTS2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:28:48 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:56118 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1DTS2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:28:47 -0400
Date: Wed, 20 Apr 2011 20:28:45 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: "rwhitton@iee.org" <rwhitton@iee.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] edac: Remove debugging output in scrub rate handling
Message-ID: <20110420182845.GA1614@x4.trippels.de>
References: <16117.1303310442@jupiter.eclipse.co.uk>
 <4DAEF98D.2090802@ladisch.de>
 <20110420153529.GA2312@gere.osrc.amd.com>
 <20110420154658.GD1624@x4.trippels.de>
 <20110420155853.GB2312@gere.osrc.amd.com>
 <20110420164506.GE1624@x4.trippels.de>
 <20110420165533.GA1624@x4.trippels.de>
 <20110420173627.GE2734@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420173627.GE2734@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.20 at 19:36 +0200, Borislav Petkov wrote:
> On Wed, Apr 20, 2011 at 12:55:33PM -0400, Markus Trippelsdorf wrote:
> > > > This is KERN_DEBUG since .38 (commit 24f9a7fe3f19f3fd310f556364d01a22911724b3)
> > > > and it shouldn't appear on the console if you don't change your default log level.
> > > 
> > > Yes. Sorry, but I was referring to dmesg and not the console. 
> > > What I mean is that maybe debugf1 or debugf2 is more appropriate than
> > > amd64_debug?
> > 
> > In other words:
> 
> Ok, that whole debugging output there is partly historical remains and
> we don't really need them if we're smart about it. But you'll have to
> change your patch and make a proper commit message :).

This patch removes superfluous debugging output in the sysfs scrub rate
handler. It also consolidates the error handling in
mci_sdram_scrub_rate_store.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 drivers/edac/amd64_edac.c    |    2 --
 drivers/edac/edac_mc_sysfs.c |   11 +++++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 31e71c4f..4b4071e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -211,8 +211,6 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 
 	scrubval = scrubval & 0x001F;
 
-	amd64_debug("pci-read, sdram scrub control value: %d\n", scrubval);
-
 	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
 		if (scrubrates[i].scrubval == scrubval) {
 			retval = scrubrates[i].bandwidth;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 26343fd..6ffe438 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -458,13 +458,13 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 		return -EINVAL;
 
 	new_bw = mci->set_sdram_scrub_rate(mci, bandwidth);
-	if (new_bw >= 0) {
-		edac_printk(KERN_DEBUG, EDAC_MC, "Scrub rate set to %d\n", new_bw);
-		return count;
+	if (new_bw < 0) {
+		edac_printk(KERN_WARNING, EDAC_MC,
+			"Error setting scrub rate to: %lu\n", bandwidth);
+		return -EINVAL;
 	}
 
-	edac_printk(KERN_DEBUG, EDAC_MC, "Error setting scrub rate to: %lu\n", bandwidth);
-	return -EINVAL;
+	return count;
 }
 
 /*
@@ -483,7 +483,6 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 		return bandwidth;
 	}
 
-	edac_printk(KERN_DEBUG, EDAC_MC, "Read scrub rate: %d\n", bandwidth);
 	return sprintf(data, "%d\n", bandwidth);
 }
 
-- 
Markus
