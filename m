Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2FWVRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:17:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab2FWVRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/21] ACPI / PM: Switch ACPI bus type and drivers to dev_pm_ops
Date: Sat, 23 Jun 2012 23:06:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206232306.06602.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following patchset converts the ACPI bus type and all of the ACPI drivers
to the power management handling based on struct dev_pm_ops.  It does that in
the following way:

(1) The (unused) pm_message_t argument is dropped from the ACPI driver suspend
    callback throughout the tree (patch [1/21]).

(2) A struct dev_pm_ops object is defined for the ACPI bus type (patches
    [2-3/21]) in such a way that
    (a) driver callbacks from struct acpi_device_ops are executed for drivers
        that provide them,
    (b) driver callbacks from struct dev_pm_ops are executed for drivers that
        provide them,
    (c) 0 is returned for the remaining drivers.
    Only suspend/resume, freeze/thaw, poweroff/restore bus type callbacks are
    defined, because they are sufficient for the transition (they are removed
    later on anyway).

(3) All ACPI drivers that use PM callbacks are converted to the PM handling
    based on struct dev_pm_ops (patches [4-18/21]).

(4) The ACPI bus type is modified not to execute driver callbacks from
    struct acpi_device_ops any more (patch [19/21]).  This affects several
    x86 platform drivers and the ACPI power meter driver too.

(5) The driver PM callbacks in struct acpi_device_ops are removed
    (patch [20/21]).

(6) The ACPI bus type PM callbacks added in step (2) are dropped, because they
    aren't necessary any more (the PM core will execute the driver callbacks
    directly now).

As a result, the redundant bus type level of PM handling between ACPI drivers
and the PM core is eliminated and the ACPI drivers are now able to define
runtime PM callbacks, proper hibernation callbacks and late/early callbacks
for system suspend/resume.

The patchset has been tested on Toshiba Portege R500 and more testing is in
the works.  If there are no objections, I'd like to push if for 3.6 through
the linux-pm tree.

If you want to give it a go, it's available from the pm-acpi branch of the
linux-pm tree.  Please note, however, that this branch will be rebased, because
it is based on the linux-pm tree's linux-next branch at the moment.

Thanks,
Rafael

