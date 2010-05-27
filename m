Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab0E0DOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 23:14:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601Ab0E0DOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 23:14:43 -0400
Date: Wed, 26 May 2010 20:14:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/8] cpuidle: add cpuidle_unregister_driver() error
 check
Message-Id: <20100526201437.51f5c7f7.akpm@linux-foundation.org>
In-Reply-To: <56b9c89c17c1a85886f6d1928349e35bbb48c856.1274926772.git.len.brown@intel.com>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	<56b9c89c17c1a85886f6d1928349e35bbb48c856.1274926772.git.len.brown@intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 22:42:25 -0400 Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> When cpuidle_unregister_driver() is called with a driver
> other than the one that was successfully registered, do nothing.
> 
> Previously we'd NULL-out the one that was registered.
> But that required the callers to remember what this
> routine already remembers.  With this check, the callers
> can be simplified.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/cpuidle/driver.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 2257004..30bcd44 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -49,7 +49,8 @@ void cpuidle_unregister_driver(struct cpuidle_driver *drv)
>  		return;
>  
>  	spin_lock(&cpuidle_driver_lock);
> -	cpuidle_curr_driver = NULL;
> +	if (drv == cpuidle_curr_driver)
> +		cpuidle_curr_driver = NULL;
>  	spin_unlock(&cpuidle_driver_lock);
>  }

This can only happen as a result of a coding bug, yes?  If so, the
kernel should go BUG() rather than secretly concealing the problem.

Also (alternatively), the `drv' arg to this function is superfluous?
