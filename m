Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0DFNFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:05:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:15912 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0DFNF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=caTPadXHnETzNYVHtDyodlaklPuYsUnpVMw9DkPWiQr8uB3GPPV68yUud0za44a22m
         v0/AgfB2GN0Z75f0dH3kD9nor0AoKhaa13n0DhHCu+RVRGDFqAeK9cLaePvPnvs1gCns
         BO0Z1kuTHKuZCS/yuwbwxczEozeD7RugTaX0g=
Date: Tue, 6 Apr 2010 21:05:19 +0800
From: anfei <anfei.zhou@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] oom: select_bad_process: PF_EXITING check
 should take ->mm into account
Message-ID: <20100406130518.GB3965@desktop>
References: <20100331175836.GA11635@redhat.com>
 <20100331204718.GD11635@redhat.com>
 <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com>
 <20100401135927.GA12460@redhat.com>
 <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com>
 <20100402111406.GA4432@redhat.com>
 <20100402183057.GA31723@redhat.com>
 <20100402183216.GC31723@redhat.com>
 <20100406114235.GA3965@desktop>
 <20100406121811.GA6802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406121811.GA6802@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 02:18:11PM +0200, Oleg Nesterov wrote:
> On 04/06, anfei wrote:
> >
> > On Fri, Apr 02, 2010 at 08:32:16PM +0200, Oleg Nesterov wrote:
> > > select_bad_process() checks PF_EXITING to detect the task which
> > > is going to release its memory, but the logic is very wrong.
> > >
> > > 	- a single process P with the dead group leader disables
> > > 	  select_bad_process() completely, it will always return
> > > 	  ERR_PTR() while P can live forever
> > >
> > > 	- if the PF_EXITING task has already released its ->mm
> > > 	  it doesn't make sense to expect it is goiing to free
> > > 	  more memory (except task_struct/etc)
> > >
> > > Change the code to ignore the PF_EXITING tasks without ->mm.
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > > ---
> > >
> > >  mm/oom_kill.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > --- MM/mm/oom_kill.c~2_FIX_PF_EXITING	2010-04-02 18:51:05.000000000 +0200
> > > +++ MM/mm/oom_kill.c	2010-04-02 18:58:37.000000000 +0200
> > > @@ -322,7 +322,7 @@ static struct task_struct *select_bad_pr
> > >  		 * the process of exiting and releasing its resources.
> > >  		 * Otherwise we could get an easy OOM deadlock.
> > >  		 */
> > > -		if (p->flags & PF_EXITING) {
> > > +		if ((p->flags & PF_EXITING) && p->mm) {
> >
> > Even this check is satisfied, it still can't say p is a good victim or
> > it will release memory automatically if multi threaded, as the exiting
> > of p doesn't mean the other threads are going to exit, so the ->mm won't
> > be released.
> 
> Yes, completely agreed.
> 
> Unfortunately I forgot to copy this into the changelog, but when I
> discussed this change I mentioned "still not perfect, but much better".
> 
> I do not really know what is the "right" solution. Even if we fix this
> check for mt case, we also have CLONE_VM tasks.
> 
What about checking mm->mm_users too? If there are any other users,
just let badness judge.  CLONE_VM tasks but not mt seem rare, and
badness doesn't consider it too.

> So, this patch just tries to improve things, to avoid the easy-to-trigger
> false positives.
> 
Agreed.

Thanks,
Anfei.

> Oleg.
> 
