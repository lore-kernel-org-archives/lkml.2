Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0KERbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:31:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab0KERbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:31:02 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] vfio: virtualize INTX_DISABLE
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com
Date: Fri, 05 Nov 2010 11:30:15 -0600
Message-ID: <20101105171624.1638.33349.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom,

Since we use INTX_DISABLE internally for PCI 2.3 devices, it's probably
not a good idea to allow vfio users direct access to it.  In trying to
virtualize it, I stumbled on some config space virtualization issues.
I think we want vconfig and the value written to hardware to be different
when there are virtualized bits, but we lump them together.  I think this
is why I've never been able to rely on the memory enable bit of config
space through vfio.  With this first patch, all virtualized bits that
are writable are sticky in vconfig.  Non-writable bits come from either
the old value or the physical hardware depending on whether it's
virtualized.  This means we can get rid of a lot of duplicated setting
and reading of vconfig, and only add code for more complicated
behaviors.  This is tricky code, to please double check that I'm not
doing something stupid.  Thanks,

Alex

---

Alex Williamson (2):
      vfio: Virtualize PCI_COMMAND_INTX_DISABLE
      vfio: Fix config space virtualization


 drivers/vfio/vfio_intrs.c      |   38 ++++++++----
 drivers/vfio/vfio_main.c       |   14 ++++
 drivers/vfio/vfio_pci_config.c |  131 ++++++++++++----------------------------
 include/linux/vfio.h           |    4 +
 4 files changed, 84 insertions(+), 103 deletions(-)

-- 
