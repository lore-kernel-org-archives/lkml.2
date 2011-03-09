Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab1CIRlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:02 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:45467 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab1CIRlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:00 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297036800"; 
   d="scan'208";a="4703512"
Subject: [GIT PATCH 0/14] xen: events: cleanups + ween off nr_irqs
From: Ian Campbell <Ian.Campbell@citrix.com>
To: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 9 Mar 2011 17:40:59 +0000
Message-ID: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series makes a few cleanups to the Xen IRQ infrastructure.
The most important thing is that it removes the need to know about
nr_irqs and in particular the reliance on nr_irqs being static.

Apart from being generally a good thing this is needed because in 2.6.39
nr_irqs will be able to grow dynamically, specifically e7bcecb7b1d2
"genirq: Make nr_irqs runtime expandable" from tip/core/irq is targeted
at 2.6.39.

Dynamically growing nr_irqs also allows us to remove the workaround
which eats into GSI space if a dynamic IRQ cannot be allocated.

There is no ideal sequencing of this series vs e7bcecb7b1d2 (most should
have gone in before, but the penultimate patch really needed to be
simultaneous) so I haven't bothered to try and pull anything from tip
into this branch -- it should all be resolved during the merge window
and bisection won't be too broken since the "eat into GSI space"
workaround only appears to be needed on a small number of older
platforms (qemu being the main exception).

I have tested:
      * Domain 0 on real h/w and under qemu
      * PV guest, including migration and passthrough of both VF and PF.
      * PVHVM guest, including migration and passthrough of both VF and
        PF.

The git pull is a branch on top of konrad/stable/irq.cleanup. However
there is an interaction with konrad/devel/xen-pciback-0.4.driver (the
addition of the domid parameter) so for convenience I have also produced
an irq-pciback branch at the same location which has
konrad/devel/xen-pciback-0.4.driver merged into this branch.

Note that this series obsoletes an older patcho f mine "xen: events:
mark cpu_evtchn_mask_p as __refdata" by virtue of removing the code in
question...

The following changes since commit c5ae07bb307b658c8458f29ca77d237aec0f9327:
  Ian Campbell (1):
        xen: events: remove dom0 specific xen_create_msi_irq

are available in the git repository at:

  git://xenbits.xen.org/people/ianc/linux-2.6.git irq

Ian Campbell (14):
      xen: events: separate two unrelated halves of if condition
      xen: events: fix xen_map_pirq_gsi error return
      xen: events: simplify comment
      xen: events: remove unused public functions
      xen: events: rename restore_cpu_pirqs -> restore_pirqs
      xen: events: refactor GSI pirq bindings functions
      xen: events: use per-cpu variable for cpu_evtchn_mask
      xen: events: turn irq_info constructors into initialiser functions
      xen: events: push setup of irq<->{evtchn,ipi,virq,pirq} maps into irq_info init functions
      xen: events: maintain a list of Xen interrupts
      xen: events: dynamically allocate irq info structures
      xen: events: remove use of nr_irqs as upper bound on number of pirqs
      xen: events: do not workaround too-small nr_irqs
      xen: events: propagate irq allocation failure instead of panicking

 arch/x86/pci/xen.c   |   40 ++++--
 drivers/xen/events.c |  357 ++++++++++++++++++++++++++------------------------
 include/xen/events.h |   24 ++--
 3 files changed, 225 insertions(+), 196 deletions(-)


