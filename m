Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab2CVCyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:54:04 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40157 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2CVCyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:54:00 -0400
X-AuditID: b753bd60-9a1a8ba000002f45-d3-4f6a94459125
X-AuditID: b753bd60-9a1a8ba000002f45-d3-4f6a94459125
Message-ID: <4F6A9444.4050603@hitachi.com>
Date: Thu, 22 Mar 2012 11:53:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        tim.bird@am.sony.com
Subject: Re: [PATCH 2/2] kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation
 using kprobe breakpoints
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com> <1332352536-29186-3-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1332352536-29186-3-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/22 2:55), Jason Wessel wrote:
> There has long been a limitation using software breakpoints with a
> kernel compiled with CONFIG_DEBUG_RODATA.  The kprobe breakpoint code
> has its own text_poke() function which accommodates writing a
> breakpoint into a read-only page.  The debug_core can make use of the
> text_poke() capabilities by using the kprobes API, specifically
> arch_arm_kprobe() and arch_disarm_kprobe().  For now it is safe to use
> a single statically allocated kprobe structure to call the kprobes API
> because the debug_core breakpoint API is only used when the kernel is
> in the debug state.

You might misunderstand it. arch_*_kprobe() are not open APIs.
Those are kprobes internal APIs (which means that those functions
should be used only by kprobes).


> The debug_core will first attempt to use the traditional
> probe_kernel_write(), and next try using a kprobe breakpoint.  The
> kgdb test suite was updated to run all the software breakpoint tests
> when using a kernel with built with CONFIG_DEBUG_RODATA.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Nak.

[...]
> @@ -165,17 +173,48 @@ int __weak kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
>  {
>  	int err;
>  
> +	bpt->type = BP_BREAKPOINT;
>  	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
>  				BREAK_INSTR_SIZE);
>  	if (err)
>  		return err;
>  	err = probe_kernel_write((char *)bpt->bpt_addr,
>  				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
> +#if defined(CONFIG_KPROBES) && defined(CONFIG_DEBUG_RODATA)
> +	if (!err)
> +		return err;
> +	probe_write_tmp.addr = (kprobe_opcode_t *)bpt->bpt_addr;
> +	arch_arm_kprobe(&probe_write_tmp);

No, please don't use kprobes internal function this way, because
you can't ensure that the arch_arm_kprobe() has no side-effect.

Why don't you use text_poke()? I see that the text_poke()
is only for x86, but you already have arch/x86/kernel/kgdb.c for
making your own wrapper function.

> +	err = probe_kernel_read(&probe_write_tmp.opcode, (char *)bpt->bpt_addr,
> +				BREAK_INSTR_SIZE);
> +	if (err)
> +		return err;
> +	if (memcmp(&probe_write_tmp.opcode, arch_kgdb_ops.gdb_bpt_instr,
> +		   BREAK_INSTR_SIZE))
> +		return -EINVAL;
> +	bpt->type = BP_KPROBE_BREAKPOINT;
> +#endif /* CONFIG_KPROBES && CONFIG_DEBUG_RODATA */
>  	return err;
>  }
>  
>  int __weak kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
>  {
> +#if defined(CONFIG_KPROBES) && defined(CONFIG_DEBUG_RODATA)
> +	int err;
> +
> +	if (bpt->type != BP_KPROBE_BREAKPOINT)
> +		goto knl_write;
> +	probe_write_tmp.addr = (kprobe_opcode_t *)bpt->bpt_addr;
> +	memcpy(&probe_write_tmp.opcode, bpt->saved_instr, BREAK_INSTR_SIZE);
> +	arch_disarm_kprobe(&probe_write_tmp);

Ditto.

> +	err = probe_kernel_read(&probe_write_tmp.opcode, (char *)bpt->bpt_addr,
> +				BREAK_INSTR_SIZE);
> +	if (err ||
> +	    memcmp(&probe_write_tmp.opcode, bpt->saved_instr, BREAK_INSTR_SIZE))
> +		goto knl_write;
> +	return err;
> +knl_write:
> +#endif /* CONFIG_KPROBES && CONFIG_DEBUG_RODATA */
>  	return probe_kernel_write((char *)bpt->bpt_addr,
>  				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
>  }
> @@ -294,7 +333,6 @@ int dbg_set_sw_break(unsigned long addr)
>  		return -E2BIG;
>  
>  	kgdb_break[breakno].state = BP_SET;
> -	kgdb_break[breakno].type = BP_BREAKPOINT;
>  	kgdb_break[breakno].bpt_addr = addr;
>  
>  	return 0;

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
