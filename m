Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab1HVEPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 00:15:08 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:55228 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab1HVEPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 00:15:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reply-To: konrad.wilk@oracle.com
Organization: Oracle
To: Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [PATCH 4/4] kexec/arch/i386: Add get_memory_ranges_xen() function
Date: Mon, 22 Aug 2011 00:01:24 -0400
User-Agent: KMail/1.13.5 (Linux/3.0.0; KDE/4.5.5; i686; ; )
Cc: ian.campbell@citrix.com, vgoyal@redhat.com, horms@verge.net.au,
        olaf@aepfle.de, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110821135459.GE17323@router-fw-old.local.net-space.pl>
In-Reply-To: <20110821135459.GE17323@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108220001.24399.konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> get_memory_ranges_sysfs() and get_memory_ranges_proc_iomem()
> are unreliable under Xen. Proper machine memory map could be
> obtained under Xen by calling __HYPERVISOR_memory_op hypercall
> with XENMEM_machine_memory_map argument. get_memory_ranges_xen()
> does that. It is implemented using ioctl() or libxenctrl interface.
> This solution is compatible with 3.x and 4.x Xen versions.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> ---
>  configure.ac                       |    3 +
>  kexec/arch/i386/kexec-x86-common.c |  203 
++++++++++++++++++++++++++++++++++--
>  2 files changed, 197 insertions(+), 9 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 172a52a..0d09bba 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -157,6 +157,9 @@ if test "$with_xen" = yes ; then
>  	AC_CHECK_HEADER(xenctrl.h,
>  		AC_CHECK_LIB(xenctrl, xc_version, ,
>  		AC_MSG_NOTICE([Xen support disabled])))
> +	if test "$ac_cv_lib_xenctrl_xc_version" = yes ; then
> +		AC_CHECK_FUNCS(xc_get_machine_memory_map)
> +	fi
>  fi
>  
>  dnl ---Sanity checks
> diff --git a/kexec/arch/i386/kexec-x86-common.c b/kexec/arch/i386/kexec-x86-
common.c
> index 8f59c6c..609d35d 100644
> --- a/kexec/arch/i386/kexec-x86-common.c
> +++ b/kexec/arch/i386/kexec-x86-common.c
> @@ -17,6 +17,10 @@
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#define _XOPEN_SOURCE	600
> +#define _BSD_SOURCE
> +
> +#include <fcntl.h>
>  #include <stddef.h>
>  #include <stdio.h>
>  #include <errno.h>
> @@ -24,12 +28,29 @@
>  #include <string.h>
>  #include <limits.h>
>  #include <stdlib.h>
> +#include <stdio.h>
> +#include <sys/ioctl.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
>  #include "../../kexec.h"
>  #include "../../kexec-syscall.h"
>  #include "../../firmware_memmap.h"
>  #include "../../crashdump.h"
>  #include "kexec-x86.h"
>  
> +#ifdef HAVE_LIBXENCTRL
> +#ifdef HAVE_XC_GET_MACHINE_MEMORY_MAP
> +#include <xenctrl.h>
> +#else
> +#define __XEN_TOOLS__	1
> +#include <x86/x86-linux.h>
> +#include <xen/xen.h>
> +#include <xen/memory.h>
> +#include <xen/sys/privcmd.h>
> +#endif /* HAVE_XC_GET_MACHINE_MEMORY_MAP */
> +#endif /* HAVE_LIBXENCTRL */
> +
>  static struct memory_range memory_range[MAX_MEMORY_RANGES];
>  
>  /**
> @@ -129,6 +150,172 @@ static int get_memory_ranges_sysfs(struct memory_range 
**range, int *ranges)
>  	return 0;
>  }
>  
> +#ifdef HAVE_LIBXENCTRL
> +static unsigned e820_to_kexec_type(uint32_t type)
> +{
> +	switch (type) {
> +		case E820_RAM:
> +			return RANGE_RAM;
> +		case E820_ACPI:
> +			return RANGE_ACPI;
> +		case E820_NVS:
> +			return RANGE_ACPI_NVS;
> +		case E820_RESERVED:

For E820_UNUSABLE you want to do that too?

> +		default:
> +			return RANGE_RESERVED;

Or should E820_UNUSABLE returne its own type of RANGE?
> 
