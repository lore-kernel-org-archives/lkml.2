Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab0FBOcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:32:11 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:54597 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0FBOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JYkj/3Q6qZjZxjNGAWBVOTTK9k9heWVcoJN3ZgU4HyMqTiAOlVDwgSGkPek5J+rcQ5
         uoIYkE7UDdoaaHRksQACJvOfAhoz3jyoEnctDHQ1huFnTfejCEGE2RsC+vWRqbK0j4yF
         k/nJ0Xa/Boo39EL+IoabCv94CiyJEWgxe1iZk=
Date: Wed, 2 Jun 2010 11:20:18 -0300
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, balbir@linux.vnet.ibm.com,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-ID: <20100602142018.GH17404@uudg.org>
References: <20100601173535.GD23428@uudg.org>
 <alpine.DEB.2.00.1006011347060.13136@chino.kir.corp.google.com>
 <20100602220429.F51E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602220429.F51E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 10:54:01PM +0900, KOSAKI Motohiro wrote:
| > > @@ -291,9 +309,10 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
| > >  		 * Otherwise we could get an easy OOM deadlock.
| > >  		 */
| > >  		if (p->flags & PF_EXITING) {
| > > -			if (p != current)
| > > +			if (p != current) {
| > > +				boost_dying_task_prio(p, mem);
| > >  				return ERR_PTR(-1UL);
| > > -
| > > +			}
| > >  			chosen = p;
| > >  			*ppoints = ULONG_MAX;
| > >  		}
| > 
| > This has the potential to actually make it harder to free memory if p is 
| > waiting to acquire a writelock on mm->mmap_sem in the exit path while the 
| > thread holding mm->mmap_sem is trying to run.
| 
| if p is waiting, changing prio have no effect. It continue tol wait to release mmap_sem.

Ok, that was not a good idea after all :)

But I understand the !rt_task(p) test is necessary to avoid decrementing
the priority of an eventual RT task selected to die. Though it may also be
a corner case in badness().

Luis
-- 
[ Luis Claudio R. Goncalves                    Bass - Gospel - RT ]
[ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]

