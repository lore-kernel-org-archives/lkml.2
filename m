Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2APQUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:20:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58394 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2APQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:20:26 -0500
Date: Mon, 16 Jan 2012 20:20:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v6
Message-ID: <20120116162021.GH2998@moon>
References: <20120116153231.GF2998@moon>
 <20120116161114.GA17727@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116161114.GA17727@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 05:11:14PM +0100, Oleg Nesterov wrote:
> On 01/16, Cyrill Gorcunov wrote:
> >
> > +get_children_pid(struct proc_pid_children_iter *iter, struct pid *pid_prev, loff_t pos)
> > +{
> > +	struct task_struct *start, *task;
> > +	struct pid *pid = NULL;
> > +
> > +	read_lock(&tasklist_lock);
> > +
> > +	start = pid_task(iter->pid_start, PIDTYPE_PID);
> > +	if (!start)
> > +		goto out;
> > +
> > +	/*
> > +	 * Lets try to continue searching first, this gives
> > +	 * us significant speedup on children-rich processes.
> > +	 */
> > +	if (pid_prev) {
> > +		task = pid_task(pid_prev, PIDTYPE_PID);
> > +		if (task && task->real_parent == start &&
> > +		    !(list_empty(&task->sibling))) {
> 
> Damn. No, this is wrong.
> 
> Damn! Yes, it was we who told you to check list_empty(sibling) ;)
> 
> But this is not enough. exit_ptrace() can do list_move() without
> changing ->real_parent.
> 
> I'll try to think. At first glance we can rely on EXIT_DEAD, but
> I'd like to avoid this, I think EXIT_DEAD should die.
> 

Ouch! Thanks for catching this Oleg. I'll try to come with something
to show as well.

	Cyrill
