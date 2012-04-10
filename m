Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2DJQJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:09:20 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:19056
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab2DJQJR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:09:17 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371I542Mdf9M1432N853kzz1202hzz8275ch8275bh8275dhz2fh2a8h683h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Andy Whitcroft <apw@canonical.com>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Sterling <mike.sterling@microsoft.com>
Subject: RE: [PATCH 1/1] ata_piix: defer disks to the Hyper-V
 paravirtualised drivers by default
Thread-Topic: [PATCH 1/1] ata_piix: defer disks to the Hyper-V
 paravirtualised drivers by default
Thread-Index: AQHNDdFzYR9JvE8AkUO427bJTZY/UJaUSvag
Date: Tue, 10 Apr 2012 16:08:22 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF902511F@BY2PRD0310MB378.namprd03.prod.outlook.com>
References: <1333042130-9634-1-git-send-email-apw@canonical.com>
In-Reply-To: <1333042130-9634-1-git-send-email-apw@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.53.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BY2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%POBOX.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andy Whitcroft [mailto:apw@canonical.com]
> Sent: Thursday, March 29, 2012 1:29 PM
> To: Jeff Garzik; linux-ide@vger.kernel.org
> Cc: Andy Whitcroft; linux-kernel@vger.kernel.org; KY Srinivasan; Mike Sterling
> Subject: [PATCH 1/1] ata_piix: defer disks to the Hyper-V paravirtualised drivers
> by default
> 
> When we are hosted on a Hyper-V hypervisor the guest disks are exposed
> both via the Hyper-V paravirtualised drivers and via an emulated SATA disk
> controller.  We want to use the paravirtualised drivers where possible as
> they are much more performant.  The Hyper-V paravirtualised drivers only
> expose the virtual hard disk devices, the CDROM/DVD devices must still
> be enumerated on the virtualised SATA controller.  As we have no control
> over kernel probe order for these two drivers especially when one driver
> is builtin to the kernel and the other a module, we need to prevent the
> ata_piix driver from claiming the disks devices by default when running
> on a Hyper-V hypervisor.
> 
> When enumerating the drives look at the aquired device ID and if it
> appears to be a disk device then report it as disconnected.  Limit this
> behaviour to when we have detected a Hyper-V hypervisor.  Finally allow
> this behaviour to be overriden via a new module parameter.

Jeff,

Your feedback here would be greatly appreciated. If there are issues with this
please, do let us know.

Regards,

K. Y 
> 
> BugLink: http://bugs.launchpad.net/bugs/929545
> BugLink: http://bugs.launchpad.net/bugs/942316
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  drivers/ata/ata_piix.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
>     This was discovered when doing some boot testing on a Hyper-V
>     host.  Performance was found to be bad as out builtin ata_piix
>     driver was grabbing the disks.  I am Cc:ing a couple of the
>     Microsoft people who worked on the HV driver set as well.
> 
>     Note that the device id data is converted from device to host
>     order in the caller which makes examining the data problematic.
>     As this code only make sense on X86 and we know we are in
>     matching order we can access the data without first fixing it.
>     Alternativly we could add a new callback from the ata core
>     after the code has been fixed for validation.
> 
>     Comments?
> 
>     -apw
> 
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 68013f9..64895f8 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -94,6 +94,9 @@
>  #include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  #include <linux/dmi.h>
> +#ifdef CONFIG_X86
> +#include <asm/hypervisor.h>
> +#endif
> 
>  #define DRV_NAME	"ata_piix"
>  #define DRV_VERSION	"2.13"
> @@ -188,6 +191,29 @@ static int piix_pci_device_resume(struct pci_dev *pdev);
> 
>  static unsigned int in_module_init = 1;
> 
> +static int prefer_ms_hyperv = 1;
> +
> +unsigned int ata_piix_read_id(struct ata_device *dev,
> +					struct ata_taskfile *tf, u16 *id)
> +{
> +	int ret = ata_do_dev_read_id(dev, tf, id);
> +
> +#ifdef CONFIG_X86
> +	/* XXX: note that the device id is in little-endian order, the caller
> +	 * will shift it to host order, but we are working with little-endian.
> +	 * As this is _only_ used on x86 we can actually directly access it
> +	 * as host is also little-endian.
> +	 */
> +	if (!ret && prefer_ms_hyperv && x86_hyper == &x86_hyper_ms_hyperv
> &&
> +							ata_id_is_ata(id)) {
> +		ata_dev_printk(dev, KERN_WARNING, "ATA disk ignored
> deferring to Hyper-V paravirt driver\n");
> +
> +		return AC_ERR_DEV|AC_ERR_NODEV_HINT;
> +	}
> +#endif
> +	return ret;
> +}
> +
>  static const struct pci_device_id piix_pci_tbl[] = {
>  	/* Intel PIIX3 for the 430HX etc */
>  	{ 0x8086, 0x7010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_mwdma },
> @@ -359,6 +385,7 @@ static struct ata_port_operations piix_pata_ops = {
>  	.set_piomode		= piix_set_piomode,
>  	.set_dmamode		= piix_set_dmamode,
>  	.prereset		= piix_pata_prereset,
> +	.read_id		= ata_piix_read_id,
>  };
> 
>  static struct ata_port_operations piix_vmw_ops = {
> @@ -1703,3 +1730,5 @@ static void __exit piix_exit(void)
> 
>  module_init(piix_init);
>  module_exit(piix_exit);
> +
> +module_param(prefer_ms_hyperv, int, 0);
> --
> 1.7.9.1
> 
> 
> 



