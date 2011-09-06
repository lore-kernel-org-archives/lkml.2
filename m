Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1IFNgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:36:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1IFNgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:36:49 -0400
Date: Tue, 6 Sep 2011 09:36:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davidel@xmailserver.org, nelhage@ksplice.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] epoll: limit paths
Message-ID: <20110906133640.GA6163@redhat.com>
References: <20110902185922.GA8770@redhat.com>
 <20110902144926.69a00396.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902144926.69a00396.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your review!

On Fri, Sep 02, 2011 at 02:49:26PM -0700, Andrew Morton wrote:
> On Fri, 2 Sep 2011 14:59:23 -0400
> Jason Baron <jbaron@redhat.com> wrote:
> 
> > The current epoll code can be tickled to run basically indefinitely in both
> > loop detection path check (on ep_insert()), and in the wakeup paths. The
> > programs that tickle this behavior set up deeply linked networks of epoll
> > file descriptors that cause the epoll algorithms to traverse them indefinitely.
> > A couple of these sample programs have been previously posted in this thread:
> > https://lkml.org/lkml/2011/2/25/297.
> > 
> > To fix the loop detection path check algorithms, I simply keep track of the
> > epoll nodes that have been already visited. Thus, the loop detection
> > becomes proportional to the number of epoll file descriptor and links. This
> > dramatically decreases the run-time of the loop check algorithm. In one
> > diabolical case I tried it reduced the run-time from 15 mintues
> > (all in kernel time) to .3 seconds.
> > 
> > Fixing the wakeup paths could be done at wakeup time in a similar manner by
> > keeping track of nodes that have already been visited, but the complexity is
> > harder, since there can be multiple wakeups on different cpus...Thus, I've
> > opted to limit the number of possible wakeup paths when the paths are created.
> > 
> > This is accomplished, by noting that the end file descriptor points that are
> > found during the loop detection pass (from the newly added link), are actually
> > the sources for wakeup events. I keep a list of these file descriptors and
> > limit the number and length of these paths that emanate from these 'source file
> > descriptors'. In the current implemetation I allow 1000 paths of length 1,
> > 500 of length 2, 100 of length 3, 50 of length 4 and 10 of length 5. Note that
> > it is sufficient to check the 'source file descriptors' reachable from the newly
> > added link, since no other 'source file descriptors' will have newly added
> > links. This allows us to check only the wakeup paths that may have gotten too
> > long, and not re-check all possible wakeup paths on the system.
> > 
> > In terms of the path limit selection, I think its first worth noting that the
> > most common case for epoll, is probably the model where you have 1 epoll file
> > descriptor that is monitoring n number of 'source file descriptors'. In this
> > case, each 'source file descriptor' has a 1 path of length 1. Thus, I believe
> > that the limits I'm proposing are quite reasonable and in fact may be too
> > generous. Thus, I'm hoping that the proposed limits will not prevent any
> > workloads that currently work to fail.
> > 
> > In terms of locking, I have extended the use of the 'epmutex' to all epoll_ctl
> > add and remove operations. Currently its only used in a subset of the add paths.
> > I need to hold the epmutex, so that we can correctly traverse a coherent graph,
> > to check the number of paths. I believe that this additional locking is
> > probably ok, since its in the setup/teardown paths, and doesn't affect the
> > running paths, but it certainly is going to add some extra overhead. Also,
> > worth noting is that the epmuex was recently added to the ep_ctl add operations
> > in the initial path loop detection code using the argument that it was
> > not on a critical path.
> > 
> > Another thing to note here, is the length of epoll chains that is allowed.
> > Currently, eventpoll.c defines:
> > 
> > /* Maximum number of nesting allowed inside epoll sets */
> > #define EP_MAX_NESTS 4
> > 
> > This basically means that I am limited to a graph depth of 5 (EP_MAX_NESTS + 1).
> > However, this limit is currently only enforced during the loop check detection
> > code, and only when the epoll file descriptors are added in a certain order.
> > Thus, this limit is currently easily bypassed. The newly added check for wakeup
> > paths, stricly limits the wakeup paths to a length of 5, regardless of the order
> > in which ep's are linked together. Thus, a side-effect of the new code is a more
> > consistent enforcement of the graph depth.
> > 
> > Thus far, I've tested this, using the sample programs previously mentioned,
> > which now either return quickly or return -EINVAL. I've also testing using
> > the piptest.c epoll tester, which showed no difference in performance. I've
> > also created a number of different epoll networks and tested that they behave
> > as expectdd.
> > 
> > I believe this solves the original diabolical test cases, while still preserving
> > the sane epoll nesting.
> > 
> 
> Cool, thanks for working on this - it is rather a stinker.
> 
> I don't think we have any maintained public test code for epoll?  And I
> trust you have some?  It would be good if you could merge whatever you
> have into the main kernel.  Then each time we fix bugs or add features,
> I can harrass people to update the test harness to track the changes.
> 

