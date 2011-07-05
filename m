Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1GEU0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab1GEU03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:26:29 -0400
Date: Tue, 5 Jul 2011 16:26:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110705202615.GJ24348@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704170922.976299676@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 07:09:22PM +0200, Michael Holzheu wrote:
> This patch series adds kdump support for the s390 architecture (64 bit). There
> are a few common code changes necessary because the s390 implementation is
> different to other architectures in some points. Especially these common code
> patches (1-7) should be reviewed. Patch 8 "s390: kdump backend code" contains
> the s390 specific part. Patch 9 includes the necessary changes for the kexec
> tool.
> 
> In the following I describe the main differences of the s390 implementation:
> 
> The s390 kernel is not relocatable therefore the crashkernel memory is swapped
> with the area [0 - crashkernel memory] before the kdump kernel is started.
> Architectures other than s390 run the kdump kernel at a memory location that is
> disjunct to the standard location for the kernel image and to all memory that
> might be in use for I/O by the production system. The main reason for this
> seems to be that these architectures do not have a means to clear all ongoing
> I/O. If active memory of the production system is reused by the kdump kernel
> they run into memory corruption issues. On s390 with diagnose call 308 or boot
> (IPL) there is the possibility to stop all ongoing I/O. Therefore we can safely
> run the kdump kernel at the old location.
> 
> On s390 we do not create page tables for the crashkernel memory and use a
> memcpy_real() function to load the kdump kernel and ramdisk in kexec_load()
> system call.
> 
> On s390 we have external kdump triggers. For example stand-alone dump tools.
> The address range information of crashkernel memory is stored at a well defined
> storage location that can be used by the external dump triggers to find the
> kdump entry point. To export the address range for the crashkernel memory we
> introduce a new mechanism that we call meminfo. This allows to define checksum
> secured information in memory that is accessible via an s390 ABI defined
> storage address. The following information is currently stored via meminfo:
> * Crashkernel memory range
> * kexec segments for kdump
> * Pointer to vmcoreinfo note

I don't understand what is stand-alone dump tools and why the existing
mechanism of preparing ELF headers to describe all the above info
and just passing the address of header on kernel commnad line
(crashkernel=) will not work for s390. Introducing an entirely new
infrastructure for communicating the same information does not
sound too exciting.

Thanks
Vivek
