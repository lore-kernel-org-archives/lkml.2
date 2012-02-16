Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2BPPNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:13:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41655 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2BPPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:13:45 -0500
Date: Thu, 16 Feb 2012 19:13:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120216151340.GI1905@moon>
References: <20120215162222.GA18266@redhat.com>
 <20120215175319.GG4533@moon>
 <20120215184336.GA24182@redhat.com>
 <20120215195610.GJ4533@moon>
 <20120215195733.GA8021@albatros>
 <20120215200533.GQ1894@moon>
 <20120215202538.GK4533@moon>
 <20120215210934.GL4533@moon>
 <20120215215807.GM4533@moon>
 <20120216144954.GA11953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216144954.GA11953@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 03:49:54PM +0100, Oleg Nesterov wrote:
> On 02/16, Cyrill Gorcunov wrote:
> >
> > +static int access_trylock(struct task_struct *task)
> > +{
> > +	if (!mutex_trylock(&task->signal->cred_guard_mutex))
> > +		return -EBUSY;
> > +
> > +	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
> > +		mutex_unlock(&task->signal->cred_guard_mutex);
> > +		return -EPERM;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> OK, this looks correct, but I don't really understand _trylock.
> This means the caller should always retry if -EBUSY, and
> kcmp(pid, pid) can never succeed. Sure, kcmp() doesn't make
> a lot of sense if pid1 == pid2, but this looks a bit strange.
> 

Hi Oleg, sure I can make it this way, also I think if pid1 == pid2
and idx1 == idx2 I can return 0 immediately.

> You could simply do
> 	int mutex_double_lock_killable(struct mutex *m1, struct mutex *m2)
> 	{
> 		int err;
> 
> 		if (m2 > m1)
> 			swap(m1, m2);
> 
> 		err = mutex_lock_killable(m1);
> 
> 		if (!err && likely(m1 != m2)) {
> 			err = mutex_lock_killable_nested(m2);
> 			if (err)
> 				mutex_unlock(m1);
> 		}
> 
> 		return err;
> 	}
> 
> but I won't insist.

Initially I wanted kcmp would be brining minimum impact
and if mutex is already taken by someone, we would not sleep
but return immediately with -EBUSY and it would be up to caller
to deside if to try again or make some delay first. I simply
not sure what is better here.

	Cyrill
