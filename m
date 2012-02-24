Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2BXRBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:01:24 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:53185 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab2BXRBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:01:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jgpobox@gmail.com designates 10.229.137.80 as permitted sender) smtp.mail=jgpobox@gmail.com; dkim=pass header.i=jgpobox@gmail.com
Message-ID: <4F47C25F.50005@garzik.org>
Date: Fri, 24 Feb 2012 12:01:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Fuzhou Chen <fuzhouch@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, jgarzik@redhat.com, mjg@redhat.com,
        Len Brown <lenb@kernel.org>, Holger Macht <holger@homac.de>
Subject: Re: linux-next: pata_acpi.ko crashes at ata_ap_acpi_handle()
References: <6689D53B948ACF469C8E9C8CCD48EBE1114EFE01@SINEX14MBXC415.southpacific.corp.microsoft.com> <20120224142609.2c7e519d@pyramind.ukuu.org.uk>
In-Reply-To: <20120224142609.2c7e519d@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 09:26 AM, Alan Cox wrote:
>>         We can see the code in ata_ap_acpi_handle()accesses ap->scsi_host filed without checking if it’s initialized, which causes NULL pointer panic. Meanwhile, ata_pci_sff_activate_host() calls ata_host_register(), which calls ata_scsi_add_hosts() to initialize scsi_host field. Both calls are after ata_host_start() in a must-visit code path. I believe ata_scsi_add_hosts() is the first place for initialization because it does not check if scsi_host field is NULL either. So it makes no sense to access ap->scsi_host in ata_ap_acpi_handle().
>
> This appears to be caused by broken changes to the libata code from
> Matthew Garrett and others who introduced a dependancy on scsi_host which
> isn't safe to do because drivers can touch the ACPI earlier than the
> scsi registration and in fact *NEED* to do so.
>
> Jeff - can we get these patches dropped back out for the moment - they
> cause a regression and boot crash in pata_acpi.
>
> The stack from 75d22cd567cac6fe2af8acb33f6ebcd16876d250 needs to get
> punted and the scsi_host indirection removed and fixed up for it to work
> safely with existing libata drivers.
>
> I don't see an obvious way to fix up the existing ordering dependancies,
> especially on the pata_acpi side but if someone has bright ideas there
> that would probably be the best choice. Right now these patches stop any
> ACPI querying being done during the port setup. We need to do those
> queries in order to know if the port can be driven by ACPI and what modes
> we can make work.

Sigh.  You are right.  I kept waiting and waiting for fix-up patches, 
but they just need more baking and thinking it seems.

	Jeff





