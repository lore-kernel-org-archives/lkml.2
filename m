Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1DDQPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:15:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953Ab1DDQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:15:13 -0400
Date: Mon, 4 Apr 2011 09:16:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] scheduler fixes
Message-Id: <20110404091610.752338c9.akpm@linux-foundation.org>
In-Reply-To: <BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
References: <20110402103125.GA18746@elte.hu>
	<BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 08:45:34 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I pulled this, but I think this:
> 
> On Sat, Apr 2, 2011 at 3:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > -               if (interval > HZ*NR_CPUS/10)
> > -                       interval = HZ*NR_CPUS/10;
> > +               if (interval > HZ*num_online_cpus()/10)
> > +                       interval = HZ*num_online_cpus()/10;
> 
> is a horrible patch.
> 
> Think about what that expands to. It's going to potentially be two
> function calls. And the code is just ugly.
> 
> So please, when doing search-and-replace changes like this, just clean
> up the code at the same time. Back when it was about pure constants,
> there was only a typing/ugly overhead from duplicating the constant,
> but the compiler would see a single constant.
> 
> Now it's _possible_ that the compiler could do the analysis and fold
> it all back to a single thing. But it's unlikely to happen except for
> configurations that end up making it all trivial.
> 
> So just add something like a
> 
>    int max_interval = HZ*num_online_cpus()/10;
> 
> possibly even with a comment about _why_ that is the max interval allowed.  Ok?
> 

max() conveniently avoids the double-evaluation:

#define max(x, y) ({				\
	typeof(x) _max1 = (x);			\
	typeof(y) _max2 = (y);			\
	(void) (&_max1 == &_max2);		\
	_max1 > _max2 ? _max1 : _max2; })

