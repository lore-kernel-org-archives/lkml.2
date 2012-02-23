Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab2BWVly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:41:54 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28435 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755571Ab2BWVlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:41:53 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g.uQ4M4VM1ktrUeceqHjAmn35GrHa1pZ4GBniJ8cdqfmuiK
 zO5wZgqhq4W9k03twB8HqypktyC7aWvwa_rHUKAfabRP7jCzHnfEo72hUR4w
 l0OEotxYlMCwScx8CjqVVvhFzN3RpYfa505dmtd38549LU7zL3BJhHdG9oCJ
 ZvQt0Ba5IrZXBq00u62DjPyYAgtGd0wEhfs0SOGa.eaeI5agHIqgkbVks29L
 lPbFjvGd2MFTQT1z4ynPvHAn1sHutOPilpUuuVJ2zz3wFDg3mayCScMrTKvK
 XRSqAXIO5ygw1GGbGkl5zhABB.TRic7MBsysi6lGe1Df5hDExkbwq_ODjfH2
 uP5sjgC2PvQl0019Xii7S_wCAbs2HWSDLsfXksvO.1.jeI3nneVr_iWxgoyH
 o
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 23 Feb 2012 15:41:50 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <4F469BC7.50705@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1202231536240.13554@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012, Dave Hansen wrote:

> > We may at this point be getting a reference to a task struct from another
> > process not only from the current process (where the above procedure is
> > valid). You rightly pointed out that the slab rcu free mechanism allows a
> > free and a reallocation within the RCU period.
>
> I didn't _mean_ to point that out, but I think I realize what you're
> talking about.  What we have before this patch is this:
>
>         rcu_read_lock();
>         task = pid ? find_task_by_vpid(pid) : current;

We take a refcount here on the mm ... See the code. We could simply take a
refcount on the task as well if this is considered safe enough. If we have
a refcount on the task then we do not need the refcount on the mm. Thats
was your approach...

>         rcu_read_unlock();

> > Is that a real difference or are you just playing with words?
>
> I think we're talking about two different things:
> 1. does RCU protect the pid->task lookup sufficiently?

I dont know

> 2. Can the task simply go away in the move/migrate_pages() calls?

The task may go away but we need the mm to stay for migration.
That is why a refcount is taken on the mm.

The bug in migrate_pages() is that we do a rcu_unlock and a rcu_lock. If
we drop those then we should be safe if the use of a task pointer within a
rcu section is safe without taking a refcount.

