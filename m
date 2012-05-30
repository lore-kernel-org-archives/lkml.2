Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2E3R3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:29:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:49688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2E3R3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:29:10 -0400
Message-ID: <1338398931.28384.7.camel@twins>
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 19:28:51 +0200
In-Reply-To: <20120530165816.GA8085@redhat.com>
References: <20120530165757.GA8077@redhat.com>
	 <20120530165816.GA8085@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 18:58 +0200, Oleg Nesterov wrote:
> install_breakpoint() returns -EEXIST if is_swbp_insn(orig_insn) == T,
> the caller treats this code as success.
> 
> This is doubly wrong. The successful return should set UPROBE_COPY_INSN,
> but the real problem is that it shouldn't succeed. If the probed insn is
> int3 the application should get SIGTRAP, this won't happen with uprobe.
> 
> Probably we can fix this, we can add the UPROBE_SHARED_BP flag and teach
> handle_swbp/set_orig_insn to handle this case correctly. But this needs
> some complications and we have other insns which can't be probed, lets
> make a simple fix for now.
> 
> I think this needs a cleanup. UPROBE_COPY_INSN should die, copy_insn()
> should be called by alloc_uprobe(). arch_uprobe_analyze_insn() depends
> on ->mm (ia32_compat) but it is called only once.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 8c5e043..1593b43 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -704,7 +704,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
>  			return ret;
>  
>  		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
> -			return -EEXIST;
> +			return -ENOTSUPP;
>  
>  		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm);
>  		if (ret)

IIRC this -EEXIST existed because the vma iteration it does is racy and
one can encounter the same vma twice or so. See the special -EEXIST
handling in register_for_each_vma().

Changing it like this would break stuff. 
