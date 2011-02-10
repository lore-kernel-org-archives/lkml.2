Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1BJJvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:51:24 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:47590 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958Ab1BJJvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:51:22 -0500
Message-ID: <4D53B4C1.5080804@st.com>
Date: Thu, 10 Feb 2011 15:19:53 +0530
From: pratyush <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH V3 1/1] ST SPEAr: PCIE gadget suppport
References: <1296742149-18102-1-git-send-email-pratyush.anand@st.com> <20110209152926.0126ac97.akpm@linux-foundation.org>
In-Reply-To: <20110209152926.0126ac97.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/2011 4:59 AM, Andrew Morton wrote:
> On Thu, 3 Feb 2011 19:39:09 +0530
> Pratyush Anand <pratyush.anand@st.com> wrote:
> 
>> This is a configurable gadget. can be configured by configfs interface. Any
>> IP available at PCIE bus can be programmed to be used by host
>> controller.It supoorts both INTX and MSI.
>> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
>> with size 0x1000
>>
>>
>> ...
>>
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/configfs-spear-pcie-gadget
>> @@ -0,0 +1,30 @@
>> +What:		/config/pcie-gadget
>> +Date:		Feb 2011
>> +KernelVersion:	2.6.37
>> +Contact:	Pratyush Anand <pratyush.anand@st.com>
>> +Description:
>> +
>> +	Interface is used to configure selected dual mode pcie controller
>> +	as device and then program its various registers to configure it
>> +	as a particular device type.
>> +	This interfaces can be used to show spear's pcie device capability.
>> +
>> +	Nodes are only visible when configfs is mounted. To mount configfs
>> +	in /config directory use:
>> +	# mount -t configfs none /config/
>> +
>> +	/config/pcie-gadget/
>> +		link ... used to enable ltssm and read its status.
>> +		int_type ...used to configure and read type of supported
>> +			interrupt
>> +		no_of_msi ... used to configure number of MSI vector needed and
>> +			to read no of MSI granted.
>> +		inta ... write 1 to assert INTA and 0 to de-assert.
>> +		send_msi ... write MSI vector to be sent.
>> +		vendor_id ... used to write and read vendor id (hex)
>> +		device_id ... used to write and read device id (hex)
>> +		bar0_size ... used to write and read bar0_size
>> +		bar0_address ... used to write and read bar0 mapped area in hex.
>> +		bar0_rw_offset ... used to write and read offset of bar0 where
>> +			bar0_data will be written or read.
>> +		bar0_data ... used to write and read data at bar0_rw_offset.
> 
> This interface implies that there will only ever be one device in the
> machine, yes?  Seems a bit short-sighted?
> 

This device supports only one BAR in EP mode.

>>
>> ...
>>
>> +Node programming example
>> +===========================
>> +Program all PCIE registers in such a way that when this device is connected
>> +to the pcie host, then host sees this device as 1MB RAM.
>> +#mount -t configfs none /Config
>> +# cd /config/pcie_gadget/
>> +Now you have all the nodes in this directory.
>> +program vendor id as 0x104a
>> +# echo 104A >> vendor_id
>> +
>> +program device id as 0xCD80
>> +# echo CD80 >> device_id
>> +
>> +program BAR0 size as 1MB
>> +# echo 100000 >> bar0_size
> 
> I'd be more comfortable if all the hex inputs and outputs had a leading
> 0x.
> 

It works with both with and without 0x.

