Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab0EZBXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:23:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58330 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab0EZBXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:23:44 -0400
Date: Wed, 26 May 2010 11:23:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the galak tree with Linus' tree
Message-Id: <20100526112341.1a808fa5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

Today's linux-next merge of the galak tree got a conflict in
arch/powerpc/sysdev/fsl_msi.c between commit
61c7a080a5a061c976988fd4b844dfb468dda255 ("of: Always use 'struct
device.of_node' to get device node pointer") from Linus' tree and commits
061ca4adfb2e3c986a182fd30f7e939a1ff8d29d ("powerpc/fsl_msi: enable msi
sharing through AMP OSes") and 480599933a69a8a8dc1390c2164e49e20a1593b9
("powerpc/fsl_msi: add removal path and probe failing path") from the
galak tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/sysdev/fsl_msi.c
index a7be144,f7ca9e6..0000000
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@@ -245,11 -293,11 +293,11 @@@ static int __devinit fsl_of_msi_probe(s
  	msi = kzalloc(sizeof(struct fsl_msi), GFP_KERNEL);
  	if (!msi) {
  		dev_err(&dev->dev, "No memory for MSI structure\n");
- 		err = -ENOMEM;
- 		goto error_out;
+ 		return -ENOMEM;
  	}
+ 	dev->dev.platform_data = msi;
  
 -	msi->irqhost = irq_alloc_host(dev->node, IRQ_HOST_MAP_LINEAR,
 +	msi->irqhost = irq_alloc_host(dev->dev.of_node, IRQ_HOST_MAP_LINEAR,
  				      NR_MSI_IRQS, &fsl_msi_host_ops, 0);
  
  	if (msi->irqhost == NULL) {
@@@ -298,14 -346,28 +346,28 @@@
  		err = -EINVAL;
  		goto error_out;
  	}
+ 	offset = 0;
 -	p = of_get_property(dev->node, "msi-available-ranges", &len);
++	p = of_get_property(dev->dev.of_node, "msi-available-ranges", &len);
+ 	if (p)
+ 		offset = *p / IRQS_PER_MSI_REG;
  
  	count /= sizeof(u32);
- 	for (i = 0; i < count / 2; i++) {
- 		if (i > NR_MSI_REG)
- 			break;
+ 	for (i = 0; i < min(count / 2, NR_MSI_REG); i++) {
 -		virt_msir = irq_of_parse_and_map(dev->node, i);
 +		virt_msir = irq_of_parse_and_map(dev->dev.of_node, i);
  		if (virt_msir != NO_IRQ) {
- 			set_irq_data(virt_msir, (void *)i);
+ 			cascade_data = kzalloc(
+ 					sizeof(struct fsl_msi_cascade_data),
+ 					GFP_KERNEL);
+ 			if (!cascade_data) {
+ 				dev_err(&dev->dev,
+ 					"No memory for MSI cascade data\n");
+ 				err = -ENOMEM;
+ 				goto error_out;
+ 			}
+ 			msi->msi_virqs[i] = virt_msir;
+ 			cascade_data->index = i + offset;
+ 			cascade_data->msi_data = msi;
+ 			set_irq_data(virt_msir, (void *)cascade_data);
  			set_irq_chained_handler(virt_msir, fsl_msi_cascade);
  		}
  	}
@@@ -345,12 -413,10 +413,13 @@@ static const struct of_device_id fsl_of
  };
  
  static struct of_platform_driver fsl_of_msi_driver = {
 -	.name = "fsl-msi",
 -	.match_table = fsl_of_msi_ids,
 +	.driver = {
 +		.name = "fsl-msi",
 +		.owner = THIS_MODULE,
 +		.of_match_table = fsl_of_msi_ids,
 +	},
  	.probe = fsl_of_msi_probe,
+ 	.remove = fsl_of_msi_remove,
  };
  
  static __init int fsl_of_msi_init(void)
http://www.canb.auug.org.au/~sfr/
