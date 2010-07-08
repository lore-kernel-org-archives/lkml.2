Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0GHJj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:39:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:41115 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab0GHJj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:39:26 -0400
Date: Thu, 8 Jul 2010 11:39:19 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH] futex: futex_find_get_task remove credentails check
Message-ID: <20100708093919.GC4925@tiehlicka.suse.cz>
References: <20100628155845.GC24127@tiehlicka.suse.cz>
 <20100628163952.GD24127@tiehlicka.suse.cz>
 <1277743748.3561.139.camel@laptop>
 <20100629084230.GE6215@tiehlicka.suse.cz>
 <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
 <20100630070115.GB3890@tiehlicka.suse.cz>
 <20100630095525.GA5840@tiehlicka.suse.cz>
 <4C2B742F.6050403@us.ibm.com>
 <20100708092819.GB4925@tiehlicka.suse.cz>
 <20100708093241.GB6057@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708093241.GB6057@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-07-10 11:32:41, Ingo Molnar wrote:
> 
> * Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Wed 30-06-10 09:43:27, Darren Hart wrote:
> > > On 06/30/2010 02:55 AM, Michal Hocko wrote:
> > > >On Wed 30-06-10 09:01:15, Michal Hocko wrote:
> > > >>On Tue 29-06-10 09:41:02, Linus Torvalds wrote:
> > > >>>On Tue, Jun 29, 2010 at 1:42 AM, Michal Hocko<mhocko@suse.cz>  wrote:
> > > >>>>
> > > >>>>futex_find_get_task is currently used (through lookup_pi_state) from two
> > > >>>>contexts, futex_requeue and futex_lock_pi_atomic. While credentials check
> > > >>>>makes sense in the first code path, the second one is more problematic
> > > >>>>because this check requires that the PI lock holder (pid parameter) has
> > > >>>>the same uid and euid as the process's euid which is trying to lock the
> > > >>>>same futex (current).
> > > >>>
> > > >>>So exactly why does it make sense to check the credentials in the
> > > >>>first code path then?
> > > >>
> > > >>I though that requeue needs this for security reasons (don't let requeue
> > > >>process for other user), but when I thought about that again you are
> > > >>right and the only what matters should be accessibility of the shared
> > > >>memory.
> > > >
> > > >And here is the patch which does the thing.
> > > >
> > > >--
> > > >
> > > > From 082c5ad2c482a8e78b61b17e213e750b006176aa Mon Sep 17 00:00:00 2001
> > > >From: Michal Hocko<mhocko@suse.cz>
> > > >Date: Wed, 30 Jun 2010 09:51:19 +0200
> > > >Subject: [PATCH] futex: futex_find_get_task remove credentails check
> > > >
> > > >futex_find_get_task is currently used (through lookup_pi_state) from two
> > > >contexts, futex_requeue and futex_lock_pi_atomic. None of the paths
> > > >looks it needs the credentials check, though. Different (e)uids
> > > >shouldn't matter at all because the only thing that is important for
> > > >shared futex is the accessibility of the shared memory.
> > > >
> > > >The credentail check results in glibc assert failure or process hang (if
> > > >glibc is compiled without assert support) for shared robust pthread
> > > >mutex with priority inheritance if a process tries to lock already held
> > > >lock owned by a process with a different euid:
> > > >
> > > >pthread_mutex_lock.c:312: __pthread_mutex_lock_full: Assertion `(-(e)) != 3 || !robust' failed.
> > > >
> > > >The problem is that futex_lock_pi_atomic which is called when we try to
> > > >lock already held lock checks the current holder (tid is stored in the
> > > >futex value) to get the PI state. It uses lookup_pi_state which in turn
> > > >gets task struct from futex_find_get_task. ESRCH is returned either when
> > > >the task is not found or if credentials check fails.
> > > >futex_lock_pi_atomic simply returns if it gets ESRCH. glibc code,
> > > >however,  doesn't expect that robust lock returns with ESRCH because it
> > > >should get either success or owner died.
> > > >
> > > >Signed-off-by: Michal Hocko<mhocko@suse.cz>
> > > 
> > > Without hearing back from Ingo on the original intent of the
> > > credentials check, this looks right to me.
> > 
> > Could you comment on that Ingo, please?
> 
> I think that's more of a question to Thomas :-)
> 
> My memories are hazy and nothing springs out as some credible original intent. 
> So please assume it doesnt exist :-)

OK, so do you need an ACK from Thomas, or can you grab the patch and
push it through one of your trees?

> 
> 	Ingo

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
