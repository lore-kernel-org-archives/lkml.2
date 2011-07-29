Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1G2VhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:37:08 -0400
Received: from waste.org ([173.11.57.241]:59720 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab1G2VhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:37:05 -0400
Subject: Re: Nanosecond fs timestamp support: sad
From: Matt Mackall <mpm@selenic.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110729194903.GA1720@ucw.cz>
References: <m2pql2c0qz.fsf@firstfloor.org>
	 <20110722163335.2df4f6ca@notabene.brown> <1311363269.14555.261.camel@calx>
	 <20110722205922.GS8006@one.firstfloor.org>
	 <1311369102.14555.268.camel@calx>
	 <20110722214732.GW8006@one.firstfloor.org>
	 <20110722221039.GB10749@fieldses.org> <20110722223158.GC10749@fieldses.org>
	 <20110723085915.308ddc02@notabene.brown> <1311379661.20898.23.camel@calx>
	 <20110729194903.GA1720@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 16:37:01 -0500
Message-ID: <1311975421.20898.400.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 21:49 +0200, Pavel Machek wrote:
> Hi!
> 
> > > If not, we probably should tell NFSv4 to use timestamps and focus on making
> > > them work well.
> > > ??
> > > 
> > > The timestamp used doesn't need to update ever nanosecond.  I think if it
> > > were just updated on every userspace->kernel transition  (or effective
> > > equivalents inside kernel threads) that would be enough capture all
> > > causality.  I wonder how that would be achieved..  I wonder if RCU machinery
> > > could help - doesn't it keep track of when threads schedule ... or something?
> > 
> > Sort of.
> > 
> > Some observations:
> > 
> > - we only need to go to higher resolution when two events happen in the
> > same time quantum
> > - this applies at both the level of seconds and jiffies
> > - if the only file touched in a given quantum gets touched ago, we don't
> > need to update its timestamp if stat wasn't also called on it in this
> > quantum
> 
> parse error aroound 'ago'.

This should read:

- if only one file is touched in a given quantum, we don't need to
update its timestamp if stat wasn't called on it in the same quantum

> > - we never need to use a higher resolution than the global
> > min(s_time_gran)
> > 
> > 
> > For instance, if a machine is idle, except for writing to a single file
> > once a second, 1s resolution suffices.
> 
> Are you sure? As soon as you get network communication...

I don't think you can generally compare filesystem timestamps to other
time sources reliably. For instance, network filesystems might have
their own notions of current time.

> > Any time two files are touched in the same second, the second one (and
> > later files) needs jiffies resolution. Similarly, any time two files are
> > touched in the same jiffy, the second one should use gtod().
> 
> For make. I don't see how this is globally true.
> 
> I do
> 
> ( date; > stamp; date ) | ( sleep 5; cat > counterexample )
> 
> I know timestamp should be between two dates, but it is not.

You're claiming the timestamp on 'stamp' should be strictly between the
two dates reported?

This is true today if and only if you measure in seconds (and your
filesystem's clock is synced with your local clock). If you measure in
resolutions greater than the filesystem resolution (currently limited to
jiffies) even on a local filesystem, it will be wrong.

-- 
Mathematics is the supreme nostalgia of our time.


