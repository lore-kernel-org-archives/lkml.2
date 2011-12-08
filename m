Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1LHQlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:41:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab1LHQlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:41:08 -0500
Date: Thu, 8 Dec 2011 17:35:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111208163535.GA25023@redhat.com>
References: <20111206181026.GO29781@moon> <20111207185343.GA3209@redhat.com> <20111207190340.GP21678@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207190340.GP21678@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Cyrill Gorcunov wrote:
>
> On Wed, Dec 07, 2011 at 07:53:43PM +0100, Oleg Nesterov wrote:
> > Hi Cyrill,
> >
> > Sorry, I didn't read this patch yet, but
> >
> > On 12/06, Cyrill Gorcunov wrote:
> > >
> > > +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> > > +{
> > > +	struct task_struct *task;
> > > +
> > > +	rcu_read_lock();
> > > +	task = seq->private;
> > > +	if (task)
> > > +		return seq_list_start(&task->children, *pos);
> >
> > This looks "obviously wrong".
> >
> > We can not trust ->children->next after rcu_read_unlock(). Another
> > rcu_read_lock() can't help.
> >
> > Once again, I can be easily wrong, need to read the patch first.
> >
>
> Wait, Oleg, I might be wrong as well, but it's now a
>
> children_seq_open
>  get_proc_task (so ref to task increased)

Yes. task_struct itself can't go away.

> the children_seq_start/children_seq_stop work
> in iteration and every new iteration seq_list_next
> walks over the whole children list from the list
> head under rcu lock,

Yep, I misread this code, I though it does _next.

However, ->children list is not rcu-safe, this means that even
list_for_each() itself is not safe. Either you need tasklist or
we can probably make it rcu-safe...

As for /proc/pid/children, personally I think it is very useful.
But note that it obviously reports the children per-thread, while
in general this is the per-process thing. Not sure this really
makes sense, but perhaps /proc/pid/children and
/proc/pid/task/tid/children should act differently. Like, say,
proc_tid_stat/proc_tgid_stat. I won't insist.

Oleg.

