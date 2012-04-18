Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2DRUCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:02:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52287 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865Ab2DRUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:02:03 -0400
Date: Wed, 18 Apr 2012 23:01:58 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH 1/2] vmevent: Should not grab mutex in the atomic
 context
In-Reply-To: <20120418083356.GA31556@lizard>
Message-ID: <alpine.LFD.2.02.1204182301430.11868@tux.localdomain>
References: <20120418083208.GA24904@lizard> <20120418083356.GA31556@lizard>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Anton Vorontsov wrote:
> vmevent grabs a mutex in the atomic context, and so this pops up:
> 
> BUG: sleeping function called from invalid context at kernel/mutex.c:271
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
> 1 lock held by swapper/0/0:
>  #0:  (&watch->timer){+.-...}, at: [<ffffffff8103eb80>] call_timer_fn+0x0/0xf0
> Pid: 0, comm: swapper/0 Not tainted 3.2.0+ #6
> Call Trace:
>  <IRQ>  [<ffffffff8102f5da>] __might_sleep+0x12a/0x1e0
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff81321f2c>] mutex_lock_nested+0x3c/0x340
>  [<ffffffff81064b33>] ? lock_acquire+0xa3/0xc0
>  [<ffffffff8103eb80>] ? internal_add_timer+0x110/0x110
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff810bda21>] vmevent_timer_fn+0x91/0xf0
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff8103ebf5>] call_timer_fn+0x75/0xf0
>  [<ffffffff8103eb80>] ? internal_add_timer+0x110/0x110
>  [<ffffffff81062fdd>] ? trace_hardirqs_on_caller+0x7d/0x120
>  [<ffffffff8103ee9f>] run_timer_softirq+0x10f/0x1e0
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff81038d90>] __do_softirq+0xb0/0x160
>  [<ffffffff8105eb0f>] ? tick_program_event+0x1f/0x30
>  [<ffffffff8132642c>] call_softirq+0x1c/0x26
>  [<ffffffff810036d5>] do_softirq+0x85/0xc0
> 
> This patch fixes the issue by removing the mutex and making the logic
> lock-free.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Applied, thanks!
