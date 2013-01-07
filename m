Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3AGPzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:55:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33319 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab3AGPzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:55:47 -0500
Date: Mon, 7 Jan 2013 16:55:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 08/31] x86, 64bit: early #PF handler set page table
Message-ID: <20130107155544.GD29449@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-9-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357260531-11115-9-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:28PM -0800, Yinghai Lu wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> two use cases:
> 1. We will support load and run kernel above 4G, and zero_page, ramdisk
>    will be above 4G, too
> 2. need to access ramdisk early to get microcode to update that as
>    early possible.
> 
> We could use early_iomap to access them, but it will make code to
								 too
> messy and hard to unified with 32bit.
		    s/unified/unify/

> 
> So here comes #PF handler to set page page.
> 
> When #PF happen, handler will use pages in __initdata to set page page

"When a page fault happens, the handler will use pages from __initdata
to cover the accessed page."

> to cover accessed page.
> 
> those code and page in __INIT sections, so will not increase ram usages.

Huh, what? Something is in __INIT and will not increase RAM usage?

> The good point is: with help of #PF handler, we can set kernel mapping
> from blank, and switch to init_level4_pgt later.

I think you want to say "we can create temporary, ad-hoc kernel mappings
and forget them later by switching to init_level4_pgt." ?

> switchover in head_64.S is only using three page to handle kernel
> crossing 1G, 512G with shareing page, most insteresting part.

Again, what?

> early_make_pgtable is using kernel high mapping address to access pages
> to set page table.
> 
> -v4: Add phys_base offset to make kexec happy, and add
> 	init_mapping_kernel()   - Yinghai
> -v5: fix compiling with xen, and add back ident level3 and level2 for xen
>      also move back init_level4_pgt from BSS to DATA again.
>      because we have to clear it anyway.  - Yinghai
> -v6: switch to init_level4_pgt in init_mem_mapping. - Yinghai
> -v7: remove not needed clear_page for init_level4_page
>      it is with fill 512,8,0 already in head_64.S  - Yinghai
> -v8: we need to keep that handler alive until init_mem_mapping and don't
>      let early_trap_init to trash that early #PF handler.
>      So split early_trap_pf_init out and move it down. - Yinghai
> -v9: switchover only cover kernel space instead of 1G so could avoid
>      touch possible mem holes. - Yinghai
> -v11: change far jmp back to far return to initial_code, that is needed
>      to fix failure that is reported by Konrad on AMD system.  - Yinghai

Those -vXX version lines need to go under the "---" line. Alternatively,
you might want to add some of them to the commit message with a proper
explanation since they are not that trivial at a first glance, for
example the -v5, -v6, -v8, -v9 with a better explanation.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This needs hpa's S-O-B.

[ … ]

-- 
Regards/Gruss,
Boris.
