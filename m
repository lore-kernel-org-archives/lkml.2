Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2JVXpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:45:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2JVXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:45:39 -0400
Date: Mon, 22 Oct 2012 16:45:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 2/5] ACPI: Reorder IPMI driver before any other ACPI
 drivers
Message-Id: <20121022164538.3b707397.akpm@linux-foundation.org>
In-Reply-To: <1350420820-7156-3-git-send-email-minyard@acm.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
	<1350420820-7156-3-git-send-email-minyard@acm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 15:53:37 -0500
minyard@acm.org wrote:

> From: Matthew Garrett <mjg@redhat.com>
> 
> Drivers may make calls that require the ACPI IPMI driver to have been
> initialised already, so make sure that it appears earlier in the build
> order.
> 
> ...
>
> index 47199e2..82422fe 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -47,6 +47,10 @@ acpi-y				+= video_detect.o
>  endif
>  
>  # These are (potentially) separate modules
> +
> +# IPMI may be used by other drivers, so it has to initialise before them
> +obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
> +
>  obj-$(CONFIG_ACPI_AC) 		+= ac.o
>  obj-$(CONFIG_ACPI_BUTTON)	+= button.o
>  obj-$(CONFIG_ACPI_FAN)		+= fan.o
> @@ -70,6 +74,5 @@ processor-y			+= processor_idle.o processor_thermal.o
>  processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
>  
>  obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
> -obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
>  
>  obj-$(CONFIG_ACPI_APEI)		+= apei/

Relying upon link ordering is the old-fashioned way of doing things,
and I have vague memories that it only works by luck - that there's no
hard-and-fast rule that the linker has to obey what we think we asked
it to do.

The usual way of doing this sort of thing is to use the initcall
priority levels - core_initcall(), postcore_initcall(), etc.  Can that
be done here?

