Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1GYAWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 20:22:13 -0400
Received: from ozlabs.org ([203.10.76.45]:38956 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1GYAWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 20:22:10 -0400
Date: Mon, 25 Jul 2011 09:27:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Ahern <dsahern@gmail.com>
Cc: Anton Blanchard <anton@samba.org>, linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf PPC: kernel panic with callchains and context switch events
Message-ID: <20110724232721.GA19839@bloggs.ozlabs.ibm.com>
References: <4E274F5F.7000604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E274F5F.7000604@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 03:57:51PM -0600, David Ahern wrote:
> I am hoping someone familiar with PPC can help understand a panic that
> is generated when capturing callchains with context switch events.
> 
> Call trace is below. The short of it is that walking the callchain
> generates a page fault. To handle the page fault the mmap_sem is needed,
> but it is currently held by setup_arg_pages. setup_arg_pages calls
> shift_arg_pages with the mmap_sem held. shift_arg_pages then calls
> move_page_tables which has a cond_resched at the top of its for loop. If
> the cond_resched() is removed from move_page_tables everything works
> beautifully - no panics.
> 
> So, the question: is it normal for walking the stack to trigger a page
> fault on PPC? The panic is not seen on x86 based systems.

Walking the user stack can certainly generate a page fault; walking
the kernel stack should never generate a page fault.  If any page
fault is generated reading the user stack frame, we're supposed to
detect that and fall back to walking the page tables manually (see
read_user_stack_64() in arch/powerpc/kernel/perf_callchain.c).  I
think I need to check our __get_user_inatomic() implementation.

I don't think removing the cond_resched() from move_page_tables is the
right answer.

Paul.
