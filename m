Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934984Ab1ETQLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:11:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab1ETQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:11:38 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=TwWXrjo8ZJIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=G4jmDrJihTkqbnudxUAA:9 a=ONuJFkVSduo62l_eeAEA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <1305907458.1465.23.camel@gandalf.stny.rr.com>
References: <201105191526.31904.toralf.foerster@gmx.de>
	 <201105192218.18261.toralf.foerster@gmx.de>
	 <20110519204342.GA10792@home.goodmis.org>
	 <201105200937.15322.toralf.foerster@gmx.de>
	 <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
	 <4DD68EDF.4030301@linux.intel.com>
	 <1305907458.1465.23.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 May 2011 12:11:36 -0400
Message-ID: <1305907896.1465.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 12:04 -0400, Steven Rostedt wrote:
> On Fri, 2011-05-20 at 08:55 -0700, Darren Hart wrote:
> 
> > I suspect Toralf is hitting the WARN_ON in __unqueue_futex:
> > 
> > 	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
> > 			|| plist_node_empty(&q->list)))
> > 
> > Toralf, can you instrument that let us know which of conditions is
> > triggering the WARN_ON? Something like the following should be adequate
> > to get you the line number. I suspect it is plist_node_empty give the
> > git bisect results you reported.
> > 
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index abd5324..7f31bca 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -782,8 +782,11 @@ static void __unqueue_futex(struct futex_q *q)
> >  {
> >  	struct futex_hash_bucket *hb;
> > 
> > -	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
> > -			|| plist_node_empty(&q->list)))
> > +	if (WARN_ON(!q->lock_ptr))
> > +		return;
> > +	if (!spin_is_locked(q->lock_ptr))
> > +		return;
> > +	if (plist_node_empty(&q->list))
> >  		return;
> > 
> 
> Wait! This is where we need the WARN_ON_SMP(), do we have that patch in?
> 
> I think UML is UP, and that spin_is_locked() will always return false.
> 

Could you apply these patches:

2092e6be WARN_ON_SMP(): Allow use in if() statements on UP
29096202 futex: Fix WARN_ON() test for UP

On top of this commit, and see if the problem goes away. What could have
happened, is that you have two bugs, with one of them fixed. If the git
bisect stumbled on this bug, it will show this one, even though later
on, this code was fixed. If you apply the above two patches and it works
again, then this isn't the bug you are looking for.

-- Steve


