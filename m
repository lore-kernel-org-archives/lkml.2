Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1BHQyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:54:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1BHQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:54:24 -0500
Subject: Re: Regression: WARNINGS and lockdep spews in 2.6.38-rc3+
 (bisected).
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110203114218.GA1809@zhy>
References: <20110203031943.GA8910@elliptictech.com>
	 <20110203091227.GA1603@zhy> <1296725440.26581.354.camel@laptop>
	 <20110203101739.GA1551@zhy> <1296729184.26581.361.camel@laptop>
	 <20110203114218.GA1809@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 17:55:27 +0100
Message-ID: <1297184127.13327.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 19:42 +0800, Yong Zhang wrote:
> My patch is inspired by this http://lkml.org/lkml/2010/8/16/291

Right, so that splat warns about:

spin_lock_irqsave(&shost->host_lock);
del_timer_sync()
  spin_lock_irqsave(&t->split_timeout_timer);

vs

<SOFTIRQ>
  call_timer_fn()
    spin_lock(&t->split_timeout_timer);
    <IRQ>
      spin_lock_irqsave(&shost->host_lock);

Which Steven just pointed out is an actual deadlock because:


CPU0					CPU1
spin_lock_irqsave(&shost->host_lock);
					<SOFTIRQ>
					  call_timer_fn();
					    base->running_timer = timer;
					    func();
					      <IRQ>
						spin_lock(&shost->host_lock);
del_timer_sync()
  while(base->running_timer == timer);

And the world stops turning..


Also note that your patch changes the above to:

spin_lock_irqsave(&shost->host_lock);
del_timer_sync()
  spin_lock_bh(&t->split_timeout_timer);

Which wouldn't make one bit of difference.

