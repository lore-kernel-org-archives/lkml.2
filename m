Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab0KYImL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:42:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:33779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0KYImJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:42:09 -0500
Subject: Re: rcu_read_lock/unlock protect find_task_by_vpid call in
 migrate_pages
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        tglx <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101125095012.F446.A69D9226@jp.fujitsu.com>
References: <20101125003339.GB31301@redhat.com>
	 <20101125095012.F446.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 09:42:21 +0100
Message-ID: <1290674541.2072.564.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 09:50 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > Signed-off-by: Dave Jones <davej@redhat.com>
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 4a57f13..2f0f55b 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1308,6 +1308,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
> >  
> >  	/* Find the mm_struct */
> >  	read_lock(&tasklist_lock);
> > +	rcu_read_lock();
> >  	task = pid ? find_task_by_vpid(pid) : current;
> >  	if (!task) {
> >  		read_unlock(&tasklist_lock);
> > @@ -1315,6 +1316,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
> >  		goto out;
> >  	}
> >  	mm = get_task_mm(task);
> > +	rcu_read_unlock();
> >  	read_unlock(&tasklist_lock);
> >  
> >  	err = -EINVAL;
> 
> Thanks reporting. but mmotm seems already has the same patch.

Another one,... again:


Do we still need the tasklist_lock in this case?

Also, why is that think complaining, surely the tasklist_lock pins any
and all PID objects?
