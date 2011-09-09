Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab1IINd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:33:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63559 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015Ab1IINd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:33:26 -0400
Date: Fri, 9 Sep 2011 15:33:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/12] cgroups: Pull up res counter charge failure
 interpretation to caller
Message-ID: <20110909133316.GB14072@somewhere.redhat.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
 <1315267986-28937-9-git-send-email-fweisbec@gmail.com>
 <20110906152650.a2f33bbd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906152650.a2f33bbd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 03:26:50PM -0700, Andrew Morton wrote:
> On Tue,  6 Sep 2011 02:13:02 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > res_counter_charge() always returns -ENOMEM when the limit is reached
> > and the charge thus can't happen.
> > 
> > However it's up to the caller to interpret this failure and return
> > the appropriate error value. The task counter subsystem will need
> > to report the user that a fork() has been cancelled because of some
> > limit reached, not because we are too short on memory.
> > 
> > Fix this by returning -1 when res_counter_charge() fails.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul Menage <paul@paulmenage.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Aditya Kali <adityakali@google.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > Cc: Tim Hockin <thockin@hockin.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > ---
> >  kernel/res_counter.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> > index 4aaa790..45fa6fb 100644
> > --- a/kernel/res_counter.c
> > +++ b/kernel/res_counter.c
> > @@ -26,7 +26,7 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
> >  {
> >  	if (counter->usage + val > counter->limit) {
> >  		counter->failcnt++;
> > -		return -ENOMEM;
> > +		return -1;
> >  	}
> >  
> >  	counter->usage += val;
> 
> This also affects the return value of your new and undocumented
> res_counter_charge_until().
> 
> That's a bit of a hand-grenade which could lead to system calls
> returning -1 (ie: EPERM) to userspace.

Right. What about making it a boolean?
