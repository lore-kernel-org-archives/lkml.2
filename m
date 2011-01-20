Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1ATLiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:38:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab1ATLin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:38:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
Date: Thu, 20 Jan 2011 12:26:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101201226.41021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The following series of patches implements some fixes of the ACPI iomaps
management.  I found the problems trying to resolve the issue of creating
iomaps of regions that have been mapped already when we save the NVS region.

The first two patches are the same as https://patchwork.kernel.org/patch/490071/
(except for the changelog) and https://patchwork.kernel.org/patch/490061/,
respectively, and they are 2.6.38 regression fix material.  The other patches
are not that urgent, because the related issues are generally long-standing,
but some bugs addressed by them (especially [3/11]) may be actively hurting
people right now, so the patches look suitable for .38 to me as well, but this
is your call.

[1/11] - Introduce acpi_os_ioremap() to be called by ACPI code creating
         iomaps, so that they are mapped in the consistent way.

[2/11] - Move the call to suspend_nvs_free() to acpi_pm_finish() so that it's
         executed before device drivers' resume routines to avoid possible
         iomaps conflicts.

[3/11] - Fix routines for reading and writing iomem (RCU bug and mapping
         regions on the fly).

[4/11] - (cleanup) Do not export local functions in osl.c.

[5/11] - Use a mutex (instead of a spinlock) for the locking of iomap
         manipulations in osl.c.

[6/11] - Avoid unnecessary walks of the list of iomaps in osl.c.

[7/11] - Avoid creating iomaps for regions that have been mapped already.

[8/11] - Replace krefs used for iomap refcounting with simple reference
         counters (they are manipulated under a lock anyway).

[9/11] - Introduce function for getting a reference to an ACPI iomap (to be
         used by the NVS save/restore code).

[10/11] - Make the NVS code use existing iomaps if possible.

[11/11] - (cleanup) Remove an unnecessary field from struct nvs_page.

The patches have been tested on HP nx6325, Toshiba Portege R500 and Acer
Ferrari One without causing any visible problems to happen.  Also Jeff has
tested [1/11] and [2/11] and he reports that they fix the synchronize_rcu()
problem for him.  [Jeff, can you test the whole series, please, and see if
it doesn't introduce any new issues, [10/11] in particular?]

Thanks,
Rafael

