Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1KYARM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 19:17:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:42147 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752555Ab1KYARJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 19:17:09 -0500
Date: Thu, 24 Nov 2011 19:17:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
In-Reply-To: <CAOS58YMCv0syM7ggzaJeQp6oQxdNAJ9Y5Yn+6Q_Tb7ZjcvPzng@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1111241906020.26861-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011, Tejun Heo wrote:

> Hello,
> 
> On Thu, Nov 24, 2011 at 2:54 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Therefore, when entering the SUSPEND or HIBERNATE stages of system
> > sleep, we can skip the callback to the driver if the device is already
> > in runtime suspend.  When entering the FREEZE stage, however, we should
> > first issue a runtime resume.  The overhead of doing this is
> > negligible, because a suspended drive would be spun up during the THAW
> > stage of hibernation anyway.
> 
> My brain is half fried at the moment so maybe you're saying the same
> thing, but I hope this is something simple. Like...
> 
>     /* for libata runtime suspend is equivalent to suspend */
>     if (runtime suspended && target == SUSPEND) {
>         yeah! skip drive pm ops;
>     } else {
>         end runtime pm;
>         ask EH to enter target PM state;
>     }

Almost.  More like this:

	/*
	 * sd is the only high-level SCSI driver to implement runtime 
	 * PM, and sd treats runtime suspend, system suspend, and 
	 * system hibernate identically (but not system freeze).
	 */
	if (runtime-suspended) {
		if (target == SUSPEND || target == HIBERNATE)
			return 0;	/* already suspended */
		/* wake up device so that FREEZE will succeed */
		pm_runtime_resume();
	}
	tell device driver to enter target PM state

libata does not contain the SCSI device driver; it contains the host
driver.

> I really don't think we need to optimize this further than this.

The above has two lines (plus comments) of optimization.  Okay?

Alan Stern

