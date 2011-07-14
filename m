Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab1GNXzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:55:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42479 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1GNXzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:55:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 15 Jul 2011 08:47:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: make oom_lock 0 and 1 based rather than
 coutner
Message-Id: <20110715084755.1e0a4c14.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110714125555.GA27954@tiehlicka.suse.cz>
References: <50d526ee242916bbfb44b9df4474df728c4892c6.1310561078.git.mhocko@suse.cz>
	<20110714100259.cedbf6af.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714115913.cf8d1b9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714090017.GD19408@tiehlicka.suse.cz>
	<20110714183014.8b15e9b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714095152.GG19408@tiehlicka.suse.cz>
	<20110714191728.058859cd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714110935.GK19408@tiehlicka.suse.cz>
	<20110714113009.GL19408@tiehlicka.suse.cz>
	<20110714205012.8b78691e.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714125555.GA27954@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 14:55:55 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 14-07-11 20:50:12, KAMEZAWA Hiroyuki wrote:
> > On Thu, 14 Jul 2011 13:30:09 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > >  static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
> > >  {
> > > -	int x, lock_count = 0;
> > > -	struct mem_cgroup *iter;
> > > +	int x, lock_count = -1;
> > > +	struct mem_cgroup *iter, *failed = NULL;
> > > +	bool cond = true;
> > >  
> > > -	for_each_mem_cgroup_tree(iter, mem) {
> > > -		x = atomic_inc_return(&iter->oom_lock);
> > > -		lock_count = max(x, lock_count);
> > > +	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
> > > +		x = !!atomic_add_unless(&iter->oom_lock, 1, 1);
> > > +		if (lock_count == -1)
> > > +			lock_count = x;
> > > +		else if (lock_count != x) {
> > > +			/*
> > > +			 * this subtree of our hierarchy is already locked
> > > +			 * so we cannot give a lock.
> > > +			 */
> > > +			lock_count = 0;
> > > +			failed = iter;
> > > +			cond = false;
> > > +		}
> > >  	}
> > 
> > Hm ? assuming B-C-D is locked and a new thread tries a lock on A-B-C-D-E.
> > And for_each_mem_cgroup_tree will find groups in order of A->B->C->D->E.
> > Before lock
> >   A  0
> >   B  1
> >   C  1
> >   D  1
> >   E  0
> > 
> > After lock
> >   A  1
> >   B  1
> >   C  1
> >   D  1
> >   E  0
> > 
> > here, failed = B, cond = false. Undo routine will unlock A.
> > Hmm, seems to work in this case.
> > 
> > But....A's oom_lock==0 and memcg_oom_wakeup() at el will not able to
> > know "A" is in OOM. wakeup processes in A which is waiting for oom recover..
> 
> Hohm, we need to have 2 different states. lock and mark_oom.
> oom_recovert would check only the under_oom.
> 

yes. I think so, too.

> > 
> > Will this work ?
> 
> No it won't because the rest of the world has no idea that A is
> under_oom as well.
> 
> > ==
> >  # cgcreate -g memory:A
> >  # cgset -r memory.use_hierarchy=1 A
> >  # cgset -r memory.oom_control=1   A
> >  # cgset -r memory.limit_in_bytes= 100M
> >  # cgset -r memory.memsw.limit_in_bytes= 100M
> >  # cgcreate -g memory:A/B
> >  # cgset -r memory.oom_control=1 A/B
> >  # cgset -r memory.limit_in_bytes=20M
> >  # cgset -r memory.memsw.limit_in_bytes=20M
> > 
> >  Assume malloc XXX is a program allocating XXX Megabytes of memory.
> > 
> >  # cgexec -g memory:A/B malloc 30  &    #->this will be blocked by OOM of group B
> >  # cgexec -g memory:A   malloc 80  &    #->this will be blocked by OOM of group A
> > 
> > 
> > Here, 2 procs are blocked by OOM. Here, relax A's limitation and clear OOM.
> > 
> >  # cgset -r memory.memsw.limit_in_bytes=300M A
> >  # cgset -r memory.limit_in_bytes=300M A
> > 
> >  malloc 80 will end.
> 
> What about yet another approach? Very similar what you proposed, I
> guess. Again not tested and needs some cleanup just to illustrate.
> What do you think?

Hmm, I think this will work. Please go ahead.
Unfortunately, I'll not be able to make a quick response for a week
because of other tasks. I'm sorry.

Anyway,
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> 

BTW, it's better to add "How-to-test" and the result in description.
Some test similar to mine will show the result we want.
==
Make a hierarchy of memcg, which has 300MB memory+swap limit.

 %cgcreate -g memory:A
 %cgset -r memory.limit_in_bytes=300M A
 %cgset -r memory.memsw.limit_in_bytes=300M A

Then, running folloing program under A.
 %cgexec -g memory:A ./fork
==
int main(int argc, char *argv[])
{
        int i;
        int status;

        for (i = 0; i < 5000; i++) {
                if (fork() == 0) {
                        char *c;
                        c = malloc(1024*1024);
                        memset(c, 0, 1024*1024);
                        sleep(20);
                        fprintf(stderr, "[%d]\n", i);
                        exit(0);
                }
                printf("%d\n", i);
                waitpid(-1, &status, WNOHANG);
        }
        while (1) {
                int ret;
                ret = waitpid(-1, &status, WNOHANG);

                if (ret == -1)
                        break;
                if (!ret)
                        sleep(1);
        }
        return 0;
}
==

Thank you for your effort.
-Kame

