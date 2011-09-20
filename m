Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1ITPtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:49:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34569 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1ITPtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:49:01 -0400
Date: Tue, 20 Sep 2011 08:48:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] creds: kill __task_cred()->task_is_dead() check
Message-ID: <20110920154857.GE2380@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
 <20110920124419.GA10759@hallyn.com>
 <20110920134108.GA30749@redhat.com>
 <20110920143920.GA15859@redhat.com>
 <20110920143942.GB15859@redhat.com>
 <20110920152816.GD2380@linux.vnet.ibm.com>
 <20110920154015.GB17731@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920154015.GB17731@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 05:40:15PM +0200, Oleg Nesterov wrote:
> On 09/20, Paul E. McKenney wrote:
> >
> > On Tue, Sep 20, 2011 at 04:39:42PM +0200, Oleg Nesterov wrote:
> > >
> > > --- 3.1/include/linux/cred.h~1_kill_task_is_dead	2011-09-20 16:28:22.000000000 +0200
> > > +++ 3.1/include/linux/cred.h	2011-09-20 16:28:47.000000000 +0200
> > > @@ -284,8 +284,7 @@ static inline void put_cred(const struct
> > >  #define __task_cred(task)						\
> > >  	({								\
> > >  		const struct task_struct *__t = (task);			\
> > > -		rcu_dereference_check(__t->real_cred,			\
> > > -				      task_is_dead(__t));		\
> > > +		rcu_dereference_check(__t->real_cred, 0);		\
> >
> > The "0" above will make lockdep-RCU complain unconditionally.  My guess
> > is that you want rcu_dereference_raw().
> 
> Hmm. I hope you are wrong this time ;)
> 
> rcu_dereference_check() checks rcu_read_lock_held(). IOW, with this
> change __task_cred() always requires rcu_read_lock(), and this is
> what the patch wants.

Oy...  rcu_dereference_check(), not rcu_dereference_protected().

You are correct.

But why not just rcu_dereference()?

> The next one adds " || (task == current" to the rcu_read_lock_held()
> check above.

OK, I guess I got my answer.  ;-)

							Thanx, Paul
