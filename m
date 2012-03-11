Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2CKO4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 10:56:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56717 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2CKO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 10:56:33 -0400
Date: Sun, 11 Mar 2012 07:56:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>,
        Rusty Russell <rusty@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Message-ID: <20120311145627.GD2404@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
 <87ipifwiwh.fsf@rustcorp.com.au>
 <491D6B4EAD0A714894D8AD22F4BDE043032A1A@SCYBEXDAG04.amd.com>
 <491D6B4EAD0A714894D8AD22F4BDE043032A5E@SCYBEXDAG04.amd.com>
 <4F5AD7F6.2000509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5AD7F6.2000509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031114-3270-0000-0000-000004B5A499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 12:26:30PM +0800, Cong Wang wrote:
> On 03/09/2012 12:13 AM, Chen, Dennis (SRDC SW) wrote:
> >Hi Rusty,
> >
> >Pls notice the following change in the patch (in set_all_modules_text_ro function):
> >
> >/* Iterate through all modules and set each module's text as RO */
> >@@ -1693,7 +1699,7 @@
> >  {
> >         struct module *mod;
> >
> >-       mutex_lock(&module_mutex);
> >+       rcu_read_lock();
> >         list_for_each_entry_rcu(mod,&modules, list) {
> >                 if ((mod->module_core)&&  (mod->core_text_size)) {
> >                         set_page_attributes(mod->module_core,
> >@@ -1706,7 +1712,7 @@
> >                                                 set_memory_ro);
> >                 }
> >         }
> >-       mutex_unlock(&module_mutex);
> >+       rcu_read_unlock();
> >  }
> >
> >This function just needs to iterate the modules list, but now it holds a unnecessary lock when it does that,
> >The other module can't be inserted during this operation, also can you make sure the set_page_attributes will
> >run smoothly all the time, if not it's a risk action to hold a lock.
> >So summary--
> >I think the idea for kernel module protection is simple:
> >Writers to modules, use mutex_lock
> >Readers, use rcu. __ALL__ codes here should be with a unified style! This will make our kernel gracefully.
> >
> >PS: my comments in the patch " /* Concurrent writers for the global modules list are protected by RCU*/" is not right, RCU
> >Should be mutex lock.
> 
> I think your change makes sense, I don't know why preempt_disable()
> was used, git blame told me the related two commits are 4
> years-old...
> 
> cb2a5205 2008-01-14 00:55:03 -0800 3180
> d72b3751 2008-08-30 10:09:00 +0200 3181
> 
> maybe at that time rcu was not what it is today... Cc'ing Paul.

I believe that these use either stop-machine or synchronize_sched()
for updates, so disabling preemption will work for readers.

							Thanx, Paul

