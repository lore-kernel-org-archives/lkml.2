Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0LOSmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:42:51 -0500
Received: from ams-iport-1.cisco.com ([144.254.224.140]:17838 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0LOSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:42:49 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Dec 2010 13:42:49 EST
Authentication-Results: ams-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,350,1288569600"; 
   d="scan'208";a="71728491"
From: Roland Dreier <rdreier@cisco.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCH 01/30] infiniband: update workqueue usage
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	<1292086307-19211-2-git-send-email-tj@kernel.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 15 Dec 2010 10:33:05 -0800
In-Reply-To: <1292086307-19211-2-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Sat, 11 Dec 2010 17:51:18 +0100")
Message-ID: <adad3p2hony.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Tejun.  A couple questions:

 > * ib_wq is added, which is used as the common workqueue for infiniband
 >   instead of the system workqueue.  All system workqueue usages
 >   including flush_scheduled_work() callers are converted to use and
 >   flush ib_wq.  This is to prepare for deprecation of
 >   flush_scheduled_work().

Why do we want to move to a subsystem-specific workqueue?  Can we just
replace flush_scheduled_work() by cancel_delayed_work_sync() as
appropriate and not create yet another work queue?

 > * qib_wq is removed and ib_wq is used instead.

You obviously looked at the comment

-	/*
-	 * We create our own workqueue mainly because we want to be
-	 * able to flush it when devices are being removed.  We can't
-	 * use schedule_work()/flush_scheduled_work() because both
-	 * unregister_netdev() and linkwatch_event take the rtnl lock,
-	 * so flush_scheduled_work() can deadlock during device
-	 * removal.
-	 */
-	qib_wq = create_workqueue("qib");

and know that with the new workqueue stuff, this issue no longer
exists.  But for both my education and also the clarity of the changelog
for this patch, perhaps you could expand on why ib_wq is safe here.

 > * create[_singlethread]_workqueue() usages are replaced with the new
 >   alloc[_ordered]_workqueue().  This removes rescuers from all
 >   infiniband workqueues.

What are rescuers?

Can we replace some of these driver-specific work queues by the ib_wq?

Are all these things just possibilities for future cleanup?

Thanks,
  Roland
