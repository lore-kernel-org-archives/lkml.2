Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2AELIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:08:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab2AELIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:08:06 -0500
Date: Thu, 5 Jan 2012 12:07:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 didn't survive after s2ram failure
Message-ID: <20120105110744.GA2222@redhat.com>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
 <20120103103457.GA3391@redhat.com>
 <20120103130306.GA3891@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20120103130306.GA3891@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 03, 2012 at 02:03:06PM +0100, Michal Hocko wrote:
> [ 5622.739466] ieee80211 phy0: U iwl_legacy_apm_init Init card's basic functions
> [ 5622.740021] iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
[snip]
> Yes and no change. I even tried to disable wireless in BIOS boot and
> then enable it again. No change...
> It seems somebody already had the same problem
> https://bugzilla.redhat.com/show_bug.cgi?id=639184. My BIOS doesn't
> provide any locator setting, unfortunatelly.
> 
> The message above says that the HW is still in a deep sleep state. Can
> we somehow force waking it up?

The message is a bit confusing, it happen when on device processor does
not clear bit it suppose to. It can be in some sleep state, reset state
or powered off. But this message could be triggered when there is PCIe
connection problem, since we can not read properly register value, what
seems to be issue here as value is 0xFFFFFFFF.

> Or, can we just ignore the signature check and (maybe) fix it by another
> suspend/resume cycle?

Only interesting thing we do while resume in the driver is:
pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00); 
we do the same during erly stage of .probe function too.

In the RH bugzilla case, it was regression. There are no iwlegacy
changes between mentioned kernel versions. There are some APCI and pci
changes. Can you try if any of these kernel boot parameters helps:
pcie_aspm=off
pcie_aspm=force
pci=nocsr
pci=use_csr

More than that, I'm attaching a patch, there is very small chance
it will help.

Stanislaw

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwl3945.patch"

diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index b282d86..94934eb 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -3700,8 +3700,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/***************************
 	 * 2. Initializing PCI bus
 	 * *************************/
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-				PCIE_LINK_STATE_CLKPM);
+	//pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+	//			PCIE_LINK_STATE_CLKPM);
 
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
@@ -3751,7 +3751,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * strange state ... like being left stranded by a primary kernel
 	 * and this is now the kdump kernel trying to start up
 	 */
-	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	//iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/***********************
 	 * 4. Read EEPROM

--RnlQjJ0d97Da+TV1--
