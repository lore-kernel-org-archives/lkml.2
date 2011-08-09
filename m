Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1HISeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:34:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62038 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1HISeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:34:10 -0400
Date: Tue, 9 Aug 2011 20:34:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110809183402.GD31645@somewhere.redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
 <20110809151155.GA15311@redhat.com>
 <20110809172746.GA31645@somewhere.redhat.com>
 <20110809175708.GA27866@redhat.com>
 <20110809180942.GC31645@somewhere.redhat.com>
 <20110809181947.GB28442@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809181947.GB28442@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:19:47PM +0200, Oleg Nesterov wrote:
> On 08/09, Frederic Weisbecker wrote:
> >
> > On Tue, Aug 09, 2011 at 07:57:08PM +0200, Oleg Nesterov wrote:
> > > > > cgroup_attach_proc() is different, it calls cgroup_task_migrate()
> > > > > after ->attach_task(). Cough.
> > > >
> > > > That's bad. I need to fix that.
> > > >
> > > > So if it returns -ESRCH, I shall not call attach_task() on it
> > > > but cancel_attach_task().
> > >
> > > Afaics this can't help, or I misunderstood. probably attach_task()
> > > can check PF_EXITING...
> >
> > But cgroup_task_migrate() checks that already before migrating
> > cgroups (checks PF_EXITING under task_lock() so that it's
> > synchronized against cgroup_exit())
> 
> Yes, but how this can help?
> 
> ->attach_task() is called before cgroup_task_migrate(). Suppose
> that it exits before ->attach_task(). In this case we shouldn't
> uncharge the old cgroup, it was already uncharged by cgroup_exit.

Yeah that's why in cgroup_attach_proc() we need to call cgroup_task_migrate()
before ->attach_task(), as it's done in cgroup_attach_task(). And also call
cancel_attach_task() if it fails there with -ESRCH without cancelling
the whole group attachment.
