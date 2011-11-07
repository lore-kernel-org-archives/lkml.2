Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1KGXXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab1KGXXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:23:30 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 0/4] ACPI: Re-factor and remove
	./drivers/acpi/atomicio.[ch]
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, ying.huang@intel.com,
        bhelgaas@google.com, trenn@suse.de, linux-kernel@vger.kernel.org
Date: Mon, 07 Nov 2011 16:23:21 -0700
Message-ID: <20111107232321.13472.52069.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Late last year I submitted a patch series that re-factored some existing
work that Huang Ying introduced adding support for accessing ACPI
generic registers, backed by Memory Mapped I/O (MMIO), while within
interrupt context:
  Huang Ying's commit 15651291a2f8c11e7e6a42d8bfde7a213ff13262,
  My series: http://marc.info/?l=linux-acpi&m=128769263327206&w=2.

While the impetus of the series was to resolve
https://bugzilla.kernel.org/show_bug.cgi?id=18012, an underlying goal
of the effort was to re-factor ./drivers/acpi/atomicio.c into
./drivers/acpi/osl.c, providing equivalent functinality but in a more
generalized manner, to allow usage in non-specific (i.e. APEI) contexts
and remove atomicio.c.

At that point in time, there was controversy as to the approach that
was being taken concerning APEI.  Due the controversy, all of the
series' re-factoring efforts were taken in except for patch 7/7 which
took the last step of converting over to the new ACPI generic register
capabilities and removing ./drivers/acpi/atomicio.[ch].  As a result,
./drivers/acpi/atomicio.c still exists leaving us with two sets of code
providing similar functionality.

Shortly after the new ACPI generic register capabilities were accepted
upstream Rafael Wysocki submitted a series of subsequent patches which
resolved a couple of bugs and provided a number of optimizations,
especially with respect locking, to the new capabilities.  As mentioned
in the original re-factoring series' preamble ([PATCH 0/7]), some of its
implementation was based upon Huang Ying's original work - specifically
patches 5/7 and 6/7 - and so at least some of the issues that Rafael
addressed in the new capabilities remain unresolved within atomicio.c [*].

This patch series addresses both of these issues - the duplication of
code and likely latent issues that remain within atomicio.c - by
reintroducing patch 7/7 from last year: "Re-factor and remove
./drivers/acpi/atomicio.[ch]".

-v2:
  - Prepended "ACPI: Fix possible alignment issues with GAS 'address'
    references" patch to the series to account for possible alignment
    issues.
  - Split atomicio.[ch] removal patch into two separate patches
      "ACPI APEI: Convert atomicio routines", and
      "ACPI: Remove ./drivers/acpi/atomicio.[ch]"
    to distinguish the more interesting conversion aspects from the
    removal.
  - As part of the conversion patch, I introduced apei_read() and
    apei_write() which currently are functional equivalents of
    acpi_read() and acpi_write().  This is mainly proactive, to
    prevent APEI breakages if acpi_read() and acpi_write() are ever
    augmented to support the 'bit_offset' field of GAS, as APEI's
    __apei_exec_write_register() precludes splitting up functionality
    related to 'bit_offset' and APEI's 'mask' (see its
    APEI_EXEC_PRESERVE_REGISTER block).


[*]  Bug fixes and optimizations that Len and Rafael subsequently provided
to the new ACPI generic register capabilities:
  6d5bbf00..	ACPI: Use ioremap_cache()
  2d6d9fd3..	ACPI: Introduce acpi_os_ioremap()
  884b821f..	ACPI: Fix acpi_os_read_memory() and acpi_os_write_memory()
  7bbb8903..	ACPI: Change acpi_ioremap_lock into a mutex
  7fe135dc..	ACPI: Avoid walking the list of memory mappings in osl.c twice
  7ffd0443..	ACPI: Make acpi_os_map_memory() avoid unnecessary mappings
  b7c1fadd..	ACPI: Do not use krefs under a mutex in osl.c
---

Myron Stowe (4):
      ACPI: Remove ./drivers/acpi/atomicio.[ch]
      ACPI APEI: Convert atomicio routines
      ACPI: Export interfaces for ioremapping/iounmapping ACPI registers
      ACPI: Fix possible alignment issues with GAS 'address' references


 drivers/acpi/Makefile             |    1 
 drivers/acpi/apei/apei-base.c     |  102 ++++++++++
 drivers/acpi/apei/apei-internal.h |    3 
 drivers/acpi/apei/ghes.c          |   10 +
 drivers/acpi/atomicio.c           |  365 -------------------------------------
 drivers/acpi/osl.c                |   40 +++-
 include/acpi/atomicio.h           |   10 -
 include/linux/acpi_io.h           |    3 
 8 files changed, 133 insertions(+), 401 deletions(-)
 delete mode 100644 drivers/acpi/atomicio.c
 delete mode 100644 include/acpi/atomicio.h

-- 
