Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2A3WrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:47:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2A3WrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:47:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM/Hibernate: Thaw kernel threads in SNAPSHOT_CREATE_IMAGE ioctl path
Date: Mon, 30 Jan 2012 23:50:57 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4F271188.3060107@linux.vnet.ibm.com>
In-Reply-To: <4F271188.3060107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201302350.57661.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 30, 2012, Srivatsa S. Bhat wrote:
> In the SNAPSHOT_CREATE_IMAGE ioctl, if the call to hibernation_snapshot()
> fails, the frozen tasks are not thawed.
> 
> And in the case of success, if we happen to exit due to a successful freezer
> test, all tasks (including those of userspace) are thawed, whereas actually
> we should have thawed only the kernel threads at that point. Fix both these
> issues.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied.

Thanks,
Rafael


> ---
> This applies on top of the patch posted at https://lkml.org/lkml/2012/1/27/501
> 
>  kernel/power/user.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index e5a21a8..3e10007 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -249,13 +249,15 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		}
>  		pm_restore_gfp_mask();
>  		error = hibernation_snapshot(data->platform_support);
> -		if (!error) {
> +		if (error) {
> +			thaw_kernel_threads();
> +		} else {
>  			error = put_user(in_suspend, (int __user *)arg);
>  			if (!error && !freezer_test_done)
>  				data->ready = 1;
>  			if (freezer_test_done) {
>  				freezer_test_done = false;
> -				thaw_processes();
> +				thaw_kernel_threads();
>  			}
>  		}
>  		break;
> 
> 
> 
> 

