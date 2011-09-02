Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1IBOTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:19:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:38497 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1IBOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:19:11 -0400
Date: Fri, 2 Sep 2011 16:19:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
In-Reply-To: <1314964198.2573.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.LFD.2.02.1109021615270.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>  <1314661157-22173-4-git-send-email-andi@firstfloor.org>  <alpine.LFD.2.02.1109021135270.2723@ionos> <1314964198.2573.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-252739564-1314973146=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-252739564-1314973146=:2723
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 2 Sep 2011, Eric Dumazet wrote:

> Le vendredi 02 septembre 2011 à 12:06 +0200, Thomas Gleixner a écrit :
> 
> > ------------------>
> > Subject: posix-timers: Simplify deletion protection
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Fri, 02 Sep 2011 11:59:14 +0200
> > 
> > k_itimer->it_signal is soleley used to protect a timer lookup against
> > a concurrent deletion. We can use k_itimer->list for the same purpose.
> > 
> 
> Well, this patch is wrong too, unless you base it after Andi patch 1/4
> (move global timer id management to signal_struct)

I know, it's not for the current code.
 
> The test is also present to make sure one process doesnt try to use a
> timer_id of another process.

Right, but after moving the idr into sig struct it's only purpose is
to protect against deletion, which is nicely covered by the list_head
check as well.

Thanks,

	tglx

> 
> > @@ -643,7 +643,7 @@ static struct k_itimer *__lock_timer(tim
> >  	timr = idr_find(&posix_timers_id, (int)timer_id);
> >  	if (timr) {
> >  		spin_lock_irqsave(&timr->it_lock, *flags);
> > -		if (timr->it_signal == current->signal) {
> > +		if (!list_empty(&timr->list)) {
> >  			rcu_read_unlock();
> >  			return timr;
> >  		}
> 
> 
> 
> 
--8323328-252739564-1314973146=:2723--
