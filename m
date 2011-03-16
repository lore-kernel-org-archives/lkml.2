Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab1CPErE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:47:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43296 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1CPEq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:46:58 -0400
Date: Wed, 16 Mar 2011 15:46:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Scott Wood <scottwood@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: linux-next: manual merge of the devicetree tree with the galak tree
Message-Id: <20110316154653.c178910a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/powerpc/sysdev/fsl_msi.c between commit 6820fead714d
("powerpc/fsl_msi: Handle msi-available-ranges better") from the galak
tree and commit 000061245a67 ("dt/powerpc: Eliminate users of of_platform_
{,un}register_driver") from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/sysdev/fsl_msi.c
index 8d6b074,ee6a8a5..0000000
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@@ -274,48 -273,23 +274,51 @@@ static int fsl_of_msi_remove(struct pla
  	return 0;
  }
  
 +static int __devinit fsl_msi_setup_hwirq(struct fsl_msi *msi,
 +					 struct platform_device *dev,
 +					 int offset, int irq_index)
 +{
 +	struct fsl_msi_cascade_data *cascade_data = NULL;
 +	int virt_msir;
 +
 +	virt_msir = irq_of_parse_and_map(dev->dev.of_node, irq_index);
 +	if (virt_msir == NO_IRQ) {
 +		dev_err(&dev->dev, "%s: Cannot translate IRQ index %d\n",
 +			__func__, irq_index);
 +		return 0;
 +	}
 +
 +	cascade_data = kzalloc(sizeof(struct fsl_msi_cascade_data), GFP_KERNEL);
 +	if (!cascade_data) {
 +		dev_err(&dev->dev, "No memory for MSI cascade data\n");
 +		return -ENOMEM;
 +	}
 +
 +	msi->msi_virqs[irq_index] = virt_msir;
 +	cascade_data->index = offset + irq_index;
 +	cascade_data->msi_data = msi;
 +	set_irq_data(virt_msir, cascade_data);
 +	set_irq_chained_handler(virt_msir, fsl_msi_cascade);
 +
 +	return 0;
 +}
 +
- static int __devinit fsl_of_msi_probe(struct platform_device *dev,
- 				const struct of_device_id *match)
+ static int __devinit fsl_of_msi_probe(struct platform_device *dev)
  {
  	struct fsl_msi *msi;
  	struct resource res;
 -	int err, i, count;
 +	int err, i, j, irq_index, count;
  	int rc;
 -	int virt_msir;
  	const u32 *p;
- 	struct fsl_msi_feature *features = match->data;
+ 	struct fsl_msi_feature *features;
 -	struct fsl_msi_cascade_data *cascade_data = NULL;
  	int len;
  	u32 offset;
 +	static const u32 all_avail[] = { 0, NR_MSI_IRQS };
  
+ 	if (!dev->dev.of_match)
+ 		return -EINVAL;
+ 	features = dev->dev.of_match->data;
+ 
  	printk(KERN_DEBUG "Setting up Freescale MSI support\n");
  
  	msi = kzalloc(sizeof(struct fsl_msi), GFP_KERNEL);
