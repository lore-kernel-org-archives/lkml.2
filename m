Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab1DNS4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:56:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44223 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378Ab1DNS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nueJmJTuV2KhFm+6nyd+0MRC5cYX1wuwvy3FfNwGEqO2Jux/PKqUPN6brg0NiaKmz6
         9XKFN/RP3RijFmjWOJYMNuK97iHYGFLEgB5PiIPesUlAp1lZogXaJb/n9kFMRJlWrShs
         vCzuv4AEVqZ5XN6+J3ScHpIqrjOu90bxXl4vY=
Subject: Re: [PATCH V2] futex: set FLAGS_HAS_TIMEOUT during demux for
 FUTEX_WAIT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <6aed1a53d080a90672bd44b773079dd81ac90b50.1302806742.git.dvhart@linux.intel.com>
References: <1302800949.3248.42.camel@edumazet-laptop>
	 <6aed1a53d080a90672bd44b773079dd81ac90b50.1302806742.git.dvhart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 20:56:31 +0200
Message-ID: <1302807391.2744.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 11:45 -0700, Darren Hart a écrit :
> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
> restart futex_wait() without a timeout after a signal.
> 
> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
> of the restart block. It makes more sense to set the flag earlier during
> do_futex() where the other flags are set, although futex_wait is the only user
> of FLAGS_HAS_TIMEOUT as it is the only op using a relative timeout (an
> unfortunately preexisting condition).
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
> 
> V2: Added references to commit message.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Reported-by: Tim Smith <tsmith201104@yahoo.com>
> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: John Kacur <jkacur@redhat.com>
> ---
>  kernel/futex.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index bda4157..6eac6b6 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2589,6 +2589,9 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>  			return -ENOSYS;
>  	}
>  
> +	if (timeout)
> +		flags |= FLAGS_HAS_TIMEOUT;
> +
>  	switch (cmd) {
>  	case FUTEX_WAIT:
>  		val3 = FUTEX_BITSET_MATCH_ANY;


I dont agree with your fix. You add yet another test in futex fastpath.

Prior commit  b41277dc7a18ee332d, this was done only in case of restart.

Could we instead use 

diff --git a/kernel/futex.c b/kernel/futex.c
index dfb924f..fe28dc2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1886,7 +1886,7 @@ retry:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = flags;
+	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
 
 	ret = -ERESTART_RESTARTBLOCK;
 


