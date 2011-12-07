Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1LGUe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:34:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46402 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652Ab1LGUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:34:55 -0500
Date: Thu, 8 Dec 2011 00:34:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111207203450.GS21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
 <20111207190340.GP21678@moon>
 <20111207191916.GR21678@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207191916.GR21678@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 11:19:16PM +0400, Cyrill Gorcunov wrote:
...
> > > 
> > > This looks "obviously wrong".
> > > 
> > > We can not trust ->children->next after rcu_read_unlock(). Another
> > > rcu_read_lock() can't help.
> > > 
> > > Once again, I can be easily wrong, need to read the patch first.
> > > 
> > 
> > Wait, Oleg, I might be wrong as well, but it's now as
> > 
> > children_seq_open
> >  get_proc_task (so ref to task increased)
> > 
> > the children_seq_start/children_seq_stop works
> > in iteration and every new iteration seq_list_next
> > walks over the whole children list from the list
> > head under rcu lock, so even if task is removed
> > or added the link should exsist until rcu is unlocked
> > and sync'ed no?
> > 
> 
> On the other hands some if (task) tests are redundant
> and might be dropped since we have a reference to a
> task until seq-file is not released. I'll update it
> and shrink a patch some more.
> 

So while adding new task to a list is not a problem (the reader
will simply not notice it) removing task from a list is a bit
tricky, but as far as I see switch_task_namespaces (from exit_notify)
uses synchronize_rcu as well as release_task calls for call_rcu
for put_task_struct) so I think we will not get any wrong dereference
in

static int children_seq_show(struct seq_file *seq, void *v)
{
	struct task_struct *task = container_of(v, struct task_struct, sibling);
	return seq_printf(seq, " %lu", (unsigned long)pid_vnr(task_pid(task)));
}

while we're in rcu reader section. I might be wrong of course, so
please verify this claim.

	Cyrill
