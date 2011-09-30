Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1I3P4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:56:48 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34874 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab1I3P4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:56:47 -0400
Subject: Re: [RFC][PATCH 2/5] signal: Add rwlock to protect sighand->action
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
In-Reply-To: <1317395577-14091-3-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <1317395577-14091-3-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 16:56:43 +0100
Message-ID: <1317398203.3375.25.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 16:12 +0100, Matt Fleming wrote:
> @@ -2935,9 +3025,11 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
>  	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
>  		return -EINVAL;
>  
> +	spin_lock_irq(&current->sighand->siglock);
> +	read_lock(&current->sighand->action_lock);
> +
>  	k = &t->sighand->action[sig-1];
>  
> -	spin_lock_irq(&current->sighand->siglock);
>  	if (oact)
>  		*oact = *k;
>  
> @@ -2967,6 +3059,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
>  		}
>  	}
>  
> +	read_unlock(&current->sighand->action_lock);
>  	spin_unlock_irq(&current->sighand->siglock);
>  	return 0;
>  }

Guh! I just noticed this. That should obviously be write-locked.

-- 
Matt Fleming, Intel Open Source Technology Center

