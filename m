Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2BBUOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:14:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab2BBUOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:14:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM/Hibernate: Thaw kernel threads in hibernation_snapshot() in error/test path
Date: Thu, 2 Feb 2012 21:18:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120202003359.9930.9844.stgit@srivatsabhat.in.ibm.com> <201202022011.55493.rjw@sisk.pl> <4F2AEB87.70908@linux.vnet.ibm.com>
In-Reply-To: <4F2AEB87.70908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202022118.15863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 02, 2012, Srivatsa S. Bhat wrote:
> On 02/03/2012 12:41 AM, Rafael J. Wysocki wrote:
> 
> > On Thursday, February 02, 2012, Srivatsa S. Bhat wrote:
> >> In the hibernation call path, the kernel threads are frozen inside
> >> hibernation_snapshot(). If we happen to encounter an error further down
> >> the road or if we are exiting early due to a successful freezer test,
> >> then thaw kernel threads before returning to the caller.
> >>
> >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >> ---
> >>
> >>  kernel/power/hibernate.c |    6 ++++--
> >>  kernel/power/user.c      |    8 ++------
> >>  2 files changed, 6 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> >> index a5d4cf0..c6dee73 100644
> >> --- a/kernel/power/hibernate.c
> >> +++ b/kernel/power/hibernate.c
> >> @@ -343,13 +343,13 @@ int hibernation_snapshot(int platform_mode)
> >>  		 * successful freezer test.
> >>  		 */
> >>  		freezer_test_done = true;
> >> -		goto Cleanup;
> >> +		goto Thaw;
> >>  	}
> >>  
> >>  	error = dpm_prepare(PMSG_FREEZE);
> >>  	if (error) {
> >>  		dpm_complete(PMSG_RECOVER);
> >> -		goto Cleanup;
> >> +		goto Thaw;
> >>  	}
> >>  
> >>  	suspend_console();
> >> @@ -385,6 +385,8 @@ int hibernation_snapshot(int platform_mode)
> >>  	platform_end(platform_mode);
> >>  	return error;
> >>  
> >> + Thaw:
> >> +	thaw_kernel_threads();
> > 
> > Actaully, no.  You have to do swsusp_free() before thawing, otherwise
> > some allocations made by the just thawed kernel threads may fail.
> > 
> 
> 
> But then what about the case (in the existing code) when
> freeze_kernel_threads() fails? It would first thaw kernel threads (in
> fact it used to thaw even userspace tasks earlier!) before calling
> swsusp_free(). So, the existing code itself seems to be brittle, considering
> the point you raised. Right?

Well, that's why freeze_kernel_threads() originally hadn't tried to thaw anything
and started to do that after one of the Tejun's commits (and I forgot about
this particular issue back then).

> >>   Cleanup:
> >>  	swsusp_free();
> >>  	goto Close;
> >> diff --git a/kernel/power/user.c b/kernel/power/user.c
> >> index 3e10007..7bee91f 100644
> >> --- a/kernel/power/user.c
> >> +++ b/kernel/power/user.c
> >> @@ -249,16 +249,12 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
> >>  		}
> >>  		pm_restore_gfp_mask();
> >>  		error = hibernation_snapshot(data->platform_support);
> >> -		if (error) {
> >> -			thaw_kernel_threads();
> >> -		} else {
> >> +		if (!error) {
> >>  			error = put_user(in_suspend, (int __user *)arg);
> >>  			if (!error && !freezer_test_done)
> >>  				data->ready = 1;
> >> -			if (freezer_test_done) {
> >> +			if (freezer_test_done)
> >>  				freezer_test_done = false;
> >> -				thaw_kernel_threads();
> >> -			}
> >>  		}
> >>  		break;
> > 
> > Overall, this seems to be a cleanup, or is it a bug fix?
> > 
> 
> 
> This was intended as a cleanup only, not a bug fix. But now, (see my point
> above), I am beginning to feel that the existing code itself is not robust
> enough...

Well, let's pretend that we think it is safe to thaw kernel threads before
freeing memory (actually, they are frozen after the preallocation, so it
really should be OK).

So I think I'll apply your patch after all.

Thanks,
Rafael
