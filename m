Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2ISOyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:54:54 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36858 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2ISOyv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 19 Sep 2012 10:54:51 -0400
Message-Id: <5059F8D8020000780009C5CD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 19 Sep 2012 15:54:48 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <stable@kernel.org>, "xen-devel" <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/boot: Disable BIOS SMP MP table
 search.
References: <1348061269-19133-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1348061269-19133-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.09.12 at 15:27, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> As the initial domain we are able to search/map certain regions
> of memory to harvest configuration data. For all low-level we
> use ACPI tables - for interrupts we use exclusively ACPI _PRT
> (so DSDT) and MADT for INT_SRC_OVR.
> 
> The SMP MP table is not used at all. As a matter of fact we do
> not even support machines that only have SMP MP but no ACPI tables.
> 
> Lets follow how Moorestown does it and just disable searching
> for BIOS SMP tables.
> 
> This also fixes an issue on HP Proliant BL680c G5 and DL380 G6:
> 
> 9f->100 for 1:1 PTE
> Freeing 9f-100 pfn range: 97 pages freed
> 1-1 mapping on 9f->100
> .. snip..
> e820: BIOS-provided physical RAM map:
> Xen: [mem 0x0000000000000000-0x000000000009efff] usable
> Xen: [mem 0x000000000009f400-0x00000000000fffff] reserved
> Xen: [mem 0x0000000000100000-0x00000000cfd1dfff] usable
> .. snip..
> Scan for SMP in [mem 0x00000000-0x000003ff]
> Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> Scan for SMP in [mem 0x000f0000-0x000fffff]
> found SMP MP-table at [mem 0x000f4fa0-0x000f4faf] mapped at [ffff8800000f4fa0]
> (XEN) mm.c:908:d0 Error getting mfn 100 (pfn 5555555555555555) from L1 entry 
> 0000000000100461 for l1e_owner=0, pg_owner=0
> (XEN) mm.c:4995:d0 ptwr_emulate: could not get_page_from_l1e()
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff81ac07e2>] xen_set_pte_init+0x66/0x71
> . snip..
> Pid: 0, comm: swapper Not tainted 3.6.0-rc6upstream-00188-gb6fb969-dirty #2 HP 
> ProLiant BL680c G5
> .. snip..
> Call Trace:
>  [<ffffffff81ad31c6>] __early_ioremap+0x18a/0x248
>  [<ffffffff81624731>] ? printk+0x48/0x4a
>  [<ffffffff81ad32ac>] early_ioremap+0x13/0x15
>  [<ffffffff81acc140>] get_mpc_size+0x2f/0x67
>  [<ffffffff81acc284>] smp_scan_config+0x10c/0x136
>  [<ffffffff81acc2e4>] default_find_smp_config+0x36/0x5a
>  [<ffffffff81ac3085>] setup_arch+0x5b3/0xb5b
>  [<ffffffff81624731>] ? printk+0x48/0x4a
>  [<ffffffff81abca7f>] start_kernel+0x90/0x390
>  [<ffffffff81abc356>] x86_64_start_reservations+0x131/0x136
>  [<ffffffff81abfa83>] xen_start_kernel+0x65f/0x661
> (XEN) Domain 0 crashed: 'noreboot' set - not rebooting.
> 
> which is that ioremap would end up mapping 0xff using _PAGE_IOMAP
> (which is what early_ioremap sticks as a flag) - which meant
> we would get MFN 0xFF (pte ff461, which is OK), and then it would
> also map 0x100 (b/c ioremap tries to get page aligned request, and
> it was trying to map 0xf4fa0 + PAGE_SIZE - so it mapped the next page)
> as _PAGE_IOMAP. Since 0x100 is actually a RAM page, and the _PAGE_IOMAP
> bypasses the P2M lookup we would happily set the PTE to 1000461.
> Xen would deny the request since we do not have access to the
> Machine Frame Number (MFN) of 0x100. The P2M[0x100] is for example
> 0x80140.
> 
> CC: stable@kernel.org 
> Fixes-Oracle-Bugzilla: 
> https://bugzilla.oracle.com/bugzilla/show_bug.cgi?id=13665 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Jan Beulich <jbeulich@suse.com>

> ---
>  arch/x86/xen/enlighten.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 9642d4a..1fbe75a 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1452,6 +1452,10 @@ asmlinkage void __init xen_start_kernel(void)
>  		pci_request_acs();
>  
>  		xen_acpi_sleep_register();
> +
> +		/* Avoid searching for BIOS MP tables */
> +		x86_init.mpparse.find_smp_config = x86_init_noop;
> +		x86_init.mpparse.get_smp_config = x86_init_uint_noop;
>  	}
>  #ifdef CONFIG_PCI
>  	/* PCI BIOS service won't work from a PV guest. */
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



