Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1HVJyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:54:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45932 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1HVJyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:54:03 -0400
Date: Mon, 22 Aug 2011 11:53:57 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Jens Axboe <axboe@kernel.dk>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Subject: Re: [PATCH 04/16] freezer: implement and use
 kthread_freezable_should_stop()
Message-ID: <20110822095357.GC24151@htj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-5-git-send-email-tj@kernel.org>
 <20110821191421.GA9793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110821191421.GA9793@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Sun, Aug 21, 2011 at 09:14:21PM +0200, Oleg Nesterov wrote:
> But. can't __refrigerator() race with thaw_process() in this case?
> 
> > +bool __refrigerator(bool check_kthr_stop)
> >  {
> >  	/* Hmm, should we be allowed to suspend when there are realtime
> >  	   processes around? */
> > @@ -50,7 +51,8 @@ bool __refrigerator(void)
> >
> >  	for (;;) {
> >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > -		if (!frozen(current))
> > +		if (!frozen(current) ||
> > +		    (check_kthr_stop && kthread_should_stop()))
> >  			break;
> 
> OK, but then we do
> 
> 	current->flags &= ~PF_FREEZING;
> 
> since PF_FROZEN wasn't cleared this can race with
> 
> 	p->flags &= ~PF_FROZEN;
> 
> No?

Indeed, I removed PF_FREEZING and moved PF_FROZEN to __refrigerator()
in later patches, so it's already gone.  Patches could have been
sequenced better, I suppose.  But, sequencing fixes for different
races was already pretty challenging.  :)

Thanks.

-- 
tejun