>>
>> ...
>>
>> +static void spear_dbi_read_reg(struct spear_pcie_gadget_config *config,
>> +		int where, int size, u32 *val)
>> +{
>> +	struct pcie_app_reg __iomem *app_reg
>> +		= (struct pcie_app_reg __iomem *) config->va_app_base;
>> +	u32 va_address;
>> +
>> +	/* Enable DBI access */
>> +	enable_dbi_access(app_reg);
>> +
>> +	va_address = (u32)config->va_dbi_base + (where & ~0x3);
> 
> This will be buggy on 64-bit machines.
> 
>> +	*val = readl(va_address);
> 
> I guess the code won't be running on 64-bit machines ;)
> 
> Still, it would be good to minimise the obvious portability problems.
> 

Yes, this is for 32 bit ARM platform. But I will typecast it with long
to minimize portability issue.

>> +	if (size == 1)
>> +		*val = (*val >> (8 * (where & 3))) & 0xff;
>> +	else if (size == 2)
>> +		*val = (*val >> (8 * (where & 3))) & 0xffff;
>> +
>> +	/* Disable DBI access */
>> +	disable_dbi_access(app_reg);
>> +}
>> +
>> +static void spear_dbi_write_reg(struct spear_pcie_gadget_config *config,
>> +		int where, int size, u32 val)
>> +{
>> +	struct pcie_app_reg __iomem *app_reg
>> +		= (struct pcie_app_reg __iomem *) config->va_app_base;
> 
> Is the typecast needed?  We shouldn't *need* to cast a void **iomem *
> in this manner.  If we do need the cast then something is broken.
> 

It works without typecast also. I will modify it.

>> +	u32 va_address;
>> +
>> +	/* Enable DBI access */
>> +	enable_dbi_access(app_reg);
>> +
>> +	va_address = (u32)config->va_dbi_base + (where & ~0x3);
>> +
>> +	if (size == 4)
>> +		writel(val, va_address);
>> +	else if (size == 2)
>> +		writew(val, va_address + (where & 2));
>> +	else if (size == 1)
>> +		writeb(val, va_address + (where & 3));
>> +
>> +	/* Disable DBI access */
>> +	disable_dbi_access(app_reg);
>> +}
>> +
>>
>> ...
>>
>> +static ssize_t pcie_gadget_store_link(
>> +		struct spear_pcie_gadget_config *config,
>> +		const char *buf, size_t count)
>> +{
>> +	struct pcie_app_reg __iomem *app_reg =
>> +		(struct pcie_app_reg __iomem *) config->va_app_base;
>> +	char link[10];
>> +
>> +	if (strlen(buf) >= 10)
>> +		return -EINVAL;
>> +
>> +	if (sscanf(buf, "%s", link) != 1)
>> +		return -EINVAL;
>> +
>> +	if (!strcmp(link, "UP"))
>> +		writel(readl(&app_reg->app_ctrl_0) | (1 << APP_LTSSM_ENABLE_ID),
>> +			&app_reg->app_ctrl_0);
>> +	else
>> +		writel(readl(&app_reg->app_ctrl_0)
>> +				& ~(1 << APP_LTSSM_ENABLE_ID),
>> +				&app_reg->app_ctrl_0);
>> +	return count;
>> +}
> 
> This function looks unnecessarily complex.  Why not do something like
> 
> 	if (sysfs_streq(buf, "UP"))
> 		...
> 	else if (sysfs_streq(buf, "UP"))
> 		...
> 	else
> 		fail;
> 
> And note that the code at present is sloppily treating all input other
> than "UP" as "DOWN".  Don't do that.
> 
> 

sysfs_streq seems better options. I will use it.

