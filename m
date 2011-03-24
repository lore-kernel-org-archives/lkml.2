Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869Ab1CXTXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:23:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab1CXTXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:23:05 -0400
Date: Thu, 24 Mar 2011 20:22:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [boot crash #2] Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324192247.GA5477@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
 <alpine.DEB.2.00.1103240940570.32226@router.home>
 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
 <20110324172653.GA28507@elte.hu>
 <20110324185258.GA28370@elte.hu>
 <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 24 Mar 2011, Ingo Molnar wrote:
> > RIP: 0010:[<ffffffff810570a9>]  [<ffffffff810570a9>] get_next_timer_interrupt+0x119/0x260
> 
> That's a typical timer crash, but you were unable to debug it with
> debugobjects because commit d3f661d6 broke those.
> 
> Christoph, debugobjects do not need to run with interupts
> disabled. And just because they were in that section to keep all the
> debug stuff together does not make an excuse for not looking at the
> code and just slopping it into some totally unrelated ifdef along with
> a completely bogus comment.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  mm/slub.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c
> +++ linux-2.6/mm/slub.c
> @@ -849,11 +849,11 @@ static inline void slab_free_hook(struct
>  		local_irq_save(flags);
>  		kmemcheck_slab_free(s, x, s->objsize);
>  		debug_check_no_locks_freed(x, s->objsize);
> -		if (!(s->flags & SLAB_DEBUG_OBJECTS))
> -			debug_check_no_obj_freed(x, s->objsize);
>  		local_irq_restore(flags);
>  	}
>  #endif
> +	if (!(s->flags & SLAB_DEBUG_OBJECTS))
> +		debug_check_no_obj_freed(x, s->objsize);

Thanks, this did the trick!

Tested-by: Ingo Molnar <mingo@elte.hu>

With this fix i got the warning below - pinpointing a net/bluetooth/hci_core.c 
timer bug.

Thanks,

	Ingo

------------[ cut here ]------------
 WARNING: at lib/debugobjects.c:262 debug_print_object+0x8e/0xb0()
 Hardware name: System Product Name
 ODEBUG: free active (active state 0) object type: timer_list hint: hci_cmd_timer+0x0/0x60
 Pid: 2076, comm: dmsetup Not tainted 2.6.38-tip-09251-ged68fd8-dirty #110378
 Call Trace:
  [<ffffffff8104703a>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff810470e6>] warn_slowpath_fmt+0x46/0x50
  [<ffffffff812d3eee>] debug_print_object+0x8e/0xb0
  [<ffffffff81bee870>] ? bt_sock_wait_state+0x150/0x150
  [<ffffffff812d4b15>] debug_check_no_obj_freed+0x125/0x230
  [<ffffffff810f1173>] ? check_object+0xb3/0x2b0
  [<ffffffff81bfad56>] ? bt_host_release+0x16/0x20
  [<ffffffff81bfad56>] ? bt_host_release+0x16/0x20
  [<ffffffff810f373c>] kfree+0x14c/0x190
  [<ffffffff81bfad56>] bt_host_release+0x16/0x20
  [<ffffffff813a1b87>] device_release+0x27/0xa0
  [<ffffffff812c53bc>] kobject_release+0x4c/0xa0
  [<ffffffff812c5370>] ? kobject_del+0x40/0x40
  [<ffffffff812c6416>] kref_put+0x36/0x70
  [<ffffffff812c4f57>] kobject_put+0x27/0x60
  [<ffffffff813a2477>] put_device+0x17/0x20
  [<ffffffff81bf0549>] hci_free_dev+0x29/0x30
  [<ffffffff8193ed16>] vhci_release+0x36/0x70
  [<ffffffff810fb4f6>] fput+0xd6/0x1f0
  [<ffffffff810f9176>] filp_close+0x66/0x90
  [<ffffffff810f9239>] sys_close+0x99/0xf0
  [<ffffffff81d63dab>] system_call_fastpath+0x16/0x1b
 ---[ end trace ea6ca6434ee730b9 ]---
