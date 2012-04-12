Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2DLLat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:30:49 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56677 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab2DLLas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:30:48 -0400
Date: Thu, 12 Apr 2012 07:30:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: reasonable for a Kconfig variable to be tested only for "_MODULE"?
Message-ID: <alpine.DEB.2.02.1204120725070.17806@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  playing with my cleanup scripts this morning and ran across this
output looking for unused CONFIG_ variables under drivers/ata:

$ ../s/find_unused_configs.sh drivers/ata
===== PATA_QDI
drivers/ata/Kconfig:831:config PATA_QDI
===== PATA_WINBOND_VLB
drivers/ata/Kconfig:865:config PATA_WINBOND_VLB
$

  normally, i would flag that as "variables that are defined in a
Kconfig file but are never tested anywhere", but upon further
examination:

$ $ grep -r PATA_QDI *
drivers/ata/Kconfig:config PATA_QDI
drivers/ata/pata_legacy.c:#ifdef CONFIG_PATA_QDI_MODULE
$

so "CONFIG_PATA_QDI" isn't tested, but "CONFIG_PATA_QDI_MODULE" *is*,
which is not something i'd considered.  the Kconfig entry:

config PATA_QDI
        tristate "QDI VLB PATA support"
        depends on ISA
        select PATA_LEGACY
        help
          Support for QDI 6500 and 6580 PATA controllers on VESA local bus.

and the relevant source:

/* Set to probe QDI controllers */
#ifdef CONFIG_PATA_QDI_MODULE
static int qdi = 1;
#else
static int qdi;
#endif

  is that combination reasonable?  to test *only* for
"CONFIG_whatever_MODULE"?  if it is, i'll add that check to avoid
reporting false positives.

  all of the above can be said for PATA_WINBOND_VLB as well.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================


