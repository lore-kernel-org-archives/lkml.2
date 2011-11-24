Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1KXXDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:03:12 -0500
Received: from ozlabs.org ([203.10.76.45]:44195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1KXXDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:03:10 -0500
Date: Fri, 25 Nov 2011 09:34:10 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, Amerigo Wang <amwang@redhat.com>,
        Kexec-ml <kexec@lists.infradead.org>, Milton Miller <miltonm@bga.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH v5 1/9] fadump: Add documentation for
 firmware-assisted dump.
Message-ID: <20111124223410.GB19828@bloggs.ozlabs.ibm.com>
References: <20111115151145.16533.16384.stgit@mars.in.ibm.com>
 <20111115151334.16533.5790.stgit@mars.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115151334.16533.5790.stgit@mars.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 08:43:34PM +0530, Mahesh J Salgaonkar wrote:
> From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> 
> Documentation for firmware-assisted dump. This document is based on the
> original documentation written for phyp assisted dump by Linas Vepstas
> and Manish Ahuja, with few changes to reflect the current implementation.
> 
> Change in v3:
> - Modified the documentation to reflect introdunction of fadump_registered
>   sysfs file and few minor changes.
> 
> Change in v2:
> - Modified the documentation to reflect the change of fadump_region
>   file under debugfs filesystem.

In general we don't want the changes between successive versions in
the patch description; this information should go below the "---"
line.  The patch description should describe how the patch is now and
give any information that will be useful to someone looking at the
resulting git commit later on, but it doesn't need to tell us about
previous versions of the patch that will never appear in the git
history.

> +-- Once the dump is copied out, the memory that held the dump
> +   is immediately available to the running kernel. A further
> +   reboot isn't required.

I have a general worry about the system making allocations that are
intended to be node-local while it is running with restricted memory
(i.e. after the crash and reboot and before the dump has been written
out and the dump memory freed).  Those allocations will probably all
come from one node and thus won't necessarily be on the desired node.
So, for very large systems with significant NUMA characteristics, it
may be desirable (though not required) to reboot after taking the
dump.

What happens about the NUMA information in the kernel -- all the
memory sections, etc.?  Do they get set up as normal even though the
second kernel is booting with only a small amount of memory initially?

> + /sys/kernel/debug/powerpc/fadump_region
> +
> +    This file shows the reserved memory regions if fadump is
> +    enabled otherwise this file is empty. The output format
> +    is:
> +    <region>: [<start>-<end>] <reserved-size> bytes, Dumped: <dump-size>
> +
> +    e.g.
> +    Contents when fadump is registered during first kernel
> +
> +    # cat /sys/kernel/debug/powerpc/fadump_region
> +    CPU : [0x0000006ffb0000-0x0000006fff001f] 0x40020 bytes, Dumped: 0x0
> +    HPTE: [0x0000006fff0020-0x0000006fff101f] 0x1000 bytes, Dumped: 0x0
> +    DUMP: [0x0000006fff1020-0x0000007fff101f] 0x10000000 bytes, Dumped: 0x0

How come the HPTE region is only 0x1000 (4k) bytes?  The hashed page
table (HPT) will be much bigger than this.  Is this our way of telling
the hypervisor that we don't care about the HPT?  If so, is it
possible to make this region 0 bytes instead of 0x1000?

Paul.
