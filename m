Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1DNUnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:43:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34125 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1DNUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:43:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mzRyss2jX0CyrZR3XQEnNNchFozLyNJx+ysPfg9rjiKnvwAbB5d6b4ssauPYDPF2eW
         Xe5emwIkOE0lTuv3pEbiLS8TFvy99bp1K6/EDmVup/ykG+sfRK+rqy1k32KLEiaBGNUA
         YVXuYQ6qj/Hn2GmaWWJmyHvmK2SPSK+PB0knI=
Subject: Re: [PATCH V3] futex: set FLAGS_HAS_TIMEOUT during demux for
 FUTEX_WAIT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <58437d290f34f93366114d6ffb7703330477d1e2.1302813580.git.dvhart@linux.intel.com>
References: <58437d290f34f93366114d6ffb7703330477d1e2.1302813580.git.dvhart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 22:43:15 +0200
Message-ID: <1302813795.2744.41.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 13:39 -0700, Darren Hart a écrit :
> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
> restart futex_wait() without a timeout after a signal.
> 
> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
> of the restart block. Restore the originaly behavior.
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
> 
> V2: Added references to commit message.
> V3: Set flag during restart block instead of do_futex()
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
>  kernel/futex.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index bda4157..9d9c476 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1887,6 +1887,7 @@ retry:
>  	restart->futex.time = abs_time->tv64;
>  	restart->futex.bitset = bitset;
>  	restart->futex.flags = flags;
> +	flags |= FLAGS_HAS_TIMEOUT;
>  
>  	ret = -ERESTART_RESTARTBLOCK;
>  


Hmmm, I am sorry but this wont work... please try :

-	restart->futex.flags = flags;
+	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;