>> +static ssize_t pcie_gadget_show_int_type(
>> +		struct spear_pcie_gadget_config *config,
>> +		char *buf)
>> +{
>> +	return sprintf(buf, "%s", config->int_type);
>> +}
>> +
>> +static ssize_t pcie_gadget_store_int_type(
>> +		struct spear_pcie_gadget_config *config,
>> +		const char *buf, size_t count)
>> +{
>> +	char int_type[10];
>> +	u32 cap, vec, flags;
>> +	unsigned long vector;
>> +
>> +	if (strlen(buf) >= 10)
>> +		return -EINVAL;
>> +
>> +	if (sscanf(buf, "%s", int_type) != 1)
>> +		return -EINVAL;
> 
> Similarly, the local copy of the string isn't needed.
> 

Ok.

>> +	if (!strcmp(int_type, "INTA"))
>> +		spear_dbi_write_reg(config, PCI_INTERRUPT_LINE, 1, 1);
>> +
>> +	else if (!strcmp(int_type, "MSI")) {
>> +		vector = config->requested_msi;
>> +		vec = 0;
>> +		while (vector > 1) {
>> +			vector /= 2;
>> +			vec++;
>> +		}
>> +		spear_dbi_write_reg(config, PCI_INTERRUPT_LINE, 1, 0);
>> +		cap = pci_find_own_capability(config, PCI_CAP_ID_MSI);
>> +		spear_dbi_read_reg(config, cap + PCI_MSI_FLAGS, 1, &flags);
>> +		flags &= ~PCI_MSI_FLAGS_QMASK;
>> +		flags |= vec << 1;
>> +		spear_dbi_write_reg(config, cap + PCI_MSI_FLAGS, 1, flags);
>> +	} else
>> +		return -EINVAL;
>> +
>> +	strcpy(config->int_type, int_type);
>> +
>> +	return count;
>> +}
>> +
>> +static ssize_t pcie_gadget_show_no_of_msi(
>> +		struct spear_pcie_gadget_config *config,
>> +		char *buf)
>> +{
>> +	struct pcie_app_reg __iomem *app_reg =
>> +		(struct pcie_app_reg __iomem *)config->va_app_base;
>> +	u32 cap, vector, vec, flags;
>> +
>> +	if ((readl(&app_reg->msg_status) & (1 << CFG_MSI_EN_ID))
>> +			!= (1 << CFG_MSI_EN_ID))
>> +		vector = 0;
>> +	else {
>> +		cap = pci_find_own_capability(config, PCI_CAP_ID_MSI);
>> +		spear_dbi_read_reg(config, cap + PCI_MSI_FLAGS, 1, &flags);
>> +		flags &= ~PCI_MSI_FLAGS_QSIZE;
>> +		vec = flags >> 4;
>> +		vector = 1;
>> +		while (vec--)
>> +			vector *= 2;
>> +	}
>> +	config->configured_msi = vector;
> 
> Wait.  A "show" function is modifying kernel state?!?!?
> 

this show is a must call part of MSI vector negotiation.
A device must read first configured number of MSI, before 
sending any MSI. Here value of vector is read from HW
and stored in a SW variable. So, it is not programmed
by any application input.

>> +
>> +	return sprintf(buf, "%u", vector);
>> +}
>> +
>>
>> ...
>>
>> +static ssize_t pcie_gadget_store_send_msi(
>> +		struct spear_pcie_gadget_config *config,
>> +		const char *buf, size_t count)
>> +{
>> +	struct pcie_app_reg __iomem *app_reg =
>> +		(struct pcie_app_reg __iomem *)config->va_app_base;
>> +	unsigned long vector;
>> +	u32 ven_msi;
>> +
>> +	if (strict_strtoul(buf, 0, &vector))
>> +		return -EINVAL;
>> +
>> +	if (!config->configured_msi)
>> +		return -EINVAL;
> 
> This is racy, isn't it?  Some other thread could be concurrently
> modifying ->configured_msi?  (It's a minor issue IMO).
> 

configured_msi is programmmed through show_no_of_msi function. It does
not store a value from user interface. rather it stores value from
a HW register.
Normally this function will be called only once , just after link UP.
Even if some other thread calls it again., it will read same value from HW.


>> +	if (vector >= config->configured_msi)
>> +		return -EINVAL;
>> +
>> +	ven_msi = readl(&app_reg->ven_msi_1);
>> +	ven_msi &= ~VEN_MSI_FUN_NUM_MASK;
>> +	ven_msi |= 0 << VEN_MSI_FUN_NUM_ID;
>> +	ven_msi &= ~VEN_MSI_TC_MASK;
>> +	ven_msi |= 0 << VEN_MSI_TC_ID;
>> +	ven_msi &= ~VEN_MSI_VECTOR_MASK;
>> +	ven_msi |= vector << VEN_MSI_VECTOR_ID;
>> +
>> +	/*generating interrupt for msi vector*/
>> +	ven_msi |= VEN_MSI_REQ_EN;
>> +	writel(ven_msi, &app_reg->ven_msi_1);
>> +	/*need to wait till this bit is cleared, it is not cleared
>> +	 * autometically[Bug RTL] TBD*/
>> +	udelay(1);
>> +	ven_msi &= ~VEN_MSI_REQ_EN;
>> +	writel(ven_msi, &app_reg->ven_msi_1);
>> +
>> +	return count;
>> +}
>> +
>>
>> ...
>>
>> +static ssize_t pcie_gadget_store_bar0_address(
>> +		struct spear_pcie_gadget_config *config,
>> +		const char *buf, size_t count)
>> +{
>> +	struct pcie_app_reg __iomem *app_reg =
>> +		(struct pcie_app_reg __iomem *)config->va_app_base;
>> +	unsigned long address;
>> +
>> +	if (strict_strtoul(buf, 0, &address))
>> +		return -EINVAL;
>> +
>> +	address &= ~(config->bar0_size - 1);
>> +	if (config->va_bar0_address)
>> +		iounmap((void *)config->va_bar0_address);
> 
> `void __iomem *' would be a more accurate cast and might avoid sparse
> warnings.
>
> Even better would be to avoid the cast all together.  Does
> va_bar0_address have the correct type?
> 

OK, i ll do it.

>> +	config->va_bar0_address = (u32)ioremap(address, config->bar0_size);
>> +	if (!config->va_bar0_address)
>> +		return -ENOMEM;
>> +
>> +	writel(address, &app_reg->pim0_mem_addr_start);
>> +
>> +	return count;
>> +}
>> +
>>
>> ...
>>
> 
> .
> 

