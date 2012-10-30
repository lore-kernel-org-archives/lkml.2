Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2J3P1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab2J3P1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:27:36 -0400
Message-ID: <508FF1D6.3030900@redhat.com>
Date: Tue, 30 Oct 2012 16:27:18 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Tvrtko Ursulin <tvrtko@ursulin.net>, linux-rt-users@vger.kernel.org,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org, okozina@redhat.com
Subject: [PATCH] Fix crypto api init for 3.6.4-rt10
References: <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net> <508EDD6E.7030908@gmail.com> <508EE395.9010709@ursulin.net> <508EEAF2.4090506@ursulin.net> <20121030094001.GV639@pengutronix.de> <508FA405.2050509@redhat.com>
In-Reply-To: <508FA405.2050509@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix crypto api for 3.6.4-rt10 (broken only in realtime patchset)

In peterz-srcu-crypto-chain.patch the blocking notifier is changed
to srcu notifier and added initialization to module init fucntion.

Later, in crypto-make-core-static-and-init-scru-early.patch, is that
initialization added also to core_initcall().

This patch removes crypto_chain init from algapi initialization,
because this function is called later and already initialized
cryptomgr notifier is lost.

This cause a failure in initialization of larval algorithms,
like e.g. cbc(aes).

Signed-off-by: Milan Broz <mbroz@redhat.com>

--- crypto/algapi.c.old	2012-10-30 16:11:23.000000000 +0100
+++ crypto/algapi.c	2012-10-30 16:12:14.988847944 +0100
@@ -956,7 +956,6 @@ EXPORT_SYMBOL_GPL(crypto_xor);
 
 static int __init crypto_algapi_init(void)
 {
-	srcu_init_notifier_head(&crypto_chain);
 	crypto_init_proc();
 	return 0;
 }


