Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab2G0HBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 03:01:51 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55528 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2G0HBu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Fri, 27 Jul 2012 03:01:50 -0400
Message-Id: <501258FB0200007800090DB6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 27 Jul 2012 08:01:47 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <linux-kernel@vger.kernel.org>
Cc: <catalin.marinas@arm.com>, <arnd@arndb.de>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <tim@xen.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: do not compile manage,
 balloon, pci, acpi and cpu_hotplug on ARM
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-10-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1343316846-25860-10-git-send-email-stefano.stabellini@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.07.12 at 17:33, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,11 +1,15 @@
> -obj-y	+= grant-table.o features.o events.o manage.o balloon.o
> +ifneq ($(CONFIG_ARM),y)
> +obj-y	+= manage.o balloon.o

While I assume that this part (and the cpu_hotplug one below) is
temporary, ...

> +obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o

... at least this one should imo be solved with a proper long term
mechanism, i.e. the usual var-$(CONFIG_...) approach, i.e.

dom0-$(CONFIG_PCI) := pci.o
dom0-$(CONFIG_ACPI) := acpi.o
obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)

Jan

> +obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> +endif
> +obj-y	+= grant-table.o features.o events.o
>  obj-y	+= xenbus/
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
>  CFLAGS_features.o			:= $(nostackp)
>  
>  obj-$(CONFIG_BLOCK)			+= biomerge.o
> -obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
>  obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
>  obj-$(CONFIG_XEN_SELFBALLOONING)	+= xen-selfballoon.o
> @@ -17,7 +21,6 @@ obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
>  obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
>  obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
> -obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
> -- 
> 1.7.2.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



