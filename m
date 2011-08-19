Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1HSK2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:28:14 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:43613 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1HSK2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:28:13 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: Hanging threads with pthread_detach and gdb
Date: Fri, 19 Aug 2011 11:28:09 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-10-generic; KDE/4.7.0; x86_64; ; )
Cc: Philipp Marek <philipp.marek@linbit.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <201108161458.35774.philipp.marek@linbit.com> <CAF1ivSZ-CCzFUH4WtxqL2QBoyB3WtF+KMqnCBdjaHhZ7-bbVjA@mail.gmail.com> <1313744083.4115.206.camel@minggr.sh.intel.com>
In-Reply-To: <1313744083.4115.206.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108191128.09930.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 August 2011 09:54:43, Lin Ming wrote:
> =====
> gdb wait for pid=2431
> gdb is going to sleep ...
> gdb children list:
>     pid=2431, exit_state=16, exit_signal=17
> gdb ptrace list:
>     pid=2436, exit_state=16, exit_signal=-1
>     pid=2431, exit_state=16, exit_signal=17
> =====
> 
> exit_state 16 is EXIT_ZOMBIE state.
> pid 2431 is the thread group leader.
> pid 2436 is the thread group member(other members have been removed).
> 
> gdb is waiting the group leader, but it fails because the group is not
> empty. Then gdb goes to sleep.
> 
> At this moment, all threads have gone into EXIT_ZOMBIE state.
> So no thread can wake up gdb anymore.
> 
> That's why gdb hangs.
> 
> I'm not familiar with pthread semantics.
> Is this a problem need to be fixed?
> 

Yeah, it's an ugly ptrace quirk.  waitpid'ing the exited
tg leader hangs if there are other threads in the group,
even if they're zombies.

I believe this is fixed / worked around mainline GDB:

 http://sourceware.org/bugzilla/show_bug.cgi?id=10970
 http://sourceware.org/bugzilla/show_bug.cgi?id=12702
 http://sourceware.org/ml/gdb-patches/2011-05/msg00401.html

Though it'd be nice not to need the workaround...

-- 
Pedro Alves
