Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab2EXOtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:49:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab2EXOta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:49:30 -0400
Date: Thu, 24 May 2012 16:49:25 +0200
From: Jan Kara <jack@suse.cz>
To: Sam Portolla <samportolla@yahoo.com>
Cc: ":" <linux-kernel@vger.kernel.org>
Subject: Re: BUG:: NULL ptr de-ref in drop_buffers
Message-ID: <20120524144925.GA8975@quack.suse.cz>
References: <1337409691.95873.YahooMailNeo@web121303.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337409691.95873.YahooMailNeo@web121303.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-05-12 23:41:31, Sam Portolla wrote:
> Hi,
> 
> Please include my email address above in the reply as not a subscriber; reporting a bug and looking for a fix please.
> 
> 
> Seen a previous discussion of this in 2.6.26 under bug 395849, but it does not mention a fix.
> 
> In this case, the issue happened on 2.6.23 GNU/Linux w/ x86_64 arch. 
  That is a really old kernel ;)

> Logs showing the issue followed by some analysis:
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
>  [<ffffffff802b3e69>] drop_buffers+0x29/0x120
> 
> RIP: 0010:[<ffffffff802b3e69>]  [<ffffffff802b3e69>] drop_buffers+0x29/0x120
> RSP: 0000:ffff81026033bb00  EFLAGS: 00010207
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81025c48c7d8
> RDX: 0000000000000000 RSI: ffff81026033bb40 RDI: ffff81026fb7c238
> RBP: ffff81026033bb30 R08: 00000000ffffffff R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000003 R12: ffff81024ecc4000
> R13: ffff81025c48c7d8 R14: ffff81026fb7c238 R15: ffff81026033bb40
> FS:  0000000000000000(0000) GS:ffff810267703400(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000002b8a4000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kswapd0 (pid: 322, threadinfo ffff810260338000, task ffff810262108000)
> Stack:  ffff81026f9ac638 ffff81026fb7c238 ffff81025c48c7d8 ffff81025c48c7d8
>  ffff81026033bd90 0000000000000001 ffff81026033bb60 ffffffff802b41c6
>  0000000000000000 ffff81026fb7c238 ffff81026033be80 ffff81025c48c7d8
> Call Trace:
>  [<ffffffff802b41c6>] try_to_free_buffers+0x46/0xb0
>  [<ffffffff80264c8e>] try_to_release_page+0x2e/0x50
>  [<ffffffff8026bf73>] shrink_page_list+0x533/0x6f0
>  [<ffffffff8026aa09>] release_pages+0x189/0x1c0
>  [<ffffffff8026c273>] isolate_lru_pages+0xd3/0x1e0
>  [<ffffffff8026c523>] shrink_inactive_list+0x163/0x410
>  [<ffffffff8026cde5>] shrink_zone+0xf5/0x140
>  [<ffffffff8026d507>] kswapd+0x387/0x540
>  [<ffffffff802475e0>] autoremove_wake_function+0x0/0x40
>  [<ffffffff8026d180>] kswapd+0x0/0x540
>  [<ffffffff80246ef8>] kthread+0x68/0xa0
>  [<ffffffff80229e24>] schedule_tail+0x54/0xc0
>  [<ffffffff8020d058>] child_rip+0xa/0x12
>  [<ffffffff80246e90>] kthread+0x0/0xa0
>  [<ffffffff8020d04e>] child_rip+0x0/0x12
> 
> #### from GDB, the bh pointer in the 1st do/while loop in the drop_buffers() is NULL.
> 
> 
> struct buffer_head *head(%r12)
> This the 1st do/while loop:
> 
> 0xffffffff802b3e69 <drop_buffers+41>:   mov    (%rbx),%eax
> 
> 0xffffffff802b3e8d <drop_buffers+77>:   mov    0x8(%rbx),%rbx
> 0xffffffff802b3e91 <drop_buffers+81>:   cmp    %r12,%rbx
> 0xffffffff802b3e94 <drop_buffers+84>:   jne    0xffffffff802b3e69 <drop_buffers+41>
> 
> RBX: 0000000000000000
> 
> 
> 2825                    bh = bh->b_this_page;
> 2826            } while (bh != head);
> 
> In this do/while loop, the bh is NULL as %rbx
  I see. Reports of this problem appear from time to time - page which
should have buffers attached (had PagePrivate bit set just a moment ago) but
it does not have any. But usually this is completely unreproducible so it's
not clear whether it's caused by a memory bit-flip or some real problem.
Also the fact that you saw the problem with 2.6.23 does not relly make it
very attractive to debug. Sorry.

  But if you can reproduce the problem, especially with newer kernel, I'd
be interested in hearing it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
