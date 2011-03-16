Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab1CPQFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:05:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25544 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1CPQF3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Mar 2011 12:05:29 -0400
Date: Wed, 16 Mar 2011 12:05:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>, dkiper@net-space.pl,
        dgdegra@tycho.nsa.gov,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/hvc-console, stable/backends,
 stable/gntalloc.v6, and stable/balloon for 2.6.39
Message-ID: <20110316160514.GB18433@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D80DFBE.0031,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull these four branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/hvc-console stable/backends stable/gntalloc.v6 stable/balloon

Or you can take #for-2.6.39/drivers branch which has these four merges
for your convience (there are no conflicts).

The best way to do this pull is to do it in two stages:

 1). git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/hvc-console
 2)  git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/backends stable/gntalloc.v6 stable/balloon

Otherwise you would get this strange error:
Simple merge did not work, trying automatic merge.
ERROR: drivers/char/hvc_xen.c: Not handling case 3740e327f1802f0e63bd1cdffba4107cbbf55c7e ->  -> c35f1a73bc8bca281ccea8ee7e87eb6b534b0b11

which is b/c the hvc-xen code changed its location.

Back to the description.

#stable/hvc-console is based off v2.6.38-rc8 (a5abba989deceb731047425812d268daf7536575)

.. and has a bug-fix for a rare race condition when using a serial output with
Xen hypervisor.

#stable/backends is based off v2.6.38-rc2 (1bae4ce27c9c90344f23c65ea6966c50ffeae2f5)

.. provides an mechanism for backend drivers to request an IRQ to listen when
the frontend has important data to be ingested. Most if not all of the Xen
backends use this and those backends are going through the review cycle now
so this lays out the infrastructure for them.

#stable/gntalloc.v6 is based off v2.6.38-rc4 (100b33c8bd8a3235fd0b7948338d6cbb3db3c63d)

.. and provides a driver (gntalloc) for Xen guests to communicate with each
other via pages. The driver sets up mmap-based pages via ioctls which allows those pages
to be shared with another guest. There is also a notification system built in
so that the applications don't have to pull the page constantly to find out what
is new. There are multiple use cases, but the most common is to for one guest 
to own a frame-buffer while other ones can get access to it if they are running
in "foreground". 

#stable/balloon is based off #stable/gntalloc.v6

.. and provides a cleanup of the balloon driver, and also two extra API calls to get/put
pages. That get/put mechanism is used by the gntdev driver for it to get and put pages
that are to be shared with another domain. While it is a nice pool type interface it also
fixes a work-around for broken versions of Xen hypervisors that would "forget" to give us
the shared page back to our domain.

The diffstat:

 arch/x86/xen/mmu.c        |    3 +-
 drivers/tty/hvc/hvc_xen.c |    2 +
 drivers/xen/Kconfig       |   10 +
 drivers/xen/Makefile      |    6 +-
 drivers/xen/balloon.c     |  359 +++++++++++-------------------
 drivers/xen/events.c      |   38 +++
 drivers/xen/gntalloc.c    |  545 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/xen/gntdev.c      |  382 +++++++++++++++++++------------
 drivers/xen/grant-table.c |   10 +
 drivers/xen/xen-balloon.c |  256 +++++++++++++++++++++
 include/xen/balloon.h     |   25 ++
 include/xen/events.h      |    6 +
 include/xen/gntalloc.h    |   82 +++++++
 include/xen/gntdev.h      |   31 +++
 14 files changed, 1369 insertions(+), 386 deletions(-)

Daniel De Graaf (16):
      xen-gntdev: Change page limit to be global instead of per-open
      xen-gntdev: Use find_vma rather than iterating our vma list manually
      xen-gntdev: Add reference counting to maps
      xen-gntdev: Support mapping in HVM domains
      xen-gntalloc: Userspace grant allocation driver
      xen/gntalloc,gntdev: Add unmap notify ioctl
      xen-gntdev: Fix memory leak when mmap fails
      xen-gntdev: Fix unmap notify on PV domains
      xen-gntdev: Use map->vma for checking map validity
      xen-gntdev: Avoid unmapping ranges twice
      xen-gntdev: Avoid double-mapping memory
      xen-gntdev: prevent using UNMAP_NOTIFY_CLEAR_BYTE on read-only mappings
      xen-gntdev: Fix incorrect use of zero handle
      xen-gntdev: Add cast to pointer
      xen-balloon: Move core balloon functionality out of module
      xen-gntdev: Use ballooned pages for grant mappings

Daniel Kiper (3):
      xen/balloon: Removal of driver_pages
      xen/balloon: Migration from mod_timer() to schedule_delayed_work()
      xen/balloon: Protect against CPU exhaust by event/x process

Ian Campbell (3):
      xen/irq: implement bind_interdomain_evtchn_to_irqhandler for backend drivers
      xen/p2m/m2p/gnttab: do not add failed grant maps to m2p override
      xen: gntdev: fix build warning

Konrad Rzeszutek Wilk (3):
      xen/hvc: Disable probe_irq_on/off from poking the hvc-console IRQ line.
      xen/balloon: Remove pr_info's and don't alter retry_count
      xen-balloon: Add interface to retrieve ballooned pages

Stefano Stabellini (1):
      xen: change xen/[gntdev/gntalloc] to default m

