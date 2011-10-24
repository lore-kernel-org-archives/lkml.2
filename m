Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab1JXNPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:15:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50278 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab1JXNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:14:59 -0400
Date: Mon, 24 Oct 2011 08:55:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: dario.faggioli@citrix.com, stefano.stabellini@eu.citrix.com,
        dan.magenheimer@oracle.com, dgdegra@tycho.nsa.gov
Subject: [GIT PULL] (xen) stable/bug.fixes-3.2 and stable/mmu.fixes for Linux
 3.2-rc0
Message-ID: <20111024125542.GB19100@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EA56316.002B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please pull the following two branches:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/bug.fixes-3.2 stable/mmu.fixes

which contain bug-fixes to various subsystems in Xen. I am not too thrilled
that this GIT pull is all over the place, but sadly that is the nature of some
bug fixes. I could split this up in small branches but not sure whether that would
be worth it?

Anyhow, there are two branches, wherein:

#stable/bug.fixes-3.2 is based of commit a102a9ece5489e1718cd7543aa079082450ac3a2 (Linux 3.1-rc8)
and contains bug fixes found when I ran the static analyzer tool "smatch".
Most of the bugs were for the error logic path - so I am quite happy that those
are fixed now.

#stable/mmu.fixes is based of commit 322a8b034003c0d46d39af85bf24fee27b902f48 (Linux 3.1-rc1)
and contains fixes to the Xen debugfs - one attribute got lost when Jeremy did the
move from home-grown tracing to using the tracing API. Another fix is to remove
a CONFIG_DEBUG option that was causing more grief that neccessary - so removing it.

The more serious bug-fixes are in the grant mechanism - Stefano found out that when
QEMU is mapping user pages and using AIO, the kernel AIO subsystem also maps those pages.
Which in effect means that there are two page mappings for a guest page - in the
userland and in the kernel. The grant table mechanism only dealt with the
userland pages so AIO ended up getting garbage.

We also fix a sleep-inside-spinlock bug and the self-ballooning mechanism
(it was squeezing the kernel too much causing an OOM).

Anyhow, the credit list is as follow:

Dan Magenheimer (1):
      xen: Fix selfballooning and ensure it doesn't go too far

Daniel De Graaf (1):
      xen/gntdev: Fix sleep-inside-spinlock

Konrad Rzeszutek Wilk (10):
      Revert "xen/debug: WARN_ON when identity PFN has no _PAGE_IOMAP flag set."
      xen/p2m: Make debug/xen/mmu/p2m visible again.
      xen/p2m: Use SetPagePrivate and its friends for M2P overrides.
      xen/events: BUG() when we can't allocate our event->irq array.
      xen/events: Don't check the info for NULL as it is already done.
      xen/irq: If we fail during msi_capability_init return proper error code.
      xen/xenbus: Remove the unnecessary check.
      xen/enlighten: Fix compile warnings and set cx to known value.
      xen/p2m/debugfs: Fix potential pointer exception.
      xen/p2m/debugfs: Make type_name more obvious.

Stefano Stabellini (2):
      xen: add an "highmem" parameter to alloc_xenballooned_pages
      xen: modify kernel mappings corresponding to granted pages

 arch/x86/include/asm/xen/page.h           |    6 +-
 arch/x86/pci/xen.c                        |   10 ++-
 arch/x86/xen/Kconfig                      |    8 --
 arch/x86/xen/enlighten.c                  |    1 +
 arch/x86/xen/mmu.c                        |   52 ------------
 arch/x86/xen/p2m.c                        |  128 ++++++++++++++++++++++++----
 drivers/block/xen-blkback/blkback.c       |    2 +-
 drivers/xen/balloon.c                     |   12 ++-
 drivers/xen/events.c                      |   10 ++-
 drivers/xen/gntdev.c                      |   39 ++++++++-
 drivers/xen/grant-table.c                 |    6 +-
 drivers/xen/xen-selfballoon.c             |   67 ++++++++++++++-
 drivers/xen/xenbus/xenbus_probe_backend.c |    2 -
 include/xen/balloon.h                     |    5 +-
 include/xen/grant_table.h                 |    1 +
 15 files changed, 238 insertions(+), 111 deletions(-)

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpWBOAAoJEFKFlzJcLqlYOtcP/0YHXDh0OZMsqIxtK96Uk9fX
FBltYf3c7SbREWQgICNlnStk1bkgY5h38WzA8Iv3MyN2S978Umest3qL3GDls3ms
/Djmo/oBcHEsyG48rLbkIozPpd+36SDKlhOWGkxyjAaKvEApjnuRTHWCosxATULs
I/8hNkVjKwSp6g8iIg4u6qCkzDkOmnS1XAHCG9HZFhb+teehwaf3QH9Q2zBBe9Tw
0v5pDPWUIHmXPtv5ZHnqMrCMK3TtqTSoUd8qIPsf+RJNBrIEC+ZUSYRx8ZPytdDZ
as9DCp8rEVkXbqGG2JGvwqWBOpw1Aw9owvx2rNFopanyTdn1fZqEyeFIgDlzwUxD
0OkWihvOGd26njPkEOp0/aWIDoHVUi+8gZDwDC+bLJ0RHqN+qRg8jbIcYlZpM8NL
u7zZfQ++UksC0rcAmTKMoAxA4T3BCaniw4gT+N479XC31v8yT2ZhUvbW2JB5Dskl
i8zRm4mdB1YLEMWYpsyqcVfYOy3kw+2Mr6HUVCiwWhzgH/WYsPRr9K6V/lkjFy8H
dMoc9SstFF3+emmq6Z1qwHsNWFkt8WE2R/wp96bBr5r9y/v3t36DweN426ywJciG
gVVyNh1X2P6gsgnD9FxF3HTZ/sn3nio9yyuXJcsKSB+J0Jni+3scpvg2bMtuu7/n
AfgQwKkz8+ZBg5VecGbc
=iqBi
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
