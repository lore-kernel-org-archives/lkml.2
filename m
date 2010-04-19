Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0DSR1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:27:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0DSR1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:27:45 -0400
Date: Mon, 19 Apr 2010 19:27:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>, Tilman Schmidt <tilman@imap.cc>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: tip: origin tree build failure, [patch] fix isdn/gigaset build
 failure
Message-ID: <20100419172731.GA4358@elte.hu>
References: <20100419.003857.260094283.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419.003857.260094283.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> Tilman Schmidt (1):
>       gigaset: include cleanup cleanup
> 
>  drivers/isdn/gigaset/bas-gigaset.c       |    5 -----
>  drivers/isdn/gigaset/capi.c              |    2 --
>  drivers/isdn/gigaset/common.c            |    2 --
>  drivers/isdn/gigaset/gigaset.h           |    2 +-
>  drivers/isdn/gigaset/i4l.c               |    1 -
>  drivers/isdn/gigaset/interface.c         |    1 -
>  drivers/isdn/gigaset/proc.c              |    1 -
>  drivers/isdn/gigaset/ser-gigaset.c       |    3 ---
>  drivers/isdn/gigaset/usb-gigaset.c       |    4 ----

-tip testing triggered the following build failure (x86 allyesconfig):

drivers/isdn/gigaset/common.c: In function 'setflags':
drivers/isdn/gigaset/common.c:99: error: implicit declaration of function 'set_current_state'
drivers/isdn/gigaset/common.c:99: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/isdn/gigaset/common.c:99: error: (Each undeclared identifier is reported only once
drivers/isdn/gigaset/common.c:99: error: for each function it appears in.)
drivers/isdn/gigaset/common.c:100: error: implicit declaration of function 'schedule_timeout'
drivers/isdn/gigaset/common.c: In function 'cleanup_cs':
drivers/isdn/gigaset/common.c:900: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/isdn/gigaset/common.c: In function 'gigaset_start':
drivers/isdn/gigaset/common.c:942: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
drivers/isdn/gigaset/common.c:942: error: implicit declaration of function 'schedule'
drivers/isdn/gigaset/common.c: In function 'gigaset_shutdown':
drivers/isdn/gigaset/common.c:978: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
drivers/isdn/gigaset/common.c: In function 'gigaset_stop':
drivers/isdn/gigaset/common.c:1005: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
make[1]: *** [drivers/isdn/gigaset/common.o] Error 1
make: *** [drivers/isdn/gigaset/common.o] Error 2

Introduced by commit b91ecb00 that got pushed out today. That change removed 
an implicit sched.h inclusion that came in via slab.h.

The patch below fixes it by adding the sched.h dependency.

	Ingo

diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index f6f45f2..a3aa17f 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -16,6 +16,7 @@
 #include "gigaset.h"
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 
 /* Version Information */
 #define DRIVER_AUTHOR "Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>, Stefan Eilers"
