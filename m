Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab2KWJbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:31:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:30563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab2KWJa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:30:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="223381490"
Date: Fri, 23 Nov 2012 11:34:16 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Chris Ball <cjb@laptop.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add SDHCI ACPI driver
Message-ID: <20121123093416.GR3867@intel.com>
References: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
 <87k3tdagim.fsf@octavius.laptop.org>
 <50AE3AB2.2070307@intel.com>
 <3578053.jWYihc5IJI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3578053.jWYihc5IJI@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 10:24:33PM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 22, 2012 04:46:10 PM Adrian Hunter wrote:
> > On 22/11/12 15:55, Chris Ball wrote:
> > > Hi,
> > > 
> > > On Thu, Nov 22 2012, Adrian Hunter wrote:
> > >> Here is SDHCI ACPI driver.  It is dependent on new ACPI Platform support
> > >> so I suggest Rafael takes the patches with Chris' Ack.
> > >>
> > >> Please note that I would prefer this to be queued for 3.8
> > > 
> > > Looks fine:
> > > 
> > > Acked-by: Chris Ball <cjb@laptop.org>
> > 
> > Thank you!
> > 
> > > 
> > > I have some dumb questions, though -- what kind of platforms ship with
> > > these devices?  Do they ever have the controller on PCI too, and what
> > > happens with sdhci-pci vs. sdhci-acpi in that case?
> > 
> > Since the arrival of ACPI5, platform devices can be configured using ACPI
> > tables.  PCI can also be used, but the firmware ensures that the same
> > device is not enumerated via both ACPI and PCI.
> > 
> > Rafael can you take these patches?
> 
> Well, I'd prefer pnpacpi/core.c to actually use acpi_platform_device_ids[]
> directly in addition to excluded_id_list[], so that duplicate entries don't
> have to be added to the both of them.

How about having pnpacpi to check if the ACPI device is already bound to a
physical device and skip the device creation? Then we don't need to expose
the acpi_platform_device_ids[] list, and this is what the ->find_device()
code already does so why create the device in the first place?

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 5b17cc8..4dc2e64 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -243,6 +243,10 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	char *pnpid;
 	struct acpi_hardware_id *id;
 
+	/* Skip devices that are already bound */
+	if (device->physical_node_count)
+		return 0;
+
 	/*
 	 * If a PnPacpi device is not present , the device
 	 * driver should not be loaded.
