Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2A0BLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:11:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2A0BK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:10:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 Jan 2012 10:09:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Message-Id: <20120127100933.5e782a33.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120126164342.a496ded0.akpm@linux-foundation.org>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
	<20120124161221.032325d1.akpm@linux-foundation.org>
	<1327450945.14373.24.camel@edumazet-laptop>
	<20120124172732.19b3d9f4.akpm@linux-foundation.org>
	<1327469372.14373.31.camel@edumazet-laptop>
	<20120125170416.385ee9fa.akpm@linux-foundation.org>
	<20120126185520.25c8f9b6.kamezawa.hiroyu@jp.fujitsu.com>
	<20120126164342.a496ded0.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 16:43:42 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Jan 2012 18:55:20 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Wed, 25 Jan 2012 17:04:16 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 25 Jan 2012 06:29:32 +0100
> > > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > 
> > > > Le mardi 24 janvier 2012 __ 17:27 -0800, Andrew Morton a __crit :
> > > > 
> > > > > I had a fiddle on an 8-way x86_64 machine.  I'm unable to demonstrate
> > > > > any improvement for either of
> > > > > 
> > > > > time (for i in $(seq 1000); do; cat /proc/self/stat > /dev/null; done)
> > > > > time (for i in $(seq 1000); do; cat /proc/1/stat > /dev/null; done)
> > > > > 
> > > > > oh well.
> > > > 
> > > > What size is /proc/stat ?
> > > 
> > > About 40mm, but it depends on the font size.
> > > 
> > > > wc -c /proc/stat
> > > > 
> > > > If under 4096, there is no problem with existing code.
> > > 
> > > akpm2:/home/akpm> wc -c /proc/stat 
> > > 2800 /proc/stat
> > > 
> > > > I had the problem on a 16-way machine.
> > > 
> > > OK..
> > 
> > 
> > I wrote following patch just for my fun, which makes /proc/stat twice fast.
> > But I'm not sure whether this kind of dirty && special printk is worth to do or not..
> > because I can't see /proc/stat cost at shell-scripting.
> 
> It is rather a lot of not-very-general infrastructure.
> 
> >
> > ...
> >
> > @@ -131,8 +143,8 @@ static int show_stat(struct seq_file *p, void *v)
> >  	seq_printf(p, "intr %llu", (unsigned long long)sum);
> >  
> >  	/* sum again ? it could be updated? */
> > -	for_each_irq_nr(j)
> > -		seq_printf(p, " %u", kstat_irqs(j));
> > +	j = 0;
> > +	seq_printnum_batch(p, " %u", &j, get_next_kstat_irq);
> 
> I expect most of these numbers are zero.  I wonder if we would get
> useful speedups from
> 
> 	for_each_irq_nr(j) {
> 		/* Apologetic comment goes here */
> 		if (kstat_irqs(j))
> 			seq_printf(p, " %u", kstat_irqs(j));
> 		else
> 			seq_puts(p, " 0");
> 	}

Yes. This is very good optimization and shows much optimization.
I did this at first try  but did complicated ones because it seems
not interesting. (This is my bad habit...)

I'll try again and measure time.

Thanks,
-Kame




