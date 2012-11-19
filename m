Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2KSXF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:05:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2KSXFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:05:54 -0500
Date: Mon, 19 Nov 2012 15:05:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] percpu_rw_semaphore: add the lockdep annotations
Message-Id: <20121119150553.8c890970.akpm@linux-foundation.org>
In-Reply-To: <20121118190321.GA9684@redhat.com>
References: <20121118190257.GA9660@redhat.com>
	<20121118190321.GA9684@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2012 20:03:21 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> Add the lockdep annotations. Not only this can help to find the
> potential problems, we do not want the false warnings if, say,
> the task takes two different percpu_rw_semaphore's for reading.
> IOW, at least ->rw_sem should not use a single class.
> 
> This patch exposes this internal lock to lockdep so that it
> represents the whole percpu_rw_semaphore. This way we do not
> need to add another "fake" ->lockdep_map and lock_class_key.
> More importantly, this also makes the output from lockdep much
> more understandable if it finds the problem.
> 
> In short, with this patch from lockdep pov percpu_down_read()
> and percpu_up_read() acquire/release ->rw_sem for reading, this
> matches the actual semantics. This abuses __up_read() but I hope
> this is fine and in fact I'd like to have down_read_no_lockdep()
> as well, percpu_down_read_recursive_readers() will need it.
> 
> ...
>
> -extern int percpu_init_rwsem(struct percpu_rw_semaphore *);
> +extern int __percpu_init_rwsem(struct percpu_rw_semaphore *,
> +				const char *, struct lock_class_key *);
>  extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
>  
> +#define percpu_init_rwsem(brw)	\

Should have been called percpu_rwsem_init().  The naming in this code does
seem to be rather inconsistent.  s/percpu_rw_semaphore/percpu_rwsem/g
would be a good start, then consistently use percpu_rwsem_foo where
practical.  But percpu_rwsem_down_read() doesn't sound practical :(


Is there much point in doing all these changes as five separate patches
(so far)?  Perhaps it should all blobbed into as little as one patch(es)?


You sent your uprobes changes to Ingo as a git pull, but I doubt if
Ingo's trees contain the percpu_rwsem_rw_semaphore changes.  What's
happening here?

