Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1FIMFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:05:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:44971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1FIMFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:05:48 -0400
Subject: Re: Change in functionality of futex() system call.
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>, David Oliver <david@rgmadvisors.com>,
        linux-kernel@vger.kernel.org, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307383898.3098.90.camel@edumazet-laptop>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <4DED1421.5000300@linux.intel.com>
	 <1307383898.3098.90.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Jun 2011 14:05:08 +0200
Message-ID: <1307621108.3941.77.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 20:11 +0200, Eric Dumazet wrote:

> Now, what if other software uses a MAP_PRIVATE ro mapping ?
> 
> It was working in previous kernels as well.
> 
> We can say its stupid, but IMHO its not.
> 
> In other words, this program should work, if process never touches
> (writes) into first page.
> 
> This program on previous kernels gave :
> rc=-1 errno=11
> (allowing to wait for a value change and a futex_WAKE)
> 
> With new kernel :
> rc=-1 errno=14  [ no sleep allowed ]

Yeah, so friggin what? I can write a similar program that is broken with
the old behaviour. The fact that the semantics are just crap (wtf does
it mean to FUTEX_WAIT on a address that changes mapping on COW) should
be enough to convince you that the old behaviour simply doesn't make
sense.

Once the COW happened you shouldn't be able to observe the old page, yet
that's exactly what the still pending FUTEX_WAIT will do.

The fact that this can happen, means the behaviour is broken, no if else
or buts about it.
