Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2BXOYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:24:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48411 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2BXOYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:24:16 -0500
Date: Fri, 24 Feb 2012 14:26:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Fuzhou Chen <fuzhouch@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, jgarzik@redhat.com, mjg@redhat.com
Subject: Re: linux-next: pata_acpi.ko crashes at ata_ap_acpi_handle()
Message-ID: <20120224142609.2c7e519d@pyramind.ukuu.org.uk>
In-Reply-To: <6689D53B948ACF469C8E9C8CCD48EBE1114EFE01@SINEX14MBXC415.southpacific.corp.microsoft.com>
References: <6689D53B948ACF469C8E9C8CCD48EBE1114EFE01@SINEX14MBXC415.southpacific.corp.microsoft.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        We can see the code in ata_ap_acpi_handle()accesses ap->scsi_host filed without checking if it’s initialized, which causes NULL pointer panic. Meanwhile, ata_pci_sff_activate_host() calls ata_host_register(), which calls ata_scsi_add_hosts() to initialize scsi_host field. Both calls are after ata_host_start() in a must-visit code path. I believe ata_scsi_add_hosts() is the first place for initialization because it does not check if scsi_host field is NULL either. So it makes no sense to access ap->scsi_host in ata_ap_acpi_handle().

This appears to be caused by broken changes to the libata code from
Matthew Garrett and others who introduced a dependancy on scsi_host which
isn't safe to do because drivers can touch the ACPI earlier than the
scsi registration and in fact *NEED* to do so.

Jeff - can we get these patches dropped back out for the moment - they
cause a regression and boot crash in pata_acpi.

The stack from 75d22cd567cac6fe2af8acb33f6ebcd16876d250 needs to get
punted and the scsi_host indirection removed and fixed up for it to work
safely with existing libata drivers.

I don't see an obvious way to fix up the existing ordering dependancies,
especially on the pata_acpi side but if someone has bright ideas there
that would probably be the best choice. Right now these patches stop any
ACPI querying being done during the port setup. We need to do those
queries in order to know if the port can be driven by ACPI and what modes
we can make work.

Alan
