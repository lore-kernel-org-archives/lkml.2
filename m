Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0JUTSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:18:30 -0400
Received: from mxout1.idt.com ([157.165.5.25]:34682 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab0JUTS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:18:29 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Date: Thu, 21 Oct 2010 15:10:48 -0400
Message-Id: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches are produced as result of the discussion
referenced below:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-September/085829.html
http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-October/086226.html

Switches in RapidIO subsystem are presented the same way as endpoints - by
using rio_dev structure plus an additional switch-specific extension allocated
separately. This separation between two objects describing a RIO switch device
also is reflected in the way how RIO address is stored for endpoints and
switches. Proposed patches are attempt to address issues brought by differences
in endpoint and switch handling in RapidIO subsystem.  

1. Using one storage location common for switches and endpoints eliminates
unnecessary device type checks during maintenance access operations.
While destination IDs and hop counts have different meaning for endpoints and
switches, this does not prevent us from storing them in the primary RIO device
structure (rio_dev) for both types.
The logic that assigns destination IDs to RIO devices stays unchanged - as
before, switches use an associated destination ID because they do not have
their own physical ID. The hop_count is set to 0xff for endpoints and to the
actual value for switches. 

2. Convert RIO switch device structures (rio_dev + rio_switch) into single
allocation unit. This change is based on the fact that RIO switches are using
common RIO device objects anyway. Allocating RIO switch objects as RIO devices
with added space for switch information simplifies handling of RIO switch device
objects.


Alexandre Bounine (2):
  RapidIO: Use common destid storage for endpoints and switches
  RapidIO: Integrate rio_switch into rio_dev

 drivers/rapidio/rio-scan.c          |  139 ++++++++++++++++++-----------------
 drivers/rapidio/rio-sysfs.c         |    4 +-
 drivers/rapidio/rio.c               |   74 ++++++-------------
 drivers/rapidio/switches/idt_gen2.c |   93 ++++++++---------------
 drivers/rapidio/switches/idtcps.c   |    6 +-
 drivers/rapidio/switches/tsi568.c   |   13 +--
 drivers/rapidio/switches/tsi57x.c   |   56 ++++++--------
 include/linux/rio.h                 |   90 +++++++++++------------
 include/linux/rio_drv.h             |   72 +++---------------
 9 files changed, 214 insertions(+), 333 deletions(-)

-- 
1.7.3.1

