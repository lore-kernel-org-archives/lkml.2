Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0KDKt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:49:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54007 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0KDKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:49:24 -0400
Date: Thu, 4 Nov 2010 11:49:12 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        tglx@linutronix.de, peterz@infradead.org, mingo@elte.hu,
        eric.dumazet@gmail.com, jkacur@redhat.com
Subject: Re: [1/3] futex: fix compiler warnings in exit_robust_list
Message-ID: <20101104104912.GA27033@pengutronix.de>
References: <1288216466-14309-2-git-send-email-dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288216466-14309-2-git-send-email-dvhart@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Darren,

On Wed, Oct 27, 2010 at 09:54:24PM -0000, Darren Hart wrote:
> The following commit introduced a compiler warning:
> 
> Commit 1dcc41bb037533839753df983d31778b30b67d93
> futex: Change 3rd arg of fetch_robust_entry() to unsigned int*
> 
> The following archs/compiler versions all report:
> kernel/futex.c: In function ‘exit_robust_list’:
> kernel/futex.c:2492: warning: ‘next_pi’ may be used uninitialized in this function
> 
> x86_64
> gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3
> gcc (GCC) 4.4.4 20100630 (Red Hat 4.4.4-10)
> gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5
> 
> sh
> sh-linux-gnu-gcc (Sourcery G++ Lite 4.3-143) 4.3.3
You can add

arm
arm-1136jfs-linux-gnueabi-gcc (OSELAS.Toolchain-1.99.3) 4.3.2

if you want.

> 
> The code path really can't result in next_pi pi being unitialized (or should
> not), but let's keep the build clean. Assign next_pi = 0 to avoid the warnings.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Tested-by: Matt Fleming <matt@console-pimps.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: John Kacur <jkacur@redhat.com>
> 
> ---
> kernel/futex.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index a118bf1..78715cb 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2489,7 +2489,7 @@ void exit_robust_list(struct task_struct *curr)
>  {
>  	struct robust_list_head __user *head = curr->robust_list;
>  	struct robust_list __user *entry, *next_entry, *pending;
> -	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
> +	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi = 0, pip;
I'd prefer

+	unsigned int limit = ROBUST_LIST_LIMIT, pi, uninitialized_var(next_pi), pip;

(modulo line length).  This makes your change more explicit.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
