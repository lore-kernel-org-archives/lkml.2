Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0DWFkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:40:16 -0400
Received: from 1wt.eu ([62.212.114.60]:63503 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab0DWFkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:40:14 -0400
Date: Fri, 23 Apr 2010 07:38:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       tglx@linutronix.de, davej@redhat.com, cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Message-ID: <20100423053858.GE7798@1wt.eu>
References: <20100418115949.7b743898@infradead.org> <20100418120346.1b478410@infradead.org> <20100423052439.GB4829@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423052439.GB4829@ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 07:24:39AM +0200, Pavel Machek wrote:
> Hi!
> 
> > The ondemand cpufreq governor uses CPU busy time (e.g. not-idle time) as
> > a measure for scaling the CPU frequency up or down.
> > If the CPU is busy, the CPU frequency scales up, if it's idle, the CPU
> > frequency scales down. Effectively, it uses the CPU busy time as proxy
> > variable for the more nebulous "how critical is performance right now"
> > question.
> > 
> > This algorithm falls flat on its face in the light of workloads where
> > you're alternatingly disk and CPU bound, such as the ever popular
> > "git grep", but also things like startup of programs and maildir using
> > email clients... much to the chagarin of Andrew Morton.
> > 
> > This patch changes the ondemand algorithm to count iowait time as busy,
> > not idle, time. As shown in the breakdown cases above, iowait is performance
> > critical often, and by counting iowait, the proxy variable becomes a more
> > accurate representation of the "how critical is performance"
> > question.
> 
> Well, and now, if you do something like cat /dev/<your usb1.1 hdd> >
> /dev/null, you'll keep cpu on max frequency. Not a problem for new
> core i7, but probably big deal for athlon 64.

So that also means that my notebook's CPU fan will spin like mad as soon
as I access a USB key ? It will not help the key go faster...

Probably that iowait should only change the time required to go back to
low frequency. That way, if there is no CPU nor I/O activity, we can
switch back to a low frequency quickly, but if we see I/O activity, we
could decide to wait for 1 second (for instance) for CPU idle before
switching back to low frequency.

> Maybe modern cpus can and should simply react faster?

It's above all that we should not try to switch too fast if we know the
CPU can't follow.

Willy

