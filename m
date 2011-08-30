Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1H3DqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 23:46:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53094 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1H3DqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 23:46:22 -0400
Date: Tue, 30 Aug 2011 13:46:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110830134617.cd571743e6ef68bd4afac999@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-pci.c between commit 16a9d06c753a
("iwlagn: sysfs couldn't find the priv pointer") from Linus' tree and
commit cac988a682d4 ("iwlagn: introduce struct iwl-shared - known by all
layers") from the wireless tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-pci.c
index 2fdbffa,e41f53e..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@@ -478,25 -483,30 +483,25 @@@ out_no_pci
  	return err;
  }
  
 -static void iwl_pci_down(struct iwl_bus *bus)
 -{
 -	struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus->bus_specific;
 -
 -	pci_disable_msi(pci_bus->pci_dev);
 -	pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
 -	pci_release_regions(pci_bus->pci_dev);
 -	pci_disable_device(pci_bus->pci_dev);
 -	pci_set_drvdata(pci_bus->pci_dev, NULL);
 -
 -	kfree(bus);
 -}
 -
  static void __devexit iwl_pci_remove(struct pci_dev *pdev)
  {
- 	struct iwl_priv *priv = pci_get_drvdata(pdev);
- 	struct iwl_bus *bus = priv->bus;
+ 	struct iwl_shared *shrd = pci_get_drvdata(pdev);
+ 	struct iwl_bus *bus = shrd->bus;
 +	struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
 +	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
  
- 	iwl_remove(priv);
+ 	iwl_remove(shrd->priv);
  
 -	iwl_pci_down(bus);
 +	pci_disable_msi(pci_dev);
 +	pci_iounmap(pci_dev, pci_bus->hw_base);
 +	pci_release_regions(pci_dev);
 +	pci_disable_device(pci_dev);
 +	pci_set_drvdata(pci_dev, NULL);
 +
 +	kfree(bus);
  }
  
- #ifdef CONFIG_PM
+ #ifdef CONFIG_PM_SLEEP
  
  static int iwl_pci_suspend(struct device *device)
  {
