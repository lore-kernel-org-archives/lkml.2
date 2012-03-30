Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960Ab2C3O22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:28:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51065 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760262Ab2C3O2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:28:23 -0400
Date: Fri, 30 Mar 2012 10:28:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@amd.com>
cc: Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
In-Reply-To: <20120330010730.GA27346@ladygaga>
Message-ID: <Pine.LNX.4.44L0.1203301021140.1280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Aaron Lu wrote:

> > > For the ODD to be put into suspend state, the conditions should be:
> > > 1 tray closed
> > > 2 no media inside
> > > I think we missed the condition 1 check now.
> > > 
> > > And if we follow the two conditions, the events can be safely ignored.
> > 
> > No, they can't.  Otherwise the device won't power back up when the user 
> > inserts a new disc.
> > 
> 
> The ODD is put to zero power state, so it can't react to the eject
> button without being powered up back first ;-)
> On current implementation, ACPI is used to power back up the ODD like this:
> 1 User press the eject button;
> 2 A gpe event fired, and ACPI interrupt, and the corresponding gpe
> handler runs and the ODD's ACPI handle is notified about DEVICE_WAKE_UP;
> 3 In ODD's acpi notify handler, we power back up it by scsi_autopm_get_device.
> This is handled in the following Lin Ming's patch:
> [PATCH v3 2/7] libata-acpi: add ata port runtime D3Cold support

I see.  Then you are right; it's not necessary to check for events 
while the drive is at zero power.

> When the ODD is put to zero power state, it will not be able to handle
> commands like CDROMEJECT. We have to power it up first and then handle
> the ioctl request. Currently, we only power back up the ODD when user
> press the eject button as explained above.

Then you may want to avoid going to zero-power while a program is
holding the device file open.  After all, the program might issue a
CDROMEJECT ioctl.

Alan Stern

