Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1EZKzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:55:16 -0400
Received: from canuck.infradead.org ([134.117.69.58]:50149 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab1EZKzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:55:14 -0400
X-Greylist: delayed 1295 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 06:55:14 EDT
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 May 2011 12:32:59 +0200
Message-ID: <1306405979.1200.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 15:29 +0800, Yong Zhang wrote:
> > Figuring out why the existing condition failed
> 
> Seems  'current' will change before/after switch_to since it's derived from
> sp register.
> So that means if interrupt come before we switch sp, 'p == current' will
> catch it, but if interrupt comes after we switch sp, we will lose a wake up.

Well, loosing a wakeup isn't the problem here (although it would be a
problem), the immediate problem is that we're getting stuck
(life-locked) in that while (p->on_cpu) loop.

But yes, I think that explains it, if the interrupts hits
context_switch() after current was changed but before clearing
p->on_cpu, we would life-lock in interrupt context.

Now we could of course go add in_interrupt() checks there, but that
would make this already fragile path more interesting, so I think I'll
stick with the proposed patch -- again provided it actually works.

Marc, any word on that?
