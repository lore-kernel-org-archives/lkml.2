Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab1K3RVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:21:52 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43171 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1K3RVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:21:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com
Subject: [RFC PATCH] Exporting ACPI Pxx/Cxx states to other kernel subsystems (v1).
Date: Wed, 30 Nov 2011 12:20:56 -0500
Message-Id: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4ED66623.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following patches are a solution to a problem we have encountered
when using the Xen hypervisor:
 - Need Pxx/Cxx states to save on power consumption when using Xen (we
   do want those datacenters to consume less power!),
 - Also need to figure out the Turbo mode so that the scheduler can properly
   boost a core for CPU bound guests.

In essence the Xen hypervisor requires that information to work efficiently.

There are some other ways of solving this problem as well that have
been tossed around. I am enumerating them here, but I don't have the
full records of the disadvantages/advantges so hopefully some other people
can chime in.
 - Parse the information in userspace. I am not really sure how that would
   work, but one thought was export in SysFS the Pxx/Cxx states and other ones
   (hand-waving here) and the libvirt/xend/xl toolstack would parse those as
   needed and push them up (say when the guest is started). But it does have
   a disadvantage that it would not work well with CPU hotplug, nor with the
   physical CPU != virtual CPU discountinty (that is Linux sees only one CPU,
   and the ACPI Pxx says there are eight of them - with different values than
   the CPU0).
 - Make the ACPI subsystem export some of this functionality so that there
   can be multiple ACPI processor drivers and they can share common code.
   This is what this patch series follows. This does mean exporting some
   ACPI "stuff" outside drivers/acpi. 
 - Implement the ACPI DSDT parsing in the hypervisor. The couple of reasons
   that pop in my head for not going that route is foremost it seems an
   overkill just so that this specific information (Pxx/Cxx) can pushed in
   the hypervisor.  We already use the Linux ACPI to figure out the IRQ routing,
   or for ACPI states changes like button pushing, docking events, etc.
   Making it all be done in the hypervisor seems well, an overkill.

The original authors of the code are Intel folks. Liang has been working
on this to see if the abstraction can be improved, but I am by no means
an ACPI expert - so feedback, guidance or input would be much appreciated.


Liang:
 ACPI: processor: Don't setup cpu idle driver and handler

I think it can be actually dropped - now that disable_cpuidle() functionality
exists and we use it? 

Kevin Tian (6):
      ACPI: processor: export necessary interfaces
      ACPI: processor: cache acpi_power_register in cx structure
      ACPI: processor: Don't setup cpu idle driver and handler when we do not want them.
      ACPI: add processor driver for Xen virtual CPUs.
      ACPI: xen processor: add PM notification interfaces.
      ACPI: xen processor: set ignore_ppc to handle PPC event for Xen vcpu.

Tang Liang (2):
      ACPI: processor: add __acpi_processor_[un]register_driver helpers.
      ACPI: processor: override the interface of register acpi processor handler for Xen vcpu

 drivers/acpi/Makefile            |    1 +
 drivers/acpi/processor_driver.c  |   48 +++++--
 drivers/acpi/processor_idle.c    |   10 +-
 drivers/acpi/processor_perflib.c |    6 +-
 drivers/acpi/processor_xen.c     |  246 ++++++++++++++++++++++++++++++++++
 drivers/xen/Kconfig              |    5 +
 drivers/xen/Makefile             |    3 +
 drivers/xen/acpi_processor.c     |  269 ++++++++++++++++++++++++++++++++++++++
 include/acpi/processor.h         |   20 +++-
 include/xen/acpi.h               |  104 +++++++++++++++
 10 files changed, 690 insertions(+), 22 deletions(-)
