Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1IARhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:37:13 -0400
Received: from peace.netnation.com ([204.174.223.2]:40140 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab1IARhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:37:11 -0400
X-Greylist: delayed 1240 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Sep 2011 13:37:11 EDT
Date: Thu, 1 Sep 2011 10:16:26 -0700
From: Simon Kirby <sim@hostway.ca>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Cc: Terry Loftin <terry.loftin@hp.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Bob Montgomery <bob.montgomery@hp.com>
Subject: Re: [PATCH 1/2] sched: Fix "divide error: 0000" in
	find_busiest_group
Message-ID: <20110901171626.GA1629@hostway.ca>
References: <4E25F006.2010205@hp.com> <1311110224.2617.1.camel@laptop> <1311128780.7789.12.camel@marge.simson.net> <1311128991.5345.0.camel@twins> <1311132728.7789.29.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311132728.7789.29.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 05:32:08AM +0200, Mike Galbraith wrote:

> On Wed, 2011-07-20 at 04:29 +0200, Peter Zijlstra wrote:
> > On Wed, 2011-07-20 at 04:26 +0200, Mike Galbraith wrote:
> > > On Tue, 2011-07-19 at 23:17 +0200, Peter Zijlstra wrote:
> > > > On Tue, 2011-07-19 at 14:58 -0600, Terry Loftin wrote:
> > > > > Correct the protection expression in update_cpu_power() to avoid setting
> > > > > rq->cpu_power to zero.
> > > > 
> > > > Firstly you fail to mention what kernel this is again, secondly this
> > > > should never happen in the first place, so this fix is wrong. At best it
> > > > papers over another bug.
> > > > 
> > > > > Signed-off-by: Terry Loftin <terry.loftin@hp.com>
> > > > > Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
> > > > > ---
> > > > > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > > > > index 0c26e2d..9c50020 100644
> > > > > --- a/kernel/sched_fair.c
> > > > > +++ b/kernel/sched_fair.c
> > > > > @@ -2549,7 +2549,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
> > > > >  	power *= scale_rt_power(cpu);
> > > > >  	power >>= SCHED_LOAD_SHIFT;
> > > > > 
> > > > > -	if (!power)
> > > > > +	if ((u32)power == 0)
> > > > >  		power = 1;
> > > > > 
> > > > >  	cpu_rq(cpu)->cpu_power = power;
> > > 
> > > I put that (and a bunch more protection+warnings) in an enterprise
> > > kernel so it would not explode, but would gather some data.  The entire
> > > world has been utterly silent, except for a gaggle of POWER7 boxen,
> > > which manage to convince scale_rt_power() to return negative values.
> > > 
> > > Turning on PRINTK_TIME made these boxen go silent.  A printk with
> > > timestamps, which doesn't happen, hides the problem.  Tilt.
> > 
> > Did those kernels contain the scale_rt_power() hunk from commit
> > aa483808516ca5cacfa0e5849691f64fec25828e? Venki thought that might cure
> > sure woes, but since we never could reproduce...
> 
> Yeah, that commit is present.

We just hit what seems to be this bug on a box running 2.6.36 since
around the time it was built (Nov 8, 2010). It's a 16 core box (dual quad
with HT) and runs all sorts of stuff all day long, and suddenly hit this
divide error.

Commit aa483808516ca5cacfa0e5849691f64fec25828e is present.

find_busiest_group() seems to have been inlined into load_balance():

   0xffffffff8104d55f <+1151>:  jne    0xffffffff8104d568 <load_balance+1160>
   0xffffffff8104d561 <+1153>:  mov    $0x1,%cl
   0xffffffff8104d563 <+1155>:  mov    $0x1,%esi
   0xffffffff8104d568 <+1160>:  movslq -0x16c(%rbp),%rdx
   0xffffffff8104d56f <+1167>:  mov    $0x14bc0,%rax
   0xffffffff8104d576 <+1174>:  mov    -0x7e601720(,%rdx,8),%rdx
   0xffffffff8104d57e <+1182>:  mov    %rcx,0x7e0(%rax,%rdx,1)
   0xffffffff8104d586 <+1190>:  mov    %esi,0x8(%r8)
   0xffffffff8104d58a <+1194>:  nopw   0x0(%rax,%rax,1)
   0xffffffff8104d590 <+1200>:  mov    -0x138(%rbp),%rcx
   0xffffffff8104d597 <+1207>:  mov    -0x68(%rbp),%rsi
   0xffffffff8104d59b <+1211>:  xor    %edx,%edx
   0xffffffff8104d59d <+1213>:  mov    0x8(%rcx),%edi
   0xffffffff8104d5a0 <+1216>:  mov    %rsi,%rax
   0xffffffff8104d5a3 <+1219>:  mov    -0x60(%rbp),%rcx
   0xffffffff8104d5a7 <+1223>:  shl    $0xa,%rax
   0xffffffff8104d5ab <+1227>:  div    %rdi                    <--------------
   0xffffffff8104d5ae <+1230>:  mov    %rax,-0x70(%rbp)
   0xffffffff8104d5b2 <+1234>:  xor    %eax,%eax
   0xffffffff8104d5b4 <+1236>:  test   %rcx,%rcx
   0xffffffff8104d5b7 <+1239>:  je     0xffffffff8104d5c5 <load_balance+1253>

rax, rdx, and rdi were 0 here. Fuzzy picture available on request.

Other than some indirection, I don't see any changes in this area that
would fix this bug since 2.6.36, either. Perhaps the !power test in
update_cpu_power() should be copied to update_group_power()? This still
seems like papering over another issue, though...

Perhaps this might discover something:

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..b31cd3d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2682,6 +2682,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 	} while (group != child->groups);
 
 	sdg->sgp->power = power;
+	BUG_ON(!power);
 }
 
 /*

Simon-
