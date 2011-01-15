Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1AOEYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 23:24:43 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:61498 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1AOEYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 23:24:42 -0500
Date: Fri, 14 Jan 2011 23:24:27 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Andres Salomon <dilinger@queued.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] ACPI: don't attempt to use hest_tab unless
 !acpi_pci_disabled
In-reply-to: <20110114181620.188e7a62@queued.net>
Message-id: <alpine.LFD.2.02.1101142310240.2551@x980>
References: <20110114181620.188e7a62@queued.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've hit the following oops on boot on an XO-1 with current linus git:
> 
> [    0.662755] BUG: unable to handle kernel NULL pointer dereference at 00000024
> [    0.666349] IP: [<c11a0514>] apei_hest_parse+0xbc/0xcc
> [    0.666349] *pde = 00000000
> [    0.666349] Oops: 0000 [#1] SMP
> [    0.666349] last sysfs file:
> [    0.666349] Modules linked in:
> [    0.666349]
> [    0.666349] Pid: 1, comm: swapper Not tainted 2.6.37+ #74 /
> [    0.666349] EIP: 0060:[<c11a0514>] EFLAGS: 00010206 CPU: 0
> [    0.666349] EIP is at apei_hest_parse+0xbc/0xcc
> [    0.666349] EAX: 00000028 EBX: 00000000 ECX: 00000000 EDX: 00000000
> [    0.666349] ESI: 00000001 EDI: 00000000 EBP: c1161171 ESP: cb441fa8
> [    0.666349]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    0.666349] Process swapper (pid: 1, ti=cb440000 task=cb43c000 task.ti=cb440000)
> [    0.666349] Stack:
> [    0.666349]  c1450960 00000001 00000020 c141fa10 c11611aa c141fa1e c1001151 00000000
> [    0.666349]  c1450960 00000001 00000020 00000000 c1401346 00000000 c1401221 00000000
> [    0.666349]  c10034be 00000000 00000000 00000000 00000000 00000000
> [    0.666349] Call Trace:
> [    0.666349]  [<c141fa10>] ? aer_service_init+0x0/0x22
> [    0.666349]  [<c11611aa>] ? aer_acpi_firmware_first+0x15/0x22
> [    0.666349]  [<c141fa1e>] ? aer_service_init+0xe/0x22
> [    0.666349]  [<c1001151>] ? do_one_initcall+0x68/0x10f
> [    0.666349]  [<c1401346>] ? kernel_init+0x125/0x19d
> [    0.666349]  [<c1401221>] ? kernel_init+0x0/0x19d
> [    0.666349]  [<c10034be>] ? kernel_thread_helper+0x6/0x10
> [    0.666349] Code: 76 18 0f b7 40 02 50 68 c2 ae 35 c1 e8 3e e8 0f 00 b8 ea ff ff ff 59 5b eb 1c 89 fa ff d5 85 c0 75 14 89 f0 43 8b 0d 50 ed 3f c1 <3b> 59
>  24 0f 82 64 ff ff ff 31 c0 5b 5e 5f 5d c3 8b 50 0c 8d 4a
> 
> The apei_hest_parse function is using hest_tab, which hasn't been initialized.
> This is because acpi_hest_init has never been called (as acpi_pci_disabled is 1,
> so it never gets called from acpi_pci_root_init), and hest_disabled is never
> set to 1.  When the aer_driver calls apei_hest_parse, the hest_disabled check
> passes, and it oopses processing hest_tab.  Note that the aer code that
> calls apei_hest_parse was added in commit b22c3d82.
> 
> This patch causes apei_hest_parse to check both hest_disabled and
> acpi_pci_disabled before continuing.  With it, the XO-1 boots properly.

The X0-1 has no ACPI support, and thus you are running
with acpi_disabled=1, yes?

It would be better for the fix to depend on acpi_disabled.
acpi_disbled=1 is a supported configuration, while
acpi_pci_disabled is a just a debug flag, maybe someday
it will go away.

Looks like acpi_hest_init() bails for acpi_disabled,
and thus hest_ghes_dev_register()doens't run and invoke
apei_hest_parse(), so we are set there.

Seems like drivers/pci/pcie/aer/aerdrv_acpi.c,
should not invoke apei_hest_parse() when acpi_disabled=1.
Either that or we have to have apei_hest_parse(),
which is exported to modules check acpi_disabled --
and its callers need to check for failure.

thanks,
-Len Brown, Intel Open Source Technolgy Center

> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/acpi/apei/hest.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
> index 4ee58e7..2b8c355 100644
> --- a/drivers/acpi/apei/hest.c
> +++ b/drivers/acpi/apei/hest.c
> @@ -89,7 +89,7 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
>  	struct acpi_hest_header *hest_hdr;
>  	int i, rc, len;
>  
> -	if (hest_disable)
> +	if (hest_disable || acpi_pci_disabled)
>  		return -EINVAL;
>  
>  	hest_hdr = (struct acpi_hest_header *)(hest_tab + 1);
> -- 
> 1.7.2.3
> 
