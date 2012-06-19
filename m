Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab2FSJ5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:57:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36200 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2FSJ5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:57:41 -0400
Message-ID: <1340099851.21745.35.camel@twins>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Charles Wang <muming.wq@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Tao Ma <tm@tao.ma>,
        =?UTF-8?Q?=E5=90=AB=E9=BB=9B?= <handai.szj@taobao.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 19 Jun 2012 11:57:31 +0200
In-Reply-To: <4FE01B2F.9050805@gmail.com>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
	   <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
	  <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>
	 <1340035417.15222.95.camel@twins> <4FE01B2F.9050805@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 14:24 +0800, Charles Wang wrote:
> > +static inline int calc_load_write_idx(void)
> >  {
> > +     int idx = calc_load_idx;
> > +
> > +     /*
> > +      * See calc_global_nohz(), if we observe the new index, we also
> > +      * need to observe the new update time.
> > +      */
> > +     smp_rmb();
> > +
> > +     /*
> > +      * If the folding window started, make sure we start writing in the
> > +      * next idle-load delta.
> > +      */
> > +     if (!time_before(jiffies, calc_load_update))
> > +             idx++;
> 
> Can we just take calc_load_update as the start time-line here?  Will
> there be different ticks between cpus? 

I'm not exactly sure what you're asking, but yes and probably yes.

The per-cpu ticks are separate, but on the same time-line. That is, they
don't happen at the exact same moment, either due to per-cpu IRQ
disabling or because the architecture spreads the tick. But they do all
get HZ ticks per second.

Remember, jiffies is a global timeline, and the global calc_load_update
is the last to be moved fwd to the next period, so its ideally suited to
be used to determine the current window.
