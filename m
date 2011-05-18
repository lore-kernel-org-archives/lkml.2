Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab1ERTO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:14:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55053 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933451Ab1ERTOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:14:54 -0400
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
From: John Stultz <john.stultz@linaro.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110518062554.GB2945@elte.hu>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
	 <20110518062554.GB2945@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 12:03:29 -0700
Message-ID: <1305745409.2915.178.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 08:25 +0200, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
> > Since my commit 4614a696bd1c3a9af3a08f0e5874830a85b889d4, the current->comm 
> > value could be changed by other threads.
> > 
> > This changed the comm locking rules, which previously allowed for unlocked 
> > current->comm access, since only the thread itself could change its comm.
> > 
> > While this was brought up at the time, it was not considered problematic, as 
> > the comm writing was done in such a way that only null or incomplete comms 
> > could be read. However, recently folks have made it clear they want to see 
> > this issue resolved.
> 
> The commit is from 2.5 years ago:
>         4614a696bd1c3a9af3a08f0e5874830a85b889d4
>         Author: john stultz <johnstul@us.ibm.com>
>         Date:   Mon Dec 14 18:00:05 2009 -0800
> 
>             procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm
> 
> So we are *way* beyond the time frame where this could be declared urgent.

Oh yes. I'm not declaring it urgent. I'm just trying to get the
groundwork in so the "cleanup" can happen over time.

> So is there any actual motivation beyond:
> 
>   " Hey, this looks a bit racy and 'top' very rarely, on rare workloads that 
>     play with ->comm[], might display a weird reading task name for a second, 
>     amongst the many other temporarily nonsensical statistical things it 
>     already prints every now and then. "
> 
> ?

To my knowledge no. Basically folks were grumbling about the issue, and
so being that I opened the issue up, I figured I'd try to address their
concerns. While specific examples of the problem were not raised
(despite asking for them), I figured a good faith attempt at providing a
path to proper locking for comm was a more productive step then getting
into "prove its safe" / "no, you prove its unsafe" type debates.

My motivation here is just to try to do the right thing and move on to
other work, and that is maybe why I seem hurried to get the patches
queued.

The other reasonable argument in my mind would be: Even if there is no
existing issue, comm locking rules are subtle and by formalizing them
we avoid future problems being introduced (probably by folks like me :).

> > So fair enough, as I opened this can of worms, I should work
> > to resolve it and this patchset is my initial attempt.
> 
> This patch set does not address the many places that deal with ->comm so it 
> does not even approximate the true scope of the change!
> 
> I.e. you are doing *another* change without fully seeing/showing the 
> consequences ...

Well, is requiring all the comm changes in one patch set really
reasonable? I'm aware its a large scope of changes. It touches
everything and will take quite a while to in order to get all of the
changes pushed through the various relevant maintainers. A path for
gradual "improvement" seems like the only reasonable approach.

Or do you have another suggestion in mind?

But given that I'm providing both locked and unlocked accessors, doesn't
it seem that by working through the tree converting to those accessors
would help actually audit the users, so we can address that each call
site can either deal with the locking or handle incomplete comms?
Further, if other locking approaches (such as RCU) are to be tried, it
would greatly ease doing so, since the access is centralized to a few
functions.

So is such a change not somewhat worthwhile?

But, the net of this is that it seems everyone else is way more
passionate about this issue then I am, so I'm starting to wonder if it
would be better for someone who has more of a dog in the fight to be
pushing these?

thanks
-john

