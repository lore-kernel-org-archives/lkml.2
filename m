Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0GIAl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab0GIAlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:41:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: paulmck@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
In-Reply-To: Paul E. McKenney's message of  Thursday, 24 June 2010 20:37:44 -0700 <20100625033744.GC2391@linux.vnet.ibm.com>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621205128.GI2354@linux.vnet.ibm.com>
	<20100622212357.GA19670@redhat.com>
	<20100622221226.GP2290@linux.vnet.ibm.com>
	<20100623152421.GA8445@redhat.com>
	<20100624180726.GK2373@linux.vnet.ibm.com>
	<20100624211446.5713743188@magilla.sf.frob.com>
	<20100625033744.GC2391@linux.vnet.ibm.com>
Emacs: because extension languages should come with the editor built in.
Message-Id: <20100709004103.BF95D4A967@magilla.sf.frob.com>
Date: Thu,  8 Jul 2010 17:41:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason for my "destroying the old" and "forming the new" is the
> possibility of someone doing proc_task_readdir() when the group leader
> does exec(), which causes all to die, and then the new process does
> pthread_create(), forming a new thread group.  Because proc_task_readdir()
> neither holds a lock nor stays in an RCU read-side critical section
> for the full /proc scan, the old group might really be destroyed from
> the reader's point of view.

I haven't tried to understand the /proc code.  From the userland
perspective, there is one thing called a "process" with a single ID that
the kernel calls the TGID and everybody else calls the PID, and that
container survives execs regardless of which of its threads do them.
Listing /proc/TGID/task is the way userland (i.e. debuggers) enumerate all
the threads (e.g. for attaching them all with ptrace).  It's of course
expected that threads will be coming and going, so userland expects to read
it several times, until there were no new threads in the list after it
attached all the ones from the last read (so it would know if those ones
created any more).  

I can't quite tell but it sounds like you may be saying that this procedure
won't work with rewinding the same fd.  After an exec, that fd may point to
a reaped former leader and yield no results.  (Looking at the code now, it
looks like readdir will fail with the unusual error ENOENT in that case, so
userland could detect that case easily now.)  To pick up the next iteration
of that procedure correctly, you'd have to reopen /proc/TGID/task by name
to get an fd associated with the new leader.  That is the only thing I can
think of that is meaningful in userland terms and might be what you mean by
"destroying the old and forming the new".  Is that it?

But it also sounds like you may be saying that the lack of locking in
proc_task_readdir means it could just punt out of its listing loop early at
any time that the task it just looked at is reaped.  Is that right?  That
is OK for userland if any given readdir call returns a short list--but not
if it returns a premature EOF.  It looks to me like that's possible too.

If so, that is startling off hand, and breaks the userland expectation by
the "least astonishment" principle.  (That is, you can sometimes get a
short listing showing a subset of threads that does not include some
threads you previously saw as alive and are still alive.)  It can also
actually break the procedure I described above if one false EOF causes the
reader to miss a new thread it hasn't seen before, so it thinks it has
already stopped all the threads that are alive.

I don't know of anything in userland using that procedure.  But it's
what I would have recommended if asked, before you brought this issue
up.  (strace -p does a single pass and is only intending to offer any
guarantee if you've already finished stopping the thing with SIGSTOP
first.  gdb uses other means that amount to setting a breakpoint inside
pthread_create before reading libpthread's data structures from user
memory for the userland thread list without regard to the actual kernel
thread situation.)  

I suppose we can just say that proc_task_readdir is entirely unreliable
unless you're sure otherwise that threads are not being reaped while you
read it, since that seems to be the truth of it.  I would sure be
happier as a userland programmer if the kernel gave something that I
could rely on by some feasible race-noticing procedure akin to that
above, but it's not the end of the world.


Thanks,
Roland
