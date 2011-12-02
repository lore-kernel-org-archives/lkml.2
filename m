Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1LBTal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:30:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54645 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab1LBTaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:30:39 -0500
Date: Fri, 2 Dec 2011 20:30:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernate: Thaw processes in
	SNAPSHOT_CREATE_IMAGE ioctl error/test paths
Message-ID: <20111202193037.GA31987@atrey.karlin.mff.cuni.cz>
References: <20111201131532.21615.86479.stgit@srivatsabhat.in.ibm.com> <20111201154722.GB12668@google.com> <4ED7AB26.4080804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED7AB26.4080804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/01/2011 09:17 PM, Tejun Heo wrote:
> 
> > On Thu, Dec 01, 2011 at 06:45:37PM +0530, Srivatsa S. Bhat wrote:
> >> Commit 2aede851ddf08666f68ffc17be446420e9d2a056 (PM / Hibernate: Freeze
> >> kernel threads after preallocating memory) moved the freezing of kernel
> >> threads to hibernation_snapshot() function.
> >>
> >> So now, if the call to hibernation_snapshot() fails or returns early due
> >> to a successful hibernation test, the caller has to thaw processes to
> >> ensure that the system gets back to its original state.
> >>
> >> But in SNAPSHOT_CREATE_IMAGE hibernation ioctl, the caller does not thaw
> >> processes. Fix this issue. But note that if hibernation_snapshot() returned
> >> due to a successful freezer test, we still send the value of 'in_suspend'
> >> (which is now 0) to userspace, because we are not in an error path per-se,
> >> and moreover, the value of in_suspend correctly depicts the situation here.
> >>
> >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > 
> > Is this still applicable on top of pm-freezer branch?
> > 
> 
> 
> Well, yes, but not in this form. Thanks for bringing that up!
> 
> If the call to hibernation_snapshot() returns an error, we need not do
> anything since your freezer changes handle that case and call thaw_processes()
> automatically.
> But in case of return due to a successful freezer test, we would need to
> explicitly thaw processes since the freezer successfully froze them in the
> previous step.
> 
> So the following patch would do that, for the pm-freezer branch:
> 
> ---
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] PM / Hibernate: Thaw processes in SNAPSHOT_CREATE_IMAGE ioctl test path
> 
> Commit 2aede851ddf08666f68ffc17be446420e9d2a056 (PM / Hibernate: Freeze
> kernel threads after preallocating memory) moved the freezing of kernel
> threads to hibernation_snapshot() function.
> 
> So now, if the call to hibernation_snapshot() returns early due to a
> successful hibernation test, the caller has to thaw processes to ensure
> that the system gets back to its original state.
> 
> But in SNAPSHOT_CREATE_IMAGE hibernation ioctl, the caller does not thaw
> processes in case hibernation_snapshot() returned due to a successful
> freezer test. Fix this issue. But note we still send the value of 'in_suspend'
> (which is now 0) to userspace, because we are not in an error path per-se,
> and moreover, the value of in_suspend correctly depicts the situation here.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
