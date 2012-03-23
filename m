Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2CWVRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:17:08 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51581 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2CWVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:17:06 -0400
Date: Fri, 23 Mar 2012 14:16:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.4
Message-ID: <20120323211638.GA2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120319152317.GA3932@gmail.com>
 <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com>
 <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
 <20120323192143.GY2450@linux.vnet.ibm.com>
 <CA+55aFzgno-7AcHxKMWGYrr2QAwEzXOieSghnsEfPQJ5aed-yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzgno-7AcHxKMWGYrr2QAwEzXOieSghnsEfPQJ5aed-yQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032321-7408-0000-0000-000003ADF8C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 12:39:59PM -0700, Linus Torvalds wrote:
> On Fri, Mar 23, 2012 at 12:21 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >> Please? Every time I look at some profiles, that silly rcu_read_lock
> >> is there in the profile. It's annoying. I'd rather see it in the
> >> function that invokes it.
> >
> > Let me see what I can do...
> 
> Thanks. To some degree, rcu_read_lock() is the more critical one,
> because it is often in the much more critical path in the caller. In
> particular, it's often at the beginning of a function, where a number
> of arguments are "live", and calling it out-of-line also forces the
> compiler to then save/restore those arguments (because they are
> clobbered by the function call).
> 
> rcu_read_unlock() is *usually* not as critical, and is obviously much
> harder to inline anyway due to the whole complexity with needing to
> check if an RCU sequence has ended. It often is at the end of the
> function call in the caller, when the only thing like is often just
> the single return value (if that). So it seldom looks nearly as bad in
> any profiles, because it doesn't tend to have the same kind of bad
> impact on the call site.

Very good to hear!  Especially since I am not seeing how to move
->rcu_read_unlock_special to a per-CPU variable given that rcu_boost()
needs cross-task access to it.  There is probably some obvious trick,
but I will start with just __rcu_read_lock() for now.

							Thanx, Paul

