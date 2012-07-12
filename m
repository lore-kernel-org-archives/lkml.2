Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab2GLCtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:49:43 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43797 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab2GLCtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:49:41 -0400
Message-ID: <1342061369.4091.21.camel@ThinkPad-T420>
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Jul 2012 10:49:29 +0800
In-Reply-To: <20120711154232.165cbca9.akpm@linux-foundation.org>
References: <1341817465.4579.5.camel@ThinkPad-T420>
	 <20120711154232.165cbca9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12071116-1396-0000-0000-0000018BD6D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 15:42 -0700, Andrew Morton wrote:
> On Mon, 09 Jul 2012 15:04:25 +0800
> Li Zhong <zhong@linux.vnet.ibm.com> wrote:
> 
> > This patch tries to fix a dead loop in  async_synchronize_full(), which
> > could be seen when preemption is disabled on a single cpu machine. 
> > 
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
> 
> The patch is fairly wordwrapped - please fix up your email client.

Ah, sorry for that, I will check it. 

> 
> More seriously, it does not apply to linux-next due to some fairly
> significant changes which have been sitting in Dan's tree since May. 
> What's going on?
> 

Just went through Dan's patches, it seems that they also had
async_synchronize_full() to sync all domains. I will test/check those
patches, and drop this one if the result is good. 

