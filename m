Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0CZRYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:24:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35741 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0CZRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jn45cOIvbBi0aBBTd5HDqIATAlAdlI7zmkZJK+qe+3OAWQZt2k1GcrIa1PHBPLSuNk
         jVBXaTZh9x6Iks8hW3Sa0vw3Jx536+Edf0TC7r3Rl/ke3Tqf+9Z+eNIZY8Hjmf4Akifm
         ZFQA2xGTXQ9lZcfXBcMdJQAcyiMmrbjzD3Y5Y=
Date: Fri, 26 Mar 2010 18:23:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [BUG] perf: hard lockup when using perf-sched
Message-ID: <20100326172350.GC5188@nowhere>
References: <4BA082EC.8030101@cn.fujitsu.com> <4BA9A885.9050105@cn.fujitsu.com> <1269415964.6530.25.camel@marge.simson.net> <1269418671.6465.6.camel@marge.simson.net> <4BAB1924.4060304@cn.fujitsu.com> <1269509241.8438.30.camel@marge.simson.net> <1269598293.6174.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269598293.6174.8.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:11:33AM +0100, Mike Galbraith wrote:
> On Thu, 2010-03-25 at 10:27 +0100, Mike Galbraith wrote:
> > On Thu, 2010-03-25 at 16:04 +0800, Li Zefan wrote:
> > > Mike Galbraith wrote:
> > > > On Wed, 2010-03-24 at 08:32 +0100, Mike Galbraith wrote:
> > > > 
> > > >> I just saw this, hunted down your testcase and tried it here.  Looks
> > > >> like perf_output_lock() wedged box.
> > > > 
> > > > (turns on frame pointers, and adds noinline)
> > > > 
> > > 
> > > Thanks! Then who's going to fix this...
> > 
> > Well, that kinda depends on whether I figure out how the heck it's all
> > supposed to work before somebody else whacks it or not.
> 
> This seems to work, in contrast to everything I tried yesterday.  Not
> exactly a thing of beauty, but at least it's an option, so...
> 
> perf: fix perf sched record forkbomb deadlock
> 
> perf sched record can deadlock a box should the holder of handle->data->lock
> take an interrupt, and then attempt to acquire an rq lock held by a CPU trying
> to acquire the same lock.  Disable interrupts.



Aah.

So the scenario is the following inversion?

	CPU0				CPU1
sched event with rq->lock held
				grab handle->data->lock
spin on handle->data->lock
				interrupt
				try to grab rq->lock

