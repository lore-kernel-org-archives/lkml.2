Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1HEOZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:25:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab1HEOZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:25:06 -0400
Message-ID: <4E3BFD3D.9070207@redhat.com>
Date: Fri, 05 Aug 2011 11:25:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Nils Carlson <nils.carlson@ericsson.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Subject: Re: [PATCH] i7core_edac: Add scrubbing support v2
References: <1312531750-14933-1-git-send-email-nils.carlson@ericsson.com>
In-Reply-To: <1312531750-14933-1-git-send-email-nils.carlson@ericsson.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-08-2011 05:09, Nils Carlson escreveu:
> From: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
> 
> Changes since v1:
> Get the DCLK value from DMI, use the datasheet 800Mhz as
> a default if a good value can't be found.
> Make sure computations can't overflow.
> 
> Add scrubbing support for i7core Xeon's.

I've already applied your version 1 patch on my tree:
	http://git.kernel.org/?p=linux/kernel/git/mchehab/edac.git;a=summary

Could you please rebase your patch over the top of my tree?

It had a trouble on it, as it assumes that all Nehalem types of processor are capable of
doing memory scrubbing. However, according with Intel public datasheets, only Xeon55xx,
Xeon 56xx and i7-900 support the Scrubber registers. So, I had to apply the enclosed
patch to the series.

PS.: kernel.org mirrors are a taking some time to sync the trees those days.
So, maybe you're not able to see the last changes on my tree yet.

-

From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 4 Aug 2011 21:35:27 -0300
[PATCH] i7core_edac: Don't enable memory scrubbing for Xeon 35xx

Xeon 35xx doesn't mention memory scrub. It seems that only Xeon 55xx
and above supports it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 0c02486..aeb01f4 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -263,7 +263,7 @@ struct i7core_pvt {
 	unsigned long	rdimm_ce_count[NUM_CHANS][MAX_DIMMS];
 	int		rdimm_last_ce_count[NUM_CHANS][MAX_DIMMS];
 
-	unsigned int	is_registered;
+	bool		is_registered, enable_scrub;
 
 	/* mcelog glue */
 	struct edac_mce		edac_mce;
@@ -1487,8 +1487,10 @@ static int mci_bind_devs(struct mem_ctl_info *mci,
 	struct i7core_pvt *pvt = mci->pvt_info;
 	struct pci_dev *pdev;
 	int i, func, slot;
+	char *family;
 
-	pvt->is_registered = 0;
+	pvt->is_registered = false;
+	pvt->enable_scrub  = false;
 	for (i = 0; i < i7core_dev->n_devs; i++) {
 		pdev = i7core_dev->pdev[i];
 		if (!pdev)
@@ -1504,9 +1506,37 @@ static int mci_bind_devs(struct mem_ctl_info *mci,
 			if (unlikely(func > MAX_CHAN_FUNC))
 				goto error;
 			pvt->pci_ch[slot - 4][func] = pdev;
-		} else if (!slot && !func)
+		} else if (!slot && !func) {
 			pvt->pci_noncore = pdev;
-		else
+
+			/* Detect the processor family */
+			switch (pdev->device) {
+			case PCI_DEVICE_ID_INTEL_I7_NONCORE:
+				family = "Xeon 35xx/ i7core";
+				pvt->enable_scrub = false;
+				break;
+			case PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_ALT:
+				family = "i7-800/i5-700";
+				pvt->enable_scrub = false;
+				break;
+			case PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE:
+				family = "Xeon 34xx";
+				pvt->enable_scrub = false;
+				break;
+			case PCI_DEVICE_ID_INTEL_I7_NONCORE_ALT:
+				family = "Xeon 55xx";
+				pvt->enable_scrub = true;
+				break;
+			case PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_REV2:
+				family = "Xeon 56xx / i7-900";
+				pvt->enable_scrub = true;
+				break;
+			default:
+				family = "unknown";
+				pvt->enable_scrub = false;
+			}
+			debugf0("Detected a processor type %s\n", family);
+		} else
 			goto error;
 
 		debugf0("Associated fn %d.%d, dev = %p, socket %d\n",
@@ -1515,7 +1545,7 @@ static int mci_bind_devs(struct mem_ctl_info *mci,
 
 		if (PCI_SLOT(pdev->devfn) == 3 &&
 			PCI_FUNC(pdev->devfn) == 2)
-			pvt->is_registered = 1;
+			pvt->is_registered = true;
 	}
 
 	return 0;
@@ -2060,7 +2090,8 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 		__func__, mci, &i7core_dev->pdev[0]->dev);
 
 	/* Disable scrubrate setting */
-	disable_sdram_scrub_setting(mci);
+	if (pvt->enable_scrub)
+		disable_sdram_scrub_setting(mci);
 
 	/* Disable MCE NMI handler */
 	edac_mce_unregister(&pvt->edac_mce);
@@ -2136,7 +2167,8 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	mci->edac_check = i7core_check_error;
 
 	/* Enable scrubrate setting */
-	enable_sdram_scrub_setting(mci);
+	if (pvt->enable_scrub)
+		enable_sdram_scrub_setting(mci);
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
