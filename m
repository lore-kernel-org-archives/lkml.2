Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0HXTVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:21:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:51278 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab0HXTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:21:43 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
Organization: Wind River International Ltd.
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] x86: avoid using vmalloc_to_page on non-vmalloc'ed addresses
Date: Tue, 24 Aug 2010 15:20:36 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-14-generic; KDE/4.5.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <1282246156-7830-1-git-send-email-mark.asselstine@windriver.com> <20100819202952.GA27217@Krystal>
In-Reply-To: <20100819202952.GA27217@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241520.37065.mark.asselstine@windriver.com>
X-OriginalArrivalTime: 24 Aug 2010 19:20:38.0616 (UTC) FILETIME=[6F5AC580:01CB43C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010, Mathieu Desnoyers wrote:
> * Mark Asselstine (mark.asselstine@windriver.com) wrote:
> > It is possible that addresses passed to text_poke() fall beyond _etext
> > but are also not vmalloc'ed and thus should be using virt_to_page() and
> > not vmalloc_to_page(). Using is_vmalloc_addr() ensures the proper logic
> > is used to retrieve the page.
> > 
> > Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
> > ---
> > At the moment I don't believe there are any situations where this is a
> > problem in Linus' tree but I know that mixing LTTng and RT with things
> > can cause this to be troublesome. LTTng introduces an immediate value
> > optimization which makes use of text_poke and this can happen beyond
> > _etext. The example I was looking at is in rd_load_image which results
> > in
> > 
> > rd_load_image --> kmalloc  --> trace_kmalloc --> imv_read
> > 
> > The imv_read will insert a 'mov $0x0,%al' in rd_load_image which will
> > later be the site of the text_poke when arch_imv_update is called.
> > Looking at the addresses of my build _etext = c1490b2c,
> > rd_load_image = c1671034 and VMALLOC_START = d87fd000. So in this case
> > I believe, and this is where I suspect I will get some feedback, it
> > is *not* acceptable to be doing a vmalloc_to_page() operation on the
> > address which was not vmalloc'ed.
> 
> Hrm, so basically you have something that allocates kernel text outside of
> the standard module-based scheme, so e.g. you rely on kmalloc rather than
> vmalloc to allocate this. Yep, in this case, the text_poke check will fail
> to see that you are using the linear mapping will try to use
> vmalloc_to_page incorrectly.
> 
> You patch makes sense, and would apply to the current -tip tree. I'd like
> to hear other opinions on this, so I add a few CC.
> 
> Thanks,
> 
> Mathieu
> 
> >  arch/x86/kernel/alternative.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/alternative.c
> > b/arch/x86/kernel/alternative.c index f65ab8b..0c8c26c 100644
> > --- a/arch/x86/kernel/alternative.c
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -555,7 +555,7 @@ void *__kprobes text_poke(void *addr, const void
> > *opcode, size_t len)
> > 
> >  	struct page *pages[2];
> >  	int i;
> > 
> > -	if (!core_kernel_text((unsigned long)addr)) {
> > +	if (is_vmalloc_addr(addr)) {

After finding some issues with UP and modules I have found that the better 
logic here is

+	if (!virt_addr_valid(addr)) {

This saves getting junk from virt_to_page() that will cause an OOPS when 
virt_addr_valid(addr) is false. Same idea, just different logic as the 
original patch.

Mark


> > 
> >  		pages[0] = vmalloc_to_page(addr);
> >  		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> >  	
> >  	} else {

