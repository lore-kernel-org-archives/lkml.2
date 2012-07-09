Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2GIK0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:26:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48379 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab2GIK0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:26:38 -0400
Date: Mon, 9 Jul 2012 15:55:59 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uprobes: suppress uprobe_munmap() from mmput()
Message-ID: <20120709102559.GA32393@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120708203003.GA18226@redhat.com>
 <1341822602.3462.15.camel@twins>
 <20120709100920.GA21163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120709100920.GA21163@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070910-5112-0000-0000-000009E2BB4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-09 12:09:20]:

> On 07/09, Peter Zijlstra wrote:
> >
> > On Sun, 2012-07-08 at 22:30 +0200, Oleg Nesterov wrote:
> > > uprobe_munmap() does get_user_pages() and it is also called from
> > > the final mmput()->exit_mmap() path. This slows down exit/mmput()
> > > for no reason, and I think  it is simply dangerous/wrong to try to
> > > fault-in a page into the dying mm. If nothing else, this happens
> > > after the last sync_mm_rss(), afaics handle_mm_fault() can change
> > > the task->rss_stat and make the subsequent check_mm() unhappy.
> > >
> > > Change uprobe_munmap() to check mm->mm_users != 0.
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > > ---
> > >  kernel/events/uprobes.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > > index a93b6df..47c4e24 100644
> > > --- a/kernel/events/uprobes.c
> > > +++ b/kernel/events/uprobes.c
> > > @@ -1082,6 +1082,9 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
> > >  	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
> > >  		return;
> > >
> > > +	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput() ? */
> > > +		return;
> > > +
> > >  	if (!atomic_read(&vma->vm_mm->uprobes_state.count))
> > >  		return;
> > >
> >
> > But won't you leak uprobe refcounts like this? Those aren't tied to the
> > task (which is dying) but to the vma's mapping the appropriate hunk of
> > the text. Not doing the munmap will then not put the uprobe->ref..
> 
> No, mmap/munmap do not participate in uprobe refcounting. This code
> does put_uprobe() for each uprobe, yes, but only because the counter
> was incremented in build_probe_list().
> 

Right

-- 
Thanks and Regards
Srikar

