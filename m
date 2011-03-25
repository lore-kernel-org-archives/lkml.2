Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1CYNKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:10:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1CYNKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:10:02 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=a_0UJ9UWJWAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=-GPMe9L4I35PLgIbgT4A:9 a=rEoz47Rz_URJoHmdn0MwARxZfaUA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
In-Reply-To: <20110325065300.GB1409@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325033956.GB9313@home.goodmis.org>
	 <AANLkTikayCJyYVo1MNpg1EN+88bSQNOu=NPW5s_j4shD@mail.gmail.com>
	 <20110325065300.GB1409@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 09:10:00 -0400
Message-ID: <1301058600.14261.172.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 07:53 +0100, Tejun Heo wrote:
> Hello, Steven, Linus.
> 
> On Thu, Mar 24, 2011 at 09:38:58PM -0700, Linus Torvalds wrote:
> > On Thu, Mar 24, 2011 at 8:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > But now, mutex_trylock(B) becomes a spinner too, and since the B's owner
> > > is running (spinning on A) it will spin as well waiting for A's owner to
> > > release it. Unfortunately, A's owner is also spinning waiting for B to
> > > release it.
> > >
> > > If both A and B's owners are real time tasks, then boom! deadlock.
> > 
> > Hmm. I think you're right. And it looks pretty fundamental - I don't
> > see any reasonable approach to avoid it.
> 
> Hmmm... I have an idea.  Will play with it a bit and post if it works
> out okay.

One solution is to have this be only done on explicit trylocks. Perhaps
introduce a mutex_trylock_spin()? Then when the developer knows that
this scenario does not exist, they can convert mutex_trylocks() into
this spinning version.

> 
> > I think the RT issue is a red herring too - afaik, you can get a
> > deadlock with two perfectly normal processes too. Of course, for
> > non-RT tasks, any other process will eventually disturb the situation
> > and you'd get kicked out due to need_resched(), but even that might be
> > avoided for a long time if there are other CPU's - leading to tons of
> > wasted CPU time.
> 
> Yeap, need_resched() currently is the only thing which limits the
> duration of spinning when the owner continues to run.

Yeah, I was about to complain about the long latencies that this could
cause, then I realized that RT tasks would in fact deadlock the system
here, which I thought was a bigger problem, and focused on that issue.

-- Steve


