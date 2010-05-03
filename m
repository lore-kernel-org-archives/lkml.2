Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab0ECViF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:38:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0ECVh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:37:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Date: Mon, 3 May 2010 23:38:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Arve Hj??nnev??g" <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005022329.48309.rjw@sisk.pl> <20100503190136.GA4173@ucw.cz>
In-Reply-To: <20100503190136.GA4173@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005032338.26439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 May 2010, Pavel Machek wrote:
> Hi!
> 
> > > > > As I explained before (and got no reply),  the proposed interface is
> > > > > ugly. It uses one sysfs file to change semantics of another one.
> > > > 
> > > > In fact this behavior was discussed at the LF Collab Summit and no one
> > > > involved had any problem with that.
> > > 
> > > Well, I explained why I disliked in previous mail in more details,
> > 
> > We do exactly the same thing with 'pm_test', so I'm not sure what the problem is.
> > 
> > > and neither you nor Arve explained why it is good solution.
> > 
> > Because it's less confusing.  Having two different attributes returning
> > almost the same contents and working in a slightly different way wouldn't be
> > too clean IMO.
> 
> No, I don't think it is similar to pm_test. pm_test is debug-only, and
> orthogonal to state -- all combinations make sense.
> 
> With 'oportunistic > policy', state changes from blocking to
> nonblocking (surprise!). Plus, it is not orthogonal:
> 
> (assume we added s-t-flash on android for powersaving... or imagine I
> get oportunistic suspend working on PC --I was there with limited
> config on x60).
> 
> policy: oportunistic forced
> 
> state: on mem disk
> 
> First disadvantage of proposed interface is that while 'opportunistic
> mem' is active, I can't do 'forced disk' to save bit more power.
> 
> Next, not all combinations make sense.
> 
> oportunistic on == forced <nothing>

That's correct, but the "opportunistic on" thing is there to avoid switching
back and forth from "opportunistic" to "forced".  So that's a matter of
convenience rather than anything else.

> oportunistic disk -- probably something that will not be implemented
> any time soon.

Yes, and that's why "disk" won't work with "opportunistic" for now.

> oportunistic mem -- makes sense.
> 
> forced on -- NOP

There won't be "on" with "forced" (that probably needs changing at the moment).

> forced mem  -- makes sense.
> 
> forced disk -- makes sense.
> 
> So we have matrix of 7 possibilities, but only 4 make sense... IMO its confusing.

The main problem is that the entire suspend subsystem is going to work in a
different way when suspend blockers are enforced.  Thus IMO it makes sense to
provide a switch between the "opportunistic" and "forced" modes, because that
clearly indicates to the user (or user space in general) how the whole suspend
subsystem actually works at the moment.

As long as it's "opportunistic", the system will autosuspend if suspend
blockers are not active and the behavior of "state" reflects that.  If you want
to enforce a transition, switch to "forced" first.

That's not at all confusing if you know what you're doing.  The defailt mode is
"forced", so the suspend subsystem works "as usual" by default.  You have to
directly switch it to "opportunistic" to change the behavior and once you've
done that, you shouldn't really be surprised that the behavior has changed.
That's what you've requested after all.

So no, I don't really think it's confusing.

Thanks,
Rafael