ok. The tests I've used to test this were:

-pipetest.c: http://www.gelato.unsw.edu.au/archives/linux-ia64/0405/9684.html
-test I posted in https://lkml.org/lkml/2011/2/25/297
-test Nelson posted in https://lkml.org/lkml/2011/2/25/297
-some variations on the above tests

I can clean these up, and try and propose them for merge...also where would
they live?

> A number of minor things:
> 
> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> > @@ -188,6 +188,12 @@ struct eventpoll {
> >  
> >  	/* The user that created the eventpoll descriptor */
> >  	struct user_struct *user;
> > +
> > +	struct file *file;
> > +
> > +	/* used to optimize loop detection check */
> > +	int visited;
> > +	struct list_head visitedllink;
> 
> Strange name.  Can we improve this?  Something like visited_loop_link?  
> 
> >  };

sure.

> >  
> >  /* Wait structure used by the poll hooks */
> > @@ -246,6 +252,12 @@ static struct kmem_cache *epi_cache __read_mostly;
> >  /* Slab cache used to allocate "struct eppoll_entry" */
> >  static struct kmem_cache *pwq_cache __read_mostly;
> >  
> > +/* Visited nodes during ep_loop_check(), so we can unset them when we finish */
> > +LIST_HEAD(visited_list);
> 
> static
> 
> > +/* Files with newly added links, which need a limit on emanating paths */
> > +LIST_HEAD(tfile_check_list);
> 
> static
> 
> Add a comment describing the locking for this.
> 
> That locking will need to be kernel-wide, which might have scalability
> issues?
> 

The 'tfile_check_list' is created and checked only during an
epoll_ctl(..., EPOLL_CTL_ADD, ...) operation. After the add finishes, the list
is cleared. I am using the 'epmutex' to protect the list. The possible
contention is:

1) another epoll add
2) another epoll remove
3) if any of the files in the list are closed with no more references - unlink.

Case #1 was already taking the epmutex in some case, I've extened it to
        all case.

case #2 was not using the epmutex, I've added it.

case #3 was already using the epmutex. no changes with this path.
        see: eventpoll_release().

So, I believe any scalability issues, would be within epoll itself. 
That said, it is limited to teardown and setup, which in theory are not
the hot-paths. I would think that the wakeups and polling paths are the
more critical paths, which aren't affected by this path. But certainly we need
to test this more...

> >
> > ...
> >
> > @@ -915,6 +927,96 @@ static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
> >  	rb_insert_color(&epi->rbn, &ep->rbr);
> >  }
> >  
> > +
> > +
> > +#define PATH_ARR_SIZE 5
> > +/* These are the number paths of length 1 to 5, that we are allowing to emanate
> 
> The conventional comment layout is
> 
> /*
>  * These are the number paths of length 1 to 5, that we are allowing to emanate
> 
> > + * from a single file of interest. For example, we allow 1000 paths of length
> > + * 1, to emanate from each file of interest. This essentially represents the
> > + * potential wakeup paths, which need to be limited in order to avoid massive
> > + * uncontrolled wakeup storms. The common use case should be a single ep which
> > + * is connected to n file sources. In this case each file source has 1 path
> > + * of length 1. Thus, the numbers below should be more than sufficient.
> > + */
> > +int path_limits[PATH_ARR_SIZE] = { 1000, 500, 100, 50, 10 };
> 
> static const
> 
> > +int path_count[PATH_ARR_SIZE];
> 
> static
> 
> Add a comment describing the locking which protects this.
> 
> That lock will necessarily be kernel-wide.  Seems nasty.  What are the
> implications of this?
> 

see previous comments.

> >
> > ...
> >
> > @@ -1264,18 +1379,35 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
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
> > +		} else {
> > +			/* if we've reached a file that is not associated with
> 
> /*
>  * If
> 
> > +			 * an ep, then then we need to check if the newly added
> 
> s/then //
> 
> > +			 * links are going to add too many wakeup paths. We do
> > +			 * this by adding it to the tfile_check_list, if it's
> > +			 * not already there, and calling reverse_path_check()
> > +			 * during ep_insert()
> > +			 */
> > +			if (list_empty(&epi->ffd.file->f_tfile_llink))
> > +				list_add(&epi->ffd.file->f_tfile_llink,
> > +					 &tfile_check_list);
> 
> I guess that tfile_check_list is protected by the big epmutex lock.
> 

yes.

> I assume you've verified that all paths that lead to manipulation of
> all these new globals reliably take that lock.
> 

right, as mentioned the tfile_check_list is only manipulated directly on an
epoll add path.

> >  		}
> >  	}
> >  	mutex_unlock(&ep->mtx);
> >
> > ...
> >
> 

I'll probably look to re-spin this next week with your comments, since
I'll be at plumbers the rest of the week...

Thanks,

-Jason
