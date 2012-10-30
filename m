Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152Ab2J3R5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:57:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:51859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759632Ab2J3R5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:57:43 -0400
Date: Tue, 30 Oct 2012 18:57:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Milan Broz <mbroz@redhat.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tvrtko Ursulin <tvrtko@ursulin.net>, linux-rt-users@vger.kernel.org,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org, okozina@redhat.com
Subject: Re: [PATCH] Fix crypto api init for 3.6.4-rt10
In-Reply-To: <508FF1D6.3030900@redhat.com>
Message-ID: <alpine.LFD.2.02.1210301856390.2756@ionos>
References: <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net> <508EDD6E.7030908@gmail.com>
 <508EE395.9010709@ursulin.net> <508EEAF2.4090506@ursulin.net> <20121030094001.GV639@pengutronix.de> <508FA405.2050509@redhat.com> <508FF1D6.3030900@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012, Milan Broz wrote:

> Fix crypto api for 3.6.4-rt10 (broken only in realtime patchset)
> 
> In peterz-srcu-crypto-chain.patch the blocking notifier is changed
> to srcu notifier and added initialization to module init fucntion.
> 
> Later, in crypto-make-core-static-and-init-scru-early.patch, is that
> initialization added also to core_initcall().
> 
> This patch removes crypto_chain init from algapi initialization,
> because this function is called later and already initialized
> cryptomgr notifier is lost.

Grrr. So I forgot top zap the one Peter added. Stupid me.
 
> This cause a failure in initialization of larval algorithms,
> like e.g. cbc(aes).

Thanks for spotting!
 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> 
> --- crypto/algapi.c.old	2012-10-30 16:11:23.000000000 +0100
> +++ crypto/algapi.c	2012-10-30 16:12:14.988847944 +0100
> @@ -956,7 +956,6 @@ EXPORT_SYMBOL_GPL(crypto_xor);
>  
>  static int __init crypto_algapi_init(void)
>  {
> -	srcu_init_notifier_head(&crypto_chain);
>  	crypto_init_proc();
>  	return 0;
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
