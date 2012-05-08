Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2EHExh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:53:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33706 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751826Ab2EHExf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:53:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ZZfBS0KLZxXOCxlrgTuT4bQxUjcJ959D2EbdFoJ
	EaMi6ZE23sfVs+
Message-ID: <1336452807.21924.13.camel@marge.simpson.net>
Subject: Re: [PATCH] vfs: Speed up deactivate_super for non-modular
 filesystems
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: paulmck@linux.vnet.ibm.com, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Date: Tue, 08 May 2012 06:53:27 +0200
In-Reply-To: <87zk9jzdi5.fsf@xmission.com>
References: <m1vckcdoey.fsf@fess.ebiederm.org>
	 <1336142995.25479.49.camel@marge.simpson.net>
	 <m1zk9oc61j.fsf@fess.ebiederm.org>
	 <1336150643.7502.4.camel@marge.simpson.net>
	 <m1fwbfd71h.fsf@fess.ebiederm.org>
	 <1336197362.7346.9.camel@marge.simpson.net>
	 <1336198093.7346.11.camel@marge.simpson.net>
	 <1336201977.7346.22.camel@marge.simpson.net>
	 <87r4uv64oj.fsf_-_@xmission.com>
	 <20120507221706.GI22082@ZenIV.linux.org.uk>
	 <20120507235647.GH21152@linux.vnet.ibm.com> <87zk9jzdi5.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 18:07 -0700, Eric W. Biederman wrote: 
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> What I see as the real need is the filesystem modules need to do:
> 	rcu_barrier()
> 	kmem_cache_destroy(cache);
> 
> Perhaps we can add some helpers to make it easy.  But I think
> I would be happy today with simply moving the rcu_barrier into
> every filesystems module exit path, just before the file system
> module destoryed it's inode cache.

One liner kills the reap bottleneck and 99.999% of cache bloat.  1000
backgrounded vfstpd testcases finished ~instantly and left one
persistent pid namespace vs taking ages and bloating very badly.

Hacked up hackbench still hurts with all (except user) namespaces, but
that's a different problem (modulo hackbench wonderfulness).

Previous numbers:

default flags = SIGCHLD

-namespace:  flag |= CLONE_NEWPID 
-all:  flags |= CLONE_NEWIPC | CLONE_NEWNET | CLONE_NEWUSER

marge:/usr/local/tmp/starvation # ./hackbench
Running with 10*40 (== 400) tasks.
Time: 2.636
marge:/usr/local/tmp/starvation # ./hackbench -namespace
Running with 10*40 (== 400) tasks.
Time: 11.624
marge:/usr/local/tmp/starvation # ./hackbench -namespace -all
Running with 10*40 (== 400) tasks.
Time: 51.474


New numbers: 
marge:/usr/local/tmp/starvation # time ./hackbench
Running with 10*40 (== 400) tasks.
Time: 2.718

real    0m2.877s
user    0m0.060s
sys     0m10.057s
marge:/usr/local/tmp/starvation # time ./hackbench -namespace
Running with 10*40 (== 400) tasks.
Time: 2.689

real    0m2.878s
user    0m0.060s
sys     0m9.945s
marge:/usr/local/tmp/starvation # time ./hackbench -namespace -all
Running with 10*40 (== 400) tasks.                                                                                                                                                                                                          
Time: 2.521
                                                                                                                                                                                                                                            
real    0m27.774s
user    0m0.048s                                                                                                                                                                                                                            
sys     0m21.681s
marge:/usr/local/tmp/starvation #  

