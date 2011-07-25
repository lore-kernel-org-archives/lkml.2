Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1GYSKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:10:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52278 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1GYSKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:10:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110725161009.GA9193@dumpdata.com>
References: <20110725155442.GA21759@dumpdata.com> <20110725161009.GA9193@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 25 Jul 2011 14:10:22 -0400
X-Google-Sender-Auth: Z0Tw3irm9FX_AM6cklGIzqnfSpQ
Message-ID: <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com>
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7 (x86-64: Give
 vvars their own page) breaks Xen PV guests (64-bit).
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, arjan@infradead.org,
        JBeulich@novell.com, richard.weinberger@gmail.com, mikpe@it.uu.se,
        andi@firstfloor.org, brgerst@gmail.com, Louis.Rilling@kerlabs.com,
        Valdis.Kletnieks@vt.edu, pageexec@freemail.hu, mingo@elte.hu,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 12:10 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Jul 25, 2011 at 11:54:42AM -0400, Konrad Rzeszutek Wilk wrote:
>> Hey Andy,
>>
>> I just started testing linus/master and found out that I get this bootup error:
>>
>> mapping kernel into physical memory
>> about to get started...
>> (XEN) mm.c:940:d10 Error getting mfn 1888 (pfn 1e3e48) from L1 entry 8000000001888465 for l1e_owner=10, pg_owner=10
>> (XEN) mm.c:5049:d10 ptwr_emulate: could not get_page_from_l1e()
>> [    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [    0.000000] IP: [<ffffffff8103a930>] xen_set_pte+0x20/0xe0
>> [    0.000000] PGD 0
>> [    0.000000] Oops: 0003 [#1] PREEMPT SMP
>> [    0.000000] CPU 0
>> [    0.000000] Modules linked in:
>> [    0.000000]
>> [    0.000000] Pid: 0, comm: swapper Not tainted 3.0.0-rc1-00169-gae7bd11 #1
>> [    0.000000] RIP: e030:[<ffffffff8103a930>]  [<ffffffff8103a930>] xen_set_pte+0x20/0xe0
>> [    0.000000] RSP: e02b:ffffffff81801df8  EFLAGS: 00010097
>> [    0.000000] RAX: 0000000000000000 RBX: ffff88000193dff8 RCX: ffffffffff5ff000
>> [    0.000000] RDX: 0000000010000001 RSI: 8000000001888465 RDI: ffff88000193dff8
>> [    0.000000] RBP: ffffffff81801e18 R08: 0000000000000000 R09: 0000000000007ff0
>> [    0.000000] R10: aaaaaaaaaaaaaaaa R11: aaaaaaaaaaaaaaaa R12: 8000000001888465
>> [    0.000000] R13: 000000000e573000 R14: 0000000080000000 R15: 0000000000000000
>> [    0.000000] FS:  0000000000000000(0000) GS:ffffffff81889000(0000) knlGS:0000000000000000
>> [    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [    0.000000] CR2: 0000000000000000 CR3: 0000000001803000 CR4: 0000000000000660
>> [    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [    0.000000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [    0.000000] Process swapper (pid: 0, threadinfo ffffffff81800000, task ffffffff8180b020)
>> [    0.000000] Stack:
>> [    0.000000]  ffffffffff5ff000 8000000001888465 ffffffffff5ff000 8000000001888465
>> [    0.000000]  ffffffff81801e38 ffffffff8106db53 0000000000000800 8000000001888465
>> [    0.000000]  ffffffff81801e48 ffffffff8106dbc0 ffffffff81801e58 ffffffff810720f6
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff8106db53>] set_pte_vaddr_pud+0x43/0x60
>> [    0.000000]  [<ffffffff8106dbc0>] set_pte_vaddr+0x50/0x70
>
> This tiny patch fixes the bootup:
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index f987bde..0e4c13c 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
>  # endif
>  #else
>        case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
> +       case VVAR_PAGE:
>  #endif
>        case FIX_TEXT_POKE0:
>        case FIX_TEXT_POKE1:

Looks sane by analogy to the other code there, but I don't know how
this stuff works in Xen.  Jeremy?

>
> However, this is what I get later on, any ideas?

> [    0.585880] init[1] illegal int 0xcc from 32-bit mode ip:ffffffffff600400 cs:e033 sp:7fff230ca088 ax:ffffffffff600400 si:7faee3e822bf di:7fff230ca158

That will, indeed, crash your system.

0xe033 is FLAT_RING3_CS64

Jeremy / other Xen people:  I'm trying to implement a lightweight
check to distinguish a trap from a sane (i.e. allowable for syscalls)
64-bit user context from anything else.  There seems to be precedent
for using ->cs == __USER_CS to detect 64-bitness; for example, step.c
contains:

#ifdef CONFIG_X86_64
                case 0x40 ... 0x4f:
                        if (regs->cs != __USER_CS)
                                /* 32-bit mode: register increment */
                                return 0;
                        /* 64-bit mode: REX prefix */
                        continue;
#endif

The prefetch opcode checker in mm/fault.c does something similar.

Even the sysret code in xen/xen-asm_64.S does:

        pushq %r11
        pushq $__USER_CS
        pushq %rcx

So I'm at a bit of a loss.

You could probably hack it up and get your kernel to boot by allowing
__USER_CS and 0xe033 in that check, but I'd rather understand it
before submitting a patch.

--Andy
