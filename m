Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1BREgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:36:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57682
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755965Ab1BREgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:36:12 -0500
Date: Thu, 17 Feb 2011 20:36:47 -0800 (PST)
Message-Id: <20110217.203647.193696765.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: ebiederm@xmission.com, eric.dumazet@gmail.com, opurdila@ixiacom.com,
        mingo@elte.hu, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
References: <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	<m1sjvm822m.fsf@fess.ebiederm.org>
	<AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 20:30:42 -0800

> On Thu, Feb 17, 2011 at 7:16 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> BUG: unable to handle kernel paging request at ffff8801adf8d760
>> IP: [<ffffffff8140c7ca>] unregister_netdevice_queue+0x3a/0xb0
> 
> Yup. That's the "list_move()". The disassembly is exactly what I'd
> expect from __list_del():
> 
>   16:	48 8b 93 a0 00 00 00 	mov    0xa0(%rbx),%rdx
>   1d:	48 8b 83 a8 00 00 00 	mov    0xa8(%rbx),%rax
>   24:	48 8d bb a0 00 00 00 	lea    0xa0(%rbx),%rdi
>   2b:*	48 89 42 08          	mov    %rax,0x8(%rdx)     <-- trapping instruction
>   2f:	48 89 10             	mov    %rdx,(%rax)
> 
> So I think we can consider this confirmed: it really is the stale
> queue left over on the stack (introduced by commit 443457242beb). With
> CONFIG_DEBUG_PAGEALLOC, you get a page fault when it tries to update
> the now stale pointers.
> 
> The patch from Eric Dumazet (which adds a few more cases to my patch
> and hopefully catches them all) almost certainly fixes this rather
> nasty memory corruption.

Eric D., please get a final version of the fix posted to netdev and
I'll make sure it slithers it's way to Linus's tree :-)

Thanks!
