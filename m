Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2IUGWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:22:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48311 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2IUGWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:22:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5zeBVBowMyQS8QgAzrVbTJOb=Tuees9r1BnUZ3x13V0A@mail.gmail.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
	<1346168638-32724-5-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQVAOEUHMSFHCpZLVK-Rbso3Rh1nUQHmfcujwb6tpUTz8A@mail.gmail.com>
	<CAErSpo58sSCPYF9Ug-o-f3odJovECkdxPOoahx9+Ob6kmP_srw@mail.gmail.com>
	<CAE9FiQWuVW6U9cE+iY0Gpua_0xhdxp6HxcWyhqqSN+L3Da_1Qg@mail.gmail.com>
	<CAErSpo5zeBVBowMyQS8QgAzrVbTJOb=Tuees9r1BnUZ3x13V0A@mail.gmail.com>
Date: Thu, 20 Sep 2012 23:22:48 -0700
X-Google-Sender-Auth: PU9V3OBdEk7805terNy0IES9YxI
Message-ID: <CAE9FiQXXB-qqWXc_pL-BVrboMzuvvPDPbEwK2To-taMg+NHu4A@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 7:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> This is another thing I'm curious about.  How do you handle this
> situation today (before host bridge hot-add)?
>
> The DMAR I'm not so worried about because as far as I know, there's no
> such thing as a DMAR that's discovered by PCI enumeration.  We should
> discover it via ACPI, and that can happen before we enumerate anything
> behind a host bridge, so I don't really see any ordering problem
> between the DMAR and the PCI devices that would use it.

only need to have pci devices on that root bus scanned, and current intel iommu
maintain one device scope to drhd with pointer to pci device... that
need to be fixed
too.

>
> However, I know there *are* IOAPICs that are enumerated as PCI
> devices, and I don't know whether we can deduce a relationship between
> the IOAPIC and the devices that use it.  Don't we have this problem
> already?  I assume that even without hot-adding a host bridge, we
> might discover a PCI IOAPIC that was present at boot, and we'd have to
> make sure to bind a driver to it before we use any of the PCI devices
> connected to it.  How does that work?

I converted it to acpi way to discover it, and it could handle that case.

will search _GSB and try to get pci device, if there is pci device
will try to get BAR as ioapic base.

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=blob;f=drivers/pci/ioapic.c;h=504ca93ac692646a7754fff83a04e3d07d98f648;hb=refs/heads/for-x86-irq

something like:

static void handle_ioapic_add(acpi_handle handle, struct pci_dev **pdev,
				 u32 *pgsi_base)
{
	acpi_status status;
	unsigned long long gsb;
	struct pci_dev *dev;
	u32 gsi_base;
	int ret;
	char *type;
	struct resource r;
	struct resource *res = &r;
	char objname[64];
	struct acpi_buffer buffer = {sizeof(objname), objname};

	*pdev = NULL;
	*pgsi_base = 0;

	status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsb);
	if (ACPI_FAILURE(status) || !gsb)
		return;

	dev = acpi_get_pci_dev(handle);
	if (!dev) {
		struct acpi_device_info *info;
		char *hid = NULL;

		status = acpi_get_object_info(handle, &info);
		if (ACPI_FAILURE(status))
			return;
		if (info->valid & ACPI_VALID_HID)
			hid = info->hardware_id.string;
		if (!hid || strcmp(hid, "ACPI0009")) {
			kfree(info);
			return;
		}
		kfree(info);
		memset(res, 0, sizeof(*res));
		acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
		if (!res->flags)
			return;
	}

	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);

	gsi_base = gsb;
	type = "IOxAPIC";
	if (dev) {
		ret = pci_enable_device(dev);
		if (ret < 0)
			goto exit_put;

		pci_set_master(dev);

		if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
			type = "IOAPIC";

		if (pci_request_region(dev, 0, type))
			goto exit_disable;

		res = &dev->resource[0];
	}

	if (acpi_register_ioapic(handle, res->start, gsi_base)) {
		if (dev)
			goto exit_release;
		return;
	}

	printk(KERN_INFO "%s %s %s at %pR, GSI %u\n",
		dev ? dev_name(&dev->dev) : "", objname, type,
		res, gsi_base);

	*pdev = dev;
	*pgsi_base = gsi_base;
	return;

exit_release:
	pci_release_region(dev, 0);
exit_disable:
	pci_disable_device(dev);
exit_put:
	pci_dev_put(dev);
}
