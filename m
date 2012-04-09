Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2DILoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 07:44:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58887 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2DILn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 07:43:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F82CB64.8030808@jp.fujitsu.com>
Date: Mon, 09 Apr 2012 20:43:32 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Taku Izumi <izumi.taku@jp.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI, ACPI, x86: update MMCFG information when hot-plugging
 PCI host bridges
References: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com> <1333905129-8776-3-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1333905129-8776-3-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch looks good to me.

I have some comments.

(2012/04/09 2:12), Jiang Liu wrote:
> This patch enhances pci_root driver to update MMCFG information when
> hot-plugging PCI root bridges on x86 platforms.
>

Do you have the patch that can be applied to Bjorn's pci tree?

<snip.>

> +int arch_acpi_pci_root_add(struct acpi_pci_root *root)
> +{
> +	int result = 0;
> +	acpi_status status;
> +	unsigned long long base_addr;
> +	struct pci_mmcfg_region *cfg;
> +
> +	/*
> +	 * Try to insert MMCFG information for host bridges with _CBA method
> +	 */
> +	status = acpi_evaluate_integer(root->device->handle, METHOD_NAME__CBA,
> +				       NULL,&base_addr);
> +	if (ACPI_SUCCESS(status)) {
> +		result = pci_mmconfig_insert(root->segment,
> +					     root->secondary.start,
> +					     root->secondary.end,
> +					     base_addr);
> +		/*
> +		 * MMCFG information for hot-pluggable host bridges may have
> +		 * already been added by __pci_mmcfg_init();
> +		 */
> +		if (result == -EEXIST)
> +			result = 0;

Just for confirmation.
>From my interpretation of PCI firmware spec, MCFG doesn't have any entry
for hot-pluggable hostbridge. So I assume this is for the machine that
is not compliant to the spec. Is my understanding same as yours?

<snip.>

>   static int __devinit acpi_pci_root_add(struct acpi_device *device)
>   {
>   	unsigned long long segment, bus;
> @@ -504,6 +514,14 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>   	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>   	device->driver_data = root;
> 
> +	if (arch_acpi_pci_root_add(root)) {
> +		printk(KERN_ERR PREFIX
> +			"can't add MMCFG information for Bus %04x:%02x\n",
> +			root->segment, (unsigned int)root->secondary.start);
> +		result = -ENODEV;
> +		goto out_free;
> +	}

Desn't this break the system that doesn't support MMCONFIG?

In my understanding, arch_acpi_pci_root_add() returns -ENODEV if
mmconfig information is found neither in MCFG table nor _CBA. And
pci root bridge initialization seems to fail arch_acpi_pci_root_add()
returns non-zero value.

Regards,
Kenji Kaneshige
