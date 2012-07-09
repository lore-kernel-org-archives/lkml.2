Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab2GIBaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 21:30:52 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47589 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2GIBav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:30:51 -0400
Message-ID: <1341797425.2439.1.camel@ThinkPad-T420>
Subject: Re: [PATCH] Fix a dead loop in async_synchronize_full()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 09:30:25 +0800
In-Reply-To: <alpine.DEB.2.01.1207052049540.5568@trent.utfs.org>
References: <1341209044.5102.20.camel@ThinkPad-T420>
	 <alpine.DEB.2.01.1207052049540.5568@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070815-7014-0000-0000-000001869310
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 20:51 -0700, Christian Kujau wrote:
> On Mon, 2 Jul 2012 at 14:04, Li Zhong wrote:
> > This patch tries to fix a dead loop in  async_synchronize_full(), which
> > could be seen when preemption is disabled on a single cpu machine. 
> 
> This helps in my case[0], will this patch be included in -rc6?
> 
> Thanks,
> Christian.
> 
> [0] https://lists.ozlabs.org/pipermail/linuxppc-dev/2012-July/098922.html
> 

Seems it was not included in -rc6 :(  I'll try to resend it today

Thanks, 
Zhong

> 
> > void async_synchronize_full(void)
> > {
> >         do {
> >                 async_synchronize_cookie(next_cookie);
> >         } while (!list_empty(&async_running) || !
> > list_empty(&async_pending));
> > }
> > 
> > async_synchronize_cookie() calls async_synchronize_cookie_domain() with
> > &async_running as the default domain to synchronize. 
> > 
> > However, there might be some works in the async_pending list from other
> > domains. On a single cpu system, without preemption, there is no chance
> > for the other works to finish, so async_synchronize_full() enters a dead
> > loop. 
> > 
> > It seems async_synchronize_full() wants to synchronize all entries in
> > all running lists(domains), so maybe we could just check the entry_count
> > to know whether all works are finished. 
> > 
> > Currently, async_synchronize_cookie_domain() expects a non-NULL running
> > list ( if NULL, there would be NULL pointer dereference ), so maybe a
> > NULL pointer could be used as an indication for the functions to
> > synchronize all works in all domains. 
> > 
> > Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/async.c |   13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/async.c b/kernel/async.c
> > index bd0c168..32d8dc9 100644
> > --- a/kernel/async.c
> > +++ b/kernel/async.c
> > @@ -86,6 +86,13 @@ static async_cookie_t  __lowest_in_progress(struct
> > list_head *running)
> >  {
> >  	struct async_entry *entry;
> >  
> > +	if (!running) { /* just check the entry count */
> > +		if (atomic_read(&entry_count))
> > +			return 0; /* smaller than any cookie */
> > +		else
> > +			return next_cookie;
> > +	}
> > +
> >  	if (!list_empty(running)) {
> >  		entry = list_first_entry(running,
> >  			struct async_entry, list);
> > @@ -236,9 +243,7 @@ EXPORT_SYMBOL_GPL(async_schedule_domain);
> >   */
> >  void async_synchronize_full(void)
> >  {
> > -	do {
> > -		async_synchronize_cookie(next_cookie);
> > -	} while (!list_empty(&async_running) || !list_empty(&async_pending));
> > +	async_synchronize_cookie_domain(next_cookie, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(async_synchronize_full);
> >  
> > @@ -258,7 +263,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
> >  /**
> >   * async_synchronize_cookie_domain - synchronize asynchronous function
> > calls within a certain domain with cookie checkpointing
> >   * @cookie: async_cookie_t to use as checkpoint
> > - * @running: running list to synchronize on
> > + * @running: running list to synchronize on, NULL indicates all lists
> >   *
> >   * This function waits until all asynchronous function calls for the
> >   * synchronization domain specified by the running list @list submitted
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 


