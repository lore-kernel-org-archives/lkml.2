Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0HSU37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:29:59 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39637 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750994Ab0HSU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:29:56 -0400
Date: Thu, 19 Aug 2010 16:29:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mark Asselstine <mark.asselstine@windriver.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: avoid using vmalloc_to_page on non-vmalloc'ed
	addresses
Message-ID: <20100819202952.GA27217@Krystal>
References: <1282246156-7830-1-git-send-email-mark.asselstine@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282246156-7830-1-git-send-email-mark.asselstine@windriver.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:23:41 up 208 days, 23:00,  4 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Asselstine (mark.asselstine@windriver.com) wrote:
> It is possible that addresses passed to text_poke() fall beyond _etext
> but are also not vmalloc'ed and thus should be using virt_to_page() and
> not vmalloc_to_page(). Using is_vmalloc_addr() ensures the proper logic
> is used to retrieve the page.
> 
> Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
> ---
> At the moment I don't believe there are any situations where this is a
> problem in Linus' tree but I know that mixing LTTng and RT with things
> can cause this to be troublesome. LTTng introduces an immediate value
> optimization which makes use of text_poke and this can happen beyond
> _etext. The example I was looking at is in rd_load_image which results
> in
> 
> rd_load_image --> kmalloc  --> trace_kmalloc --> imv_read
> 
> The imv_read will insert a 'mov $0x0,%al' in rd_load_image which will
> later be the site of the text_poke when arch_imv_update is called.
> Looking at the addresses of my build _etext = c1490b2c,
> rd_load_image = c1671034 and VMALLOC_START = d87fd000. So in this case
> I believe, and this is where I suspect I will get some feedback, it
> is *not* acceptable to be doing a vmalloc_to_page() operation on the
> address which was not vmalloc'ed.

Hrm, so basically you have something that allocates kernel text outside of the
standard module-based scheme, so e.g. you rely on kmalloc rather than vmalloc to
allocate this. Yep, in this case, the text_poke check will fail to see that you
are using the linear mapping will try to use vmalloc_to_page incorrectly.

You patch makes sense, and would apply to the current -tip tree. I'd like to
hear other opinions on this, so I add a few CC.

Thanks,

Mathieu

> 
>  arch/x86/kernel/alternative.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index f65ab8b..0c8c26c 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -555,7 +555,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  	struct page *pages[2];
>  	int i;
>  
> -	if (!core_kernel_text((unsigned long)addr)) {
> +	if (is_vmalloc_addr(addr)) {
>  		pages[0] = vmalloc_to_page(addr);
>  		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
>  	} else {
> -- 
> 1.7.1
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
