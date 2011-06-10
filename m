Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1FJBbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 21:31:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab1FJBbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 21:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=FIsHGuwj9HkiKVZVqFn0XPf8cyeTc/7uwteEIQCmIXuCBFmCHCyKCQft0pyM12loIa
         sQNpf2e2SV0ibLKrlhgg==
Date: Thu, 9 Jun 2011 18:30:49 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Ying Han <yinghan@google.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: 3.0rc2 oops in mem_cgroup_from_task
In-Reply-To: <20110610091355.2ce38798.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1106091812030.4904@sister.anvils>
References: <20110609212956.GA2319@redhat.com> <BANLkTikCfWhoLNK__ringzy7KjKY5ZEtNb3QTuX1jJ53wNNysA@mail.gmail.com> <BANLkTikF7=qfXAmrNzyMSmWm7Neh6yMAB8EbBp7oLcfQmrbDjA@mail.gmail.com> <20110610091355.2ce38798.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, KAMEZAWA Hiroyuki wrote:
> On Thu, 9 Jun 2011 16:42:09 -0700
> Ying Han <yinghan@google.com> wrote:
> 
> > ++cc Hugh who might have seen similar crashes on his machine.

Yes, I was testing my tmpfs changes, and saw it on i386 yesterday
morning.  Same trace as Dave's (including khugepaged, which may or
may not be relevant), aside from the i386/x86_64 differences.

BUG: unable to handle kernel paging request at 6b6b6b87

I needed to move forward with other work on that laptop, so just
jotted down the details to come back to later.  It came after one
hour of building swapping load in memcg, I've not tried again since.

> 
> Thank you for forwarding. Hmm. It seems the panic happens at khugepaged's 
> page collapse_huge_page().

Yes, the inlining in my kernel was different,
so collapse_huge_page() showed up in my backtrace.

> 
> ==
>         count_vm_event(THP_COLLAPSE_ALLOC);
>         if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
> ==
> It passes target mm to memcg and memcg gets a cgroup by
> ==
>  mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
> ==
> Panic here means....mm->owner's task_subsys_state contains bad pointer ?

781cc621 <mem_cgroup_from_task>:
781cc621:	55                   	push   %ebp
781cc622:	31 c0                	xor    %eax,%eax
781cc624:	89 e5                	mov    %esp,%ebp
781cc626:	8b 55 08             	mov    0x8(%ebp),%edx
781cc629:	85 d2                	test   %edx,%edx
781cc62b:	74 09                	je     781cc636 <mem_cgroup_from_task+0x15>
781cc62d:	8b 82 fc 08 00 00    	mov    0x8fc(%edx),%eax
781cc633:	8b 40 1c             	mov    0x1c(%eax),%eax   <==========
781cc636:	c9                   	leave  
781cc637:	c3                   	ret    

Hugh
