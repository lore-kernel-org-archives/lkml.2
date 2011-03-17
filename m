Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab1CQSQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:16:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1CQSQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:16:45 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=MpKEIbNVzpcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JdiTLEUdHxpx7JvBJyQA:9 a=xK0yCpzSZx3Xi7HWWNcA:7 a=JJZiMWjrrj9WT1Zq3-4FaH0On4wA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
In-Reply-To: <1300381340.6315.323.camel@edumazet-laptop>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	 <1300370936.16880.96.camel@gandalf.stny.rr.com>
	 <AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	 <1300380909.16880.264.camel@gandalf.stny.rr.com>
	 <1300381340.6315.323.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 14:16:42 -0400
Message-ID: <1300385802.16880.348.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 18:02 +0100, Eric Dumazet wrote:
> Le jeudi 17 mars 2011 à 12:55 -0400, Steven Rostedt a écrit :
> > Here, test this patch. I'm in the process of committing it now.
> > It will be two patches, one for the WARN_ON_SMP() change, the other for
> > the futex change.
> > 
> > -- Steve
> > 
> > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> > index c2c9ba0..25f1e9e 100644
> > --- a/include/asm-generic/bug.h
> > +++ b/include/asm-generic/bug.h
> > @@ -168,7 +168,7 @@ extern void warn_slowpath_null(const char *file, const int line);
> >  #ifdef CONFIG_SMP
> >  # define WARN_ON_SMP(x)			WARN_ON(x)
> >  #else
> > -# define WARN_ON_SMP(x)			do { } while (0)
> > +# define WARN_ON_SMP(x)			({0;})
> >  #endif
> >  
> 
> You meant :
> 
> # define WARN_ON_SMP(x)			({x;})
> 
> or
> 
> # define WARN_ON_SMP(x)	  do { } while (x, 0)
> 
> ?
> 

Does if (do { } while (x, 0)) work?

And no, on SMP it should always return false. The point is, the warning
is only valid if we are on an SMP box, this is useful for spin_locks()

if (WARN_ON_SMP(!spin_is_locked(lock)))
	fail();

We don't want to fail.

That spin_is_locked(lock) on !SMP returns 0 every time.

-- Steve


