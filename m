Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1BRStR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:49:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756314Ab1BRStO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:49:14 -0500
MIME-Version: 1.0
In-Reply-To: <m17hcx43m3.fsf@fess.ebiederm.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz> <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
 <20110217090910.GA3781@tiehlicka.suse.cz> <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
 <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
 <20110218122938.GB26779@tiehlicka.suse.cz> <20110218162623.GD4862@tiehlicka.suse.cz>
 <AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com> <m17hcx43m3.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Feb 2011 10:48:18 -0800
Message-ID: <AANLkTikh4oaR6CBK3NBazer7yjhE0VndsUB5FCDRsbJc@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 10:08 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> I am still getting programs segfaulting but that is happening on other
> machines running on older kernels so I am going to chalk that up to a
> buggy test and a false positive.

Ok.

> I am have OOM problems getting my tests run to complete.  On a good
> day that happens about 1 time in 3 right now.  I'm guess I will have
> to turn off DEBUG_PAGEALLOC to get everything to complete.
> DEBUG_PAGEALLOC causes us to use more memory doesn't it?

It does use a bit more memory, but it shouldn't be _that_ noticeable.
The real cost of DEBUG_PAGEALLOC is all the crazy page table
operations and TLB flushes we do for each allocation/deallocation. So
DEBUG_PAGEALLOC is very CPU-intensive, but it shouldn't have _that_
much of a memory overhead - just some trivial overhead due to not
being able to use largepages for the normal kernel identity mappings.

But there might be some other interaction with OOM that I haven't thought about.

> The most interesting thing I have right now is a networking lockdep
> issue.  Does anyone know what is going on there?

This seems to be a fairly straightforward bug.

In net/ipv4/inet_timewait_sock.c we have this:

  /* These are always called from BH context.  See callers in
   * tcp_input.c to verify this.
   */

  /* This is for handling early-kills of TIME_WAIT sockets. */
  void inet_twsk_deschedule(struct inet_timewait_sock *tw,
                            struct inet_timewait_death_row *twdr)
  {
          spin_lock(&twdr->death_lock);
          ..

and the intention is clearly that that spin_lock is BH-safe because
it's called from BH context.

Except that clearly isn't true. It's called from a worker thread:

> stack backtrace:
> Pid: 10833, comm: kworker/u:1 Not tainted 2.6.38-rc4-359399.2010AroraKernelBeta.fc14.x86_64 #1
> Call Trace:
>  [<ffffffff81460e69>] ? inet_twsk_deschedule+0x29/0xa0
>  [<ffffffff81460fd6>] ? inet_twsk_purge+0xf6/0x180
>  [<ffffffff81460f10>] ? inet_twsk_purge+0x30/0x180
>  [<ffffffff814760fc>] ? tcp_sk_exit_batch+0x1c/0x20
>  [<ffffffff8141c1d3>] ? ops_exit_list.clone.0+0x53/0x60
>  [<ffffffff8141c520>] ? cleanup_net+0x100/0x1b0
>  [<ffffffff81068c47>] ? process_one_work+0x187/0x4b0
>  [<ffffffff81068be1>] ? process_one_work+0x121/0x4b0
>  [<ffffffff8141c420>] ? cleanup_net+0x0/0x1b0
>  [<ffffffff8106a65c>] ? worker_thread+0x15c/0x330

so it can deadlock with a BH happening at the same time, afaik.

The code (and comment) is all from 2005, it looks like the BH->worker
thread has broken the code. But somebody who knows that code better
should take a deeper look at it.

Added acme to the cc, since the code is attributed to him back in 2005
;). Although I don't know how active he's been in networking lately
(seems to be all perf-related). Whatever, it can't hurt.

                   Linus
