Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1GDRKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:10:07 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:58480 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab1GDRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:09:59 -0400
Message-Id: <20110704170922.976299676@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 04 Jul 2011 19:09:22 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: ebiederm@xmission.com, vgoyal@redhat.com, hbabu@us.ibm.com,
        mahesh@linux.vnet.ibm.com
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/9] kdump: Patch series for s390 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds kdump support for the s390 architecture (64 bit). There
are a few common code changes necessary because the s390 implementation is
different to other architectures in some points. Especially these common code
patches (1-7) should be reviewed. Patch 8 "s390: kdump backend code" contains
the s390 specific part. Patch 9 includes the necessary changes for the kexec
tool.

In the following I describe the main differences of the s390 implementation:

The s390 kernel is not relocatable therefore the crashkernel memory is swapped
with the area [0 - crashkernel memory] before the kdump kernel is started.
Architectures other than s390 run the kdump kernel at a memory location that is
disjunct to the standard location for the kernel image and to all memory that
might be in use for I/O by the production system. The main reason for this
seems to be that these architectures do not have a means to clear all ongoing
I/O. If active memory of the production system is reused by the kdump kernel
they run into memory corruption issues. On s390 with diagnose call 308 or boot
(IPL) there is the possibility to stop all ongoing I/O. Therefore we can safely
run the kdump kernel at the old location.

On s390 we do not create page tables for the crashkernel memory and use a
memcpy_real() function to load the kdump kernel and ramdisk in kexec_load()
system call.

On s390 we have external kdump triggers. For example stand-alone dump tools.
The address range information of crashkernel memory is stored at a well defined
storage location that can be used by the external dump triggers to find the
kdump entry point. To export the address range for the crashkernel memory we
introduce a new mechanism that we call meminfo. This allows to define checksum
secured information in memory that is accessible via an s390 ABI defined
storage address. The following information is currently stored via meminfo:
* Crashkernel memory range
* kexec segments for kdump
* Pointer to vmcoreinfo note

Checksums for the loaded kexec segments are stored. This can be used to verify
that kdump is not corrupted. The check is done e.g. by the s390 stand-alone
dump tools via meminfo. If kdump has NOT been overwritten, the checksums are
valid and kdump is started, otherwise a full-blown s390 stand-alone dump is
created as backup dump mechanism.

On s390 the ELF header is created dynamically at kdump startup in the kdump
(2nd) kernel. This is possible, because the memory detection and collection of
the CPU register sets can be done on s390 in the 2nd kernel. Therefore on s390
the ELF header is NOT prepared by the kexec tool. The address for vmcoreinfo
can be found via meminfo and is used by the kdump kernel for ELF header
initialization.

On s390 no additional kernel parameter is needed for kdump. Everything kdump
needs to know can be determined dynamically when the 2nd kernel starts.

If you agree with the approach of this patch series, how should this go
upstream?

Thanks,

Michael
