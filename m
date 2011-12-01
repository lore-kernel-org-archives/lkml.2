Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1LAVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:50:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab1LAVu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:50:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM / Hibernate: Thaw processes in SNAPSHOT_CREATE_IMAGE ioctl error/test paths
Date: Thu, 1 Dec 2011 22:53:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, pavel@ucw.cz, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20111201131532.21615.86479.stgit@srivatsabhat.in.ibm.com> <20111201154722.GB12668@google.com> <4ED7AB26.4080804@linux.vnet.ibm.com>
In-Reply-To: <4ED7AB26.4080804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112012253.20250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 01, 2011, Srivatsa S. Bhat wrote:
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

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  kernel/power/hibernate.c |    2 +-
>  kernel/power/power.h     |    2 ++
>  kernel/power/user.c      |   11 ++++++++---
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 80c2d90..57bab63 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -55,7 +55,7 @@ enum {
>  
>  static int hibernation_mode = HIBERNATION_SHUTDOWN;
>  
> -static bool freezer_test_done;
> +bool freezer_test_done;
>  
>  static const struct platform_hibernation_ops *hibernation_ops;
>  
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 23a2db1..0c4defe 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -50,6 +50,8 @@ static inline char *check_image_kernel(struct swsusp_info *info)
>  #define SPARE_PAGES	((1024 * 1024) >> PAGE_SHIFT)
>  
>  /* kernel/power/hibernate.c */
> +extern bool freezer_test_done;
> +
>  extern int hibernation_snapshot(int platform_mode);
>  extern int hibernation_restore(int platform_mode);
>  extern int hibernation_platform_enter(void);
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 7cc3f5b..c202e2e 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -281,10 +281,15 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		}
>  		pm_restore_gfp_mask();
>  		error = hibernation_snapshot(data->platform_support);
> -		if (!error)
> +		if (!error) {
>  			error = put_user(in_suspend, (int __user *)arg);
> -		if (!error)
> -			data->ready = 1;
> +			if (!error && !freezer_test_done)
> +				data->ready = 1;
> +			if (freezer_test_done) {
> +				freezer_test_done = false;
> +				thaw_processes();
> +			}
> +		}
>  		break;
>  
>  	case SNAPSHOT_ATOMIC_RESTORE:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

