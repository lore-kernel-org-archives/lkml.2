Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1GHXBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 19:01:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1GHXBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 19:01:19 -0400
MIME-Version: 1.0
Date: Fri, 8 Jul 2011 16:01:17 -0700
Message-ID: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
Subject: ahci_start_engine compliance with AHCI spec
From: Brian Norris <computersforpeace@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am looking into a problem similar to one Jian Peng had, where my
AHCI controller cannot handle ahci_start_engine() requests when its
ports are in the wrong states (BSY/DRQ/PxSSTS.DET==0). As this is
partly an issue of compliance with the AHCI specification, I would
like to find a good fix for this problem that is valid on most
controllers, not requiring a special flag to enable a workaround as
was suggested earlier.

See Jian's patch:
https://lkml.org/lkml/2011/4/23/9

And the regression it caused:
https://lkml.org/lkml/2011/5/11/472

I am able to reproduce the regressions seen by Rafael and Michael on
my Dell Latitude E6410 laptop, in case that's helpful.

I haven't been able to come up with a good generic solution to bring
the driver in line with the AHCI specification. Any comments on this
issue would be helpful, as I'm fairly new to the ATA/AHCI driver
subsystem. I'm looking mainly at the device initialization for AHCI,
via ahci_init_one(), and the eventual ahci_start_engine() call.

What I've found so far:

It seems that at first device initialization on either my Dell E6410
or my special controller, the ahci_start_engine will invariably be
called with the either the BSY or DRQ bit set, depending on whether or
not there is an actual device on the affected port (see stack trace
below). I'm not sure what is causing the device to be requesting data
or busy at this point, but whatever it is causes the device
initialization process to fail (links are *not* up). Instead, we rely
on ahci_error_handler to clean this up, where after a hard reset, the

- ahci_init_one
-- ata_host_activate
--- ata_host_start
---- ahci_port_start
---- ahci_port_resume
----- ahci_start_port
------ ahci_power_up [1]
------ ahci_start_engine (DRQ or BSY *will* be active) [2]

and later

- scsi_error_handler
-- ata_scsi_error
--- ata_scsi_port_error_handler
---- ahci_error_handler
----- sata_pmp_error_handler
------ ata_eh_recover
------- ata_eh_reset
-------- ata_do_reset
--------- ahci_hardreset
---------- ahci_start_engine (DRQ, BSY cleared, link up)

I'm not sure if the "error_handler" and "hard reset" processes are
intended for initialization...as I said I'm a little new!

I have a few other questions:

What operation could be putting devices in DRQ or BSY states during
initialization but before ahci_start_engine?

How much of section 10.1 of the AHCI 1.3 spec applies to our AHCI
driver? Just 10.1.2 or do we have to do the "firmware initialization"
in 10.1.1 as well? Either way, it seems that section 10.10.2 implies
that we need to do some of the "firmware initialization" (because we
use staggered spin-up in ahci_power_up):
"In order to spin up the devices attached to the HBA, software should
perform the procedure outlined in section 10.1.1 for staggered
spin-up."

Then the applicable step from 10.10.1 (step 5):
"Wait for a positive indication that a device is attached to the port
(the maximum amount of time to wait for presence indication is
specified in the Serial ATA Revision 2.6 specification). This is done
by polling PxSSTS.DET. If PxSSTS.DET returns a value of 1h or 3h when
read, then system software shall continue to the next step, otherwise
if the polling process times out system software moves to the next
implemented port and returns to step 1."

I bring up all of this because it seems that if I put some amount of
"wait time" between [1] and [2] above, then my system transitions from
DRQ to BSY and its link is connected (PxSSTS.DET == 0x3). I still
don't know why the device is BSY, but at least it solves my problem...
Perhaps I will try implementing the wait with ata_wait_register (or
maybe ata_wait_ready + ata_phys_link_online) on the PxSSTS.DET flags
and send a patch.

Sorry if this e-mail is too complicated or disorganized. I've been
racking my brain on this one for a few weeks now, and I've only come
up with a few half answers and some more questions. Feel free to ask
for more explanation, but don't worry if I don't respond immediately,
as I am on vacation for all of next week. If I don't get to them
before I leave, I will get to your replies when I return.

Thanks,
Brian
