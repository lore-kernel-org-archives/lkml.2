Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1HSMKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:10:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:27291 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab1HSMKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,250,1312182000"; 
   d="scan'208";a="8913152"
Subject: Re: Hanging threads with pthread_detach and gdb
From: Lin Ming <ming.m.lin@intel.com>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Philipp Marek <philipp.marek@linbit.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201108191128.09930.pedro@codesourcery.com>
References: <201108161458.35774.philipp.marek@linbit.com>
	 <CAF1ivSZ-CCzFUH4WtxqL2QBoyB3WtF+KMqnCBdjaHhZ7-bbVjA@mail.gmail.com>
	 <1313744083.4115.206.camel@minggr.sh.intel.com>
	 <201108191128.09930.pedro@codesourcery.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 19 Aug 2011 20:08:01 +0800
Message-ID: <1313755681.2379.2.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 18:28 +0800, Pedro Alves wrote:
> On Friday 19 August 2011 09:54:43, Lin Ming wrote:
> > =====
> > gdb wait for pid=2431
> > gdb is going to sleep ...
> > gdb children list:
> >     pid=2431, exit_state=16, exit_signal=17
> > gdb ptrace list:
> >     pid=2436, exit_state=16, exit_signal=-1
> >     pid=2431, exit_state=16, exit_signal=17
> > =====
> > 
> > exit_state 16 is EXIT_ZOMBIE state.
> > pid 2431 is the thread group leader.
> > pid 2436 is the thread group member(other members have been removed).
> > 
> > gdb is waiting the group leader, but it fails because the group is not
> > empty. Then gdb goes to sleep.
> > 
> > At this moment, all threads have gone into EXIT_ZOMBIE state.
> > So no thread can wake up gdb anymore.
> > 
> > That's why gdb hangs.
> > 
> > I'm not familiar with pthread semantics.
> > Is this a problem need to be fixed?
> > 
> 
> Yeah, it's an ugly ptrace quirk.  waitpid'ing the exited
> tg leader hangs if there are other threads in the group,
> even if they're zombies.
> 
> I believe this is fixed / worked around mainline GDB:
> 
>  http://sourceware.org/bugzilla/show_bug.cgi?id=10970
>  http://sourceware.org/bugzilla/show_bug.cgi?id=12702
>  http://sourceware.org/ml/gdb-patches/2011-05/msg00401.html
> 
> Though it'd be nice not to need the workaround...

Thanks for the info.

I still wonder if this is fixable in kernel.

