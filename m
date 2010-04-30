Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab0D3SuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:50:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46457 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab0D3Sti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ByGsjyZPx0cKwP/jUN4N+HX0LyImdIpxVmZesHqRaTVqZ9WblBqz7mZ4fjtkKnJynI
         aGPd4LNTXBkyYw3kOQW6Apei3YZx8ToF2YgbCyUTCKZtmGKbfRhtP193YJ1Rbld7sOWC
         /ra6DsGWQRFHY0S31ykknon8kY9LgpX37Xr+o=
Date: Fri, 30 Apr 2010 20:49:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH v2] perf lock: add "info" subcommand for dumping misc
	information
Message-ID: <20100430184937.GB5357@nowhere>
References: <1272074742-3654-2-git-send-regression-fweisbec@gmail.com> <1272106001-10519-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272106001-10519-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 07:46:41PM +0900, Hitoshi Mitake wrote:
> Hi Frederic,
> 
> I added "info" subcommand to perf lock,
> this can be used as dumping metadata like thread or address of lock instances.
> "map" was removed because info should do the work of it.
> 
> This will be useful not only for debugging but also for ordinary analyzing.
> 
> I made this patch on perf/core of your tree, could you queue this?
> 
> v2: adding example of usage
> % sudo ./perf lock info -t
>  | Thread ID: comm
>  | 	 0: swapper
>  |         1: init
>  |        18: migration/5
>  |        29: events/2
>  |        32: events/5
>  |        33: events/6
> ...
> 
> % sudo ./perf lock info -m
> | Address of instance: name of class
> |  0xffff8800b95adae0: &(&sighand->siglock)->rlock
> |  0xffff8800bbb41ae0: &(&sighand->siglock)->rlock
> |  0xffff8800bf165ae0: &(&sighand->siglock)->rlock
> |  0xffff8800b9576a98: &p->cred_guard_mutex
> |  0xffff8800bb890a08: &(&p->alloc_lock)->rlock
> |  0xffff8800b9522a08: &(&p->alloc_lock)->rlock
> |  0xffff8800bb8aaa08: &(&p->alloc_lock)->rlock
> |  0xffff8800bba72a08: &(&p->alloc_lock)->rlock
> |  0xffff8800bf18ea08: &(&p->alloc_lock)->rlock
> |  0xffff8800b8a0d8a0: &(&ip->i_lock)->mr_lock
> |  0xffff88009bf818a0: &(&ip->i_lock)->mr_lock
> |  0xffff88004c66b8a0: &(&ip->i_lock)->mr_lock
> |  0xffff8800bb6478a0: &(shost->host_lock)->rlock
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>


I've eventually not queued it because of some various
problems, see below:



> ---
>  tools/perf/builtin-lock.c |   68 +++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 65 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index ce27675..c54211e 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -778,18 +778,61 @@ static void print_result(void)
>  	}
>  }
>  
> +static int			info_threads;
> +static int			info_map;
> +
> +static void rec_dump_threads(struct rb_node *node)
> +{
> +	struct thread_stat *st;
> +	struct thread *t;
> +
> +	if (!node)
> +		return;
> +
> +	if (node->rb_left)
> +		rec_dump_threads(node->rb_left);


That only walks the left nodes of the rbtree, imagine the following
rbtree, W are visited nodes, U are the unvisited:

                   Root
                 /      \
                W        U
              /  \      / \
             W    U    U   U


Better iterate using rb_first() then rb_next() until it is NULL.



> +
> +	st = container_of(node, struct thread_stat, rb);
> +	BUG_ON(!st);


You won't ever have !st because container_of computes an address
based on a struct type and a contained address inside this struct.

struct thread_stat {
	struct list_head	hash_entry;
	struct rb_node		rb;
	[...]
} ts;

If ts->rb == 1000, ts == 1000 - 16 or something like this.

What matters is the "if (!node)" check you did before.



> +	t = perf_session__findnew(session, st->tid);
> +	BUG_ON(!t);
> +
> +	printf("%10d: %s\n", st->tid, t->comm);



Please don't use printf anymore (I did the same mistakes lately),
now that are using a TUI and we might use a GUI one day, we
can't assume anymore we are dealing with a normal stdout.

So better use pr_debug, pr_err, pr_warning, etc...



> +
> +	if (node->rb_right)
> +		rec_dump_threads(node->rb_right);
> +}
> +
> +static void dump_threads(void)
> +{
> +	printf("%10s: comm\n", "Thread ID");



Same here and below.



> +	rec_dump_threads(thread_stats.rb_node);
> +}
> +
>  static void dump_map(void)
>  {
>  	unsigned int i;
>  	struct lock_stat *st;
>  
> +	printf("Address of instance: name of class\n");
>  	for (i = 0; i < LOCKHASH_SIZE; i++) {
>  		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
> -			printf("%p: %s\n", st->addr, st->name);
> +			printf(" %p: %s\n", st->addr, st->name);
>  		}
>  	}
>  }
>  
> +static void dump_info(void)
> +{
> +	/* ugly... */
> +	if (info_threads)
> +		dump_threads();


No it's not ugly, it's ok, we do this everywhere in perf tools :)

Thanks.

