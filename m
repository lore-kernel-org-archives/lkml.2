Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab1LQB2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 20:28:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17633 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab1LQB2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 20:28:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 16 Dec 2011 17:28:08 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 17 Dec 2011 02:28:03 +0100
Subject: Re: [PATCH v2 2/2] [RFC] ARM: IOMMU: Tegra30: iommu_ops for SMMU
 driver
Thread-Topic: [PATCH v2 2/2] [RFC] ARM: IOMMU: Tegra30: iommu_ops for SMMU
 driver
Thread-Index: Acy8Wx/Qf6GJTCrwRdaFXMECFkQK9w==
Message-ID: <20111217.032803.682884539529149599.hdoyu@nvidia.com>
References: <1323954690-7000-3-git-send-email-hdoyu@nvidia.com><20111216153904.GC29877@amd.com><20111217.030315.2218721757650628823.hdoyu@nvidia.com>
In-Reply-To: <20111217.030315.2218721757650628823.hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2 2/2] [RFC] ARM: IOMMU: Tegra30: iommu_ops for SMMU driver
Date: Sat, 17 Dec 2011 03:03:15 +0200 (EET)
Message-ID: <20111217.030315.2218721757650628823.hdoyu@nvidia.com>

> Hi Joerg, Thank you for your quick review.
> 
> From: Joerg Roedel <joerg.roedel@amd.com>
> Subject: Re: [PATCH v2 2/2] [RFC] ARM: IOMMU: Tegra30: iommu_ops for SMMU driver
> Date: Fri, 16 Dec 2011 16:39:04 +0100
> Message-ID: <20111216153904.GC29877@amd.com>
> 
> > On Thu, Dec 15, 2011 at 03:11:30PM +0200, Hiroshi DOYU wrote:
> > > +static int smmu_iommu_attach_dev(struct iommu_domain *domain,
> > > +				 struct device *dev)
> > > +{
> > > +	struct smmu_as *as = domain->priv;
> > > +	struct smmu_client *client, *c;
> > > +	u32 map;
> > > +	int err;
> > > +
> > > +	client = kmalloc(sizeof(*c), GFP_KERNEL);
> > > +	if (!client)
> > > +		return -ENOMEM;
> > > +	client->dev = dev;
> > > +	client->as = as;
> > > +	map = (unsigned long)dev->platform_data;
> > > +	if (!map)
> > > +		return -EINVAL;
> > > +
> > > +	err = smmu_client_enable_hwgrp(client, map);
> > > +	if (err)
> > > +		goto err_hwgrp;
> > > +
> > > +	spin_lock(&as->client_lock);
> > > +	list_for_each_entry(c, &as->client, list) {
> > > +		if (c->dev == dev) {
> > > +			pr_err("%s is already attached\n", dev_name(dev));
> > > +			err = -EINVAL;
> > > +			goto err_client;
> > > +		}
> > > +	}
> > > +	list_add(&client->list, &as->client);
> > > +	spin_unlock(&as->client_lock);
> > > +
> > > +	/*
> > > +	 * Reserve "page zero" for AVP vectors using a common dummy
> > > +	 * page.
> > > +	 */
> > > +	if (map & HWG_AVPC) {
> > > +		struct page *page;
> > > +
> > > +		page = as->smmu->avp_vector_page;
> > > +		__smmu_iommu_map_pfn(as, 0, page_to_pfn(page));
> > > +
> > > +		pr_info("Reserve \"page zero\" for AVP vectors using a common dummy\n");
> > > +	}
> > > +
> > > +	pr_debug("Attached %s\n", dev_name(dev));
> > > +	return 0;
> > > +err_client:
> > > +	smmu_client_disable_hwgrp(client);
> > > +	spin_unlock(&as->client_lock);
> > > +err_hwgrp:
> > > +	kfree(client);
> > > +	return err;
> > > +}
> > 
> > Hmm, I have a question about that. Reading the code it looks like your
> > SMMU exists per pheripheral device
> 
> A single SMMU is shared with multiple peripheral devices, a single
> SMMU has multiple ASIDs. ASID is used per group of peripheral
> devices. These peripheral groups can be configured by the above
> "hwgrp"/"map" passed via platform_data. The above "struct device"
> represents a groupd of peripheral devices, a kind of virtual device.
> 
> The above "struct device" ~= a group of peripheral devices.
> 
> > and the SMMU hardware supports multiple address spaces per device,
> > right?
> 
> Yes, where "device" is a gropud of peripheral devices.
> 
> > The domains are implemented for one address-space.
> 
> Yes.
> 
> > So is it right that a device can have multiple
> > address-spaces?
> 
> No, at least, the following code prevents if a peripheral is already
> assigned ASID.
> 
> smmu_client_enable_hwgrp():

Here, smmu_client_enable_hwgrp() == __smmu_client_set_hwgrp(),

+static int __smmu_client_set_hwgrp(struct smmu_client *c,
+				   unsigned long map, int on)
+{
+	int i;
+	struct smmu_as *as = c->as;
+	u32 val, offs, mask = SMMU_ASID_ENABLE(as->asid);
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+	struct smmu_device *smmu = as->smmu;
+
+	WARN_ON(!on && map);
+	if (on && !map)
+		return -EINVAL;
+	if (!on)
+		map = smmu_client_hwgrp(c);
+
+	for_each_set_bit(i, &map, BITS_PER_LONG) {

> +	for_each_set_bit(i, &map, BITS_PER_LONG) {
> +		offs = HWGRP_ASID_REG(i);
> +		val = smmu_read(smmu, offs);
> +		if (on) {
> +			if (WARN_ON(val & mask))
> +				goto err_hw_busy;
                        ^^^^^^^^^^^^^^^^^^^^^^^^^
This checks if peripheral device is already enable(and ASID
assigned). If so, it returns error. A group of peripheral devices are
configured into struct device in advance.

> 
> 
> > If so, what kind of devices do you bind to the domains
> > then. I doesn't make sense to bind whole peripheral devices in this
> > case.
> 
> Here, the above "struct device" ~= a group of any peripheral
> devices. Those groups are configurable.
> 
> 
> In my simple DMA API test(not posted), the above hwgrp/map is configured as below:
> 
>    146  static int __init dmaapi_test_init(void)
>    147  {
>    148          int i;
>    149          struct dma_iommu_mapping *map;
>    150  
>    151          map = arm_iommu_create_mapping(IOVA_START, IOVA_SIZE, 0);
>    152          BUG_ON(!map);
>    153          pr_debug("Allocate IOVA: %08x-%08x\n", map->base, map->base + IOVA_SIZE);
>    154  
>    155          for (i = 0; i < ARRAY_SIZE(dmaapi_dummy_device); i++) {
>    156                  int err;
>    157                  struct platform_device *pdev = &dmaapi_dummy_device[i];
>    158  
>    159                  pdev->dev.platform_data = (void *)dummy_hwgrp_map[i];
>    160                  err = platform_device_register(pdev);
>    161                  BUG_ON(err);
>    162  
>    163                  err = arm_iommu_attach_device(&pdev->dev, map);
>    164                  BUG_ON(err);
>    165                  pr_debug("IOMMU API: Attached to %s\n", dev_name(&pdev->dev));
>    166          }
> 
> So peripheral devices can be divided into multiple groups, and each
> each group represents struct device with hwgrp/map info in
> platform_data.
