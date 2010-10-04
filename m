Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab0JDNnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:43:52 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:16543
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884Ab0JDNnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:43:50 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9RQ34-01-H2H-02
X-M-MSG: 
Date: Mon, 4 Oct 2010 15:43:39 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Matthew Garrett <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] x86: Reenable the AMD IOMMU if it's mysteriously
 vanished over suspend
Message-ID: <20101004134339.GT9817@amd.com>
References: <1285941683-7445-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285941683-7445-1-git-send-email-mjg@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

first, thanks a lot for your work on this. I had the plan to do this
myself but are busy with other work too. I am very happy that I can
remove this from my todo list :-)
I have tested the patch on one of my test machines with the BIOS bug. It
worked and the box came out of S3 again. The patch needs certainly more
testing on more platforms. I also have a few comments, find them inline
in the patch.

		Joerg

On Fri, Oct 01, 2010 at 10:01:23AM -0400, Matthew Garrett wrote:

> @@ -619,6 +652,7 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
>  {
>  	int cap_ptr = iommu->cap_ptr;
>  	u32 range, misc;
> +	int i, j;
>  
>  	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
>  			      &iommu->cap);
> @@ -633,12 +667,27 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
>  					MMIO_GET_LD(range));
>  	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
>  
> -	if (is_rd890_iommu(iommu->dev)) {
> -		pci_read_config_dword(iommu->dev, 0xf0, &iommu->cache_cfg[0]);
> -		pci_read_config_dword(iommu->dev, 0xf4, &iommu->cache_cfg[1]);
> -		pci_read_config_dword(iommu->dev, 0xf8, &iommu->cache_cfg[2]);
> -		pci_read_config_dword(iommu->dev, 0xfc, &iommu->cache_cfg[3]);
> -	}
> +	if (!is_rd890_iommu(iommu->dev))
> +		return;
> +
> +	/*
> +	 * Some rd890 systems may not be fully reconfigured by the BIOS, so
> +	 * it's necessary for us to store this information so it can be
> +	 * reprogrammed on resume
> +	 */
> +
> +	pci_read_config_dword(iommu->dev, 0x44, &iommu->stored_addr_lo);
> +	pci_read_config_dword(iommu->dev, 0x48, &iommu->stored_addr_hi);

Can you use iommu->cap_ptr here? This variant should be safe too but the
magic numbers are non-descriptive.

>  static void iommu_apply_quirks(struct amd_iommu *iommu)
>  {
> -	if (is_rd890_iommu(iommu->dev)) {
> -		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
> -		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
> -		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
> -		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
> +	int i, j;
> +	u32 ioc_feature_control;
> +	struct pci_dev *pdev = NULL;
> +	int device_id;
> +
> +	/* RD890 BIOSes may not have completely reconfigured the iommu */
> +	if (!is_rd890_iommu(iommu->dev))
> +		return;
> +
> +	/*
> +	 * First, we need to ensure that the iommu is enabled. This is
> +	 * controlled by a register in the northbridge
> +	 */
> +	device_id = 0x5a10;
> +	pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, NULL);
> +
> +	if (!pdev) {
> +		device_id = 0x5a12;
> +		pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, NULL);
>  	}
> +
> +	if (!pdev) {
> +		device_id = 0x5a13;
> +		pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, NULL);
> +	}
> +
> +	if (!pdev)
> +		return;
> +
> +	/* There may be one iommu per bus, so find the appropriate bridge */
> +	while (pdev && (pdev->bus->number != iommu->dev->bus->number)) {
> +		pci_dev_put(pdev);
> +		pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, pdev);
> +	}

This does not work reliably with more than one IOMMU in the system. I
suggest to get the NB device by using the bus/dev/fn of the IOMMU
device. The IOMMU in RD890 is always function 2 of the NB device. So
just take the bus/dev/fn of the IOMMU device, set fn to zero and get the
NB device for re-enabling function two.

> +	pci_write_config_dword(iommu->dev, 0x44, iommu->stored_addr_lo);
> +	pci_write_config_dword(iommu->dev, 0x48, iommu->stored_addr_hi);

iommu->cap_ptr

> @@ -1147,7 +1253,6 @@ static void enable_iommus(void)
>  
>  	for_each_iommu(iommu) {
>  		iommu_disable(iommu);
> -		iommu_apply_quirks(iommu);
>  		iommu_init_flags(iommu);
>  		iommu_set_device_table(iommu);
>  		iommu_enable_command_buffer(iommu);
> @@ -1173,6 +1278,11 @@ static void disable_iommus(void)
>  
>  static int amd_iommu_resume(struct sys_device *dev)
>  {
> +	struct amd_iommu *iommu;
> +
> +	for_each_iommu(iommu)
> +		iommu_apply_quirks(iommu);
> +
>  	/* re-load the hardware */
>  	enable_iommus();

Why have you moved this out of the enable_iommus() loop?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

