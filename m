Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab0LWWMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:12:13 -0500
Received: from amavis-outgoing1.knology.net ([24.214.64.230]:46145 "EHLO
	amavis-outgoing1.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab0LWWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:12:12 -0500
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2010 17:12:12 EST
Subject: Re: [PATCH 01/30] infiniband: update workqueue usage
From: David Dillow <dave@thedillows.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
In-Reply-To: <4D0A4372.2010503@kernel.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	 <1292086307-19211-2-git-send-email-tj@kernel.org>
	 <adad3p2hony.fsf@cisco.com>  <4D0A4372.2010503@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 16:47:08 -0500
Message-ID: <1293140828.2896.9.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 17:50 +0100, Tejun Heo wrote:
> On 12/15/2010 07:33 PM, Roland Dreier wrote:
> > 
> >  > * qib_wq is removed and ib_wq is used instead.
> > 
> > You obviously looked at the comment
> > 
> > -	/*
> > -	 * We create our own workqueue mainly because we want to be
> > -	 * able to flush it when devices are being removed.  We can't
> > -	 * use schedule_work()/flush_scheduled_work() because both
> > -	 * unregister_netdev() and linkwatch_event take the rtnl lock,
> > -	 * so flush_scheduled_work() can deadlock during device
> > -	 * removal.
> > -	 */
> > -	qib_wq = create_workqueue("qib");
> > 
> > and know that with the new workqueue stuff, this issue no longer
> > exists.  But for both my education and also the clarity of the changelog
> > for this patch, perhaps you could expand on why ib_wq is safe here.
> 
> I think I got confused.  I thought the comment was indicating the
> separation between qib_wq and qib_cq_wq.  It's between system_wq and
> qib_wq, right?  I'll drop this part from the series, but then again
> what's the difference from ib_srp, which flushes the common workqueue?
> Why doesn't ib_srp have the same problem?

Looking at qib, I'm not sure the comment isn't confused -- the only
place I see where qib_wq or qib_cq_wq get flushed is by
destroy_workqueue() when the module is being unloaded. And we shouldn't
be there with rtnl_lock held by the caller.

Roland, please let me know how plan to proceed -- I need to update
ib_srp to get rid of *scheduled_work(), and I can either use the IB
core's queue, or define my own. Since it's cheap, I don't suppose it
matters much, but I think I'd prefer to share if possible.

Thanks,
Dave


