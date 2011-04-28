Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab1D1THD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:07:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61766 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab1D1THA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:07:00 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=0i_OOtiXEx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=aXYQbwh8cayaqPI4AyYA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>
In-Reply-To: <BANLkTimg==qTO2=1VaeXFM8Gt5R_VFYLCA@mail.gmail.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-2-git-send-email-wad@chromium.org>
	 <20110428165525.GB1927@hallyn.com>
	 <1304010981.18763.192.camel@gandalf.stny.rr.com>
	 <20110428173957.GA25940@hallyn.com>
	 <BANLkTi=ukfidjHpKUr1vL67aQUFcNxXFeA@mail.gmail.com>
	 <1304014874.18763.201.camel@gandalf.stny.rr.com>
	 <BANLkTimg==qTO2=1VaeXFM8Gt5R_VFYLCA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 15:06:56 -0400
Message-ID: <1304017616.18763.204.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 13:34 -0500, Will Drewry wrote:

> > Perhaps, but those free standing functions (the ones that are exported
> > to modules) seem like they can destroy state.
> 
> My intent was to make them available for use by seccomp.c during state
> teardown/dup.  I don't think there's benefit to exposing them outside
> of that.  Would dropping the export, and adding an local seccomp.h
> with the shared functions in them resolve that more cleanly?

Yes, having a local seccomp.h in the same directory as seccomp.c is a
way of saying "these are internal functions, don't use them directly".
Adding a function to EXPORT_SYMBOL*() is saying "here you go, have a
field day with it!".


> 
> > Your code would have been correct if you could call kzalloc under
> > rcu_read_lock() (which you can on some kernel configurations but not
> > all). The issue is that you need to pull out that allocation from the
> > rcu_read_lock() because rcu_read_lock assumes you can't preempt, and
> > that allocation can schedule out. The access to the filters must be done
> > under rcu_read_lock(), other than that, you're fine.
> 
> That makes sense.  I think I'd prefer to not share those functions
> rather than guard the list just in case a future consumer of the
> interface comes along.  Would that make sense to you?  Since I don't
> see any other users right now other than seccomp.c, it might make
> sense to tackle the impact when an actual need arises.
> 
> I'll go whichever way pointed on this, though.
> thanks again,

I'm fine either way. If you make them local internal functions, then you
don't need the locking if they are safe in their current context.

-- Steve


