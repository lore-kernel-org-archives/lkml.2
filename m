Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1LGTDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:03:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65144 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab1LGTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:03:46 -0500
Date: Wed, 7 Dec 2011 23:03:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111207190340.GP21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207185343.GA3209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 07:53:43PM +0100, Oleg Nesterov wrote:
> Hi Cyrill,
> 
> Sorry, I didn't read this patch yet, but
> 
> On 12/06, Cyrill Gorcunov wrote:
> >
> > +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +	struct task_struct *task;
> > +
> > +	rcu_read_lock();
> > +	task = seq->private;
> > +	if (task)
> > +		return seq_list_start(&task->children, *pos);
> 
> This looks "obviously wrong".
> 
> We can not trust ->children->next after rcu_read_unlock(). Another
> rcu_read_lock() can't help.
> 
> Once again, I can be easily wrong, need to read the patch first.
> 

Wait, Oleg, I might be wrong as well, but it's now as

children_seq_open
 get_proc_task (so ref to task increased)

the children_seq_start/children_seq_stop works
in iteration and every new iteration seq_list_next
walks over the whole children list from the list
head under rcu lock, so even if task is removed
or added the link should exsist until rcu is unlocked
and sync'ed no?

	Cyrill
