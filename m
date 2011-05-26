Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab1EZRHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:07:45 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57277 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1EZRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:07:43 -0400
Date: Thu, 26 May 2011 22:37:22 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: [RFC Patch 0/6] slimdump: Enable slimdump if crashing kernel memory
 is not required
Message-ID: <20110526170722.GB23266@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find a patchset that implements 'slimdump' - a new type
of coredump (captured through kdump) which will retain only essential
debugging information but will discard old kernel memory (which is mostly
irrelevant) in case of system crashes triggered through fatal hardware errors.

When a system crashes due to an unrecoverable memory error, kdump would
ordinarily attempt to read/capture the crashing kernel's memory which has
the following undesirable consequences:
- The old kernel memory is irrelevant for debugging crashes initiated due
  to hardware errors (such as physical memory corruption causing fatal
  machine check exceptions - MCE).
- The kdump capture kernel might experience a second MCE when attempting
  to read the corrupt memory area having fatal results (and failure to
  capture the coredump).

'slimdump' is particularly useful in avoiding the above hazards. It is a
light-weight dump and increases the reliability of the system by avoiding
unsafe operations.

In essence slimdump enables light-weight coredumps and increases the
reliability of the system by avoiding unsafe operations.

Summary of the patches
----
Patch 1, 2 - Patches from Andi Kleen's tree
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git which
introduce an enhanced panic function - xpanic().

Patch 3 - Introduces a new PANIC_MCE flag to signal the need for
SlimDump for
MCE initiated panic calls.

Patch 4 - Append a new elf-note inside coredump containing MCE related
registers

Patch 5 - Create a SlimDump by discarding old kernel's memory

Patch 6 - Patch for 'crash' tool
(http://people.redhat.com/anderson/crash-5.1.5.tar.gz) to recognise the
new
elf-notes section.

The patches have been tested from inside a VM and have been found to
work fine. The user-space tool used for copying the coredump is 'cp'
(makedumpfile testing will be done soon).

Example
--------
Normal vmcore
-----------
# ls -lh /home/prasadkr/vmcore.usual
-r-------- 1 root root 1.6G May 17 01:07 /home/prasadkr/vmcore.usual

slimdump
-----------
# ls -lh /home/prasadkr/vmcore.SlimDump
-r-------- 1 root root 1.8K May 18 23:28 /home/prasadkr/vmcore.SlimDump
# ./crash vmlinux vmcore.SlimDump

crash 5.1.5
Copyright (C) 2002-2011  Red Hat, Inc.
Copyright (C) 2004, 2005, 2006  IBM Corporation
Copyright (C) 1999-2006  Hewlett-Packard Co
Copyright (C) 2005, 2006  Fujitsu Limited
Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
Copyright (C) 2005  NEC Corporation
Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
This program is free software, covered by the GNU General Public
License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.  Enter "help copying" to see the conditions.
This program has absolutely no warranty.  Enter "help warranty" for
details.

"System crashed due to a hardware memory error. No coredump available."
#
#

Thanks,
K.Prasad
_______________________________________________________
ltcras mailing list ltcras@lists.linux.ibm.com
To unsubscribe from the list, change your list options
or if you have forgotten your list password visit:
http://lists.linux.ibm.com/mailman/listinfo/ltcras
