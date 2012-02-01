Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2BAQ3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:29:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65161 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2BAQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:28:59 -0500
Date: Wed, 1 Feb 2012 17:28:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120201162851.GD6731@somewhere.redhat.com>
References: <20111221034334.GD17668@somewhere>
 <20111221130848.GA19679@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221130848.GA19679@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:08:48PM +0100, Oleg Nesterov wrote:
> On 12/21, Frederic Weisbecker wrote:
> > - Is the check for use_task_css_set_links in cgroup_post_fork() safe? given
> > it is checked outside css_set_lock?
> >
> > Imagine this:
> >
> > CPU 0                                                        CPU 1
> > ----                                                         -----
> >
> > cgroup_enable_task_cg() {
> > 	uset_tasks_css_set_links = 1
> > 	for_each_thread() {
> > 		add tasks in the list
> > 	}
> > }
> >                                                            do_fork() {
> >                                                                cgroup_post_fork() {
> >                                                                      use_tasks_css_set_links appears
> >                                                                      to be equal to 0 due to write/read
> >                                                                       not flushed. New task won't
> >                                                                       appear to the list.
> 
> Yes, I was thinking about this too.
> 
> Or (I think) they can race "contrariwise". CPU_1 creates the new child,
> then CPU_0 sets uset_tasks_css_set_links = 1. But afaics there is no any
> guarantee that CPU_0 sees the result of list_add_tail_rcu().

Exactly! In fact even if RCU was safe with while_each_thread() it wouldn't
be enough for us because of that.

I fear we need the read_lock(tasklist_lock) here, with a pair of smp
barriers to ensure use_task_css_set_links update is visible as
expected.

I'll try to cook something.
