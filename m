Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1EZMcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:32:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518Ab1EZMcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:32:01 -0400
Date: Thu, 26 May 2011 14:31:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: [patch] net/core/filter.c: Fix build error
Message-ID: <20110526123153.GA16002@elte.hu>
References: <cover.1305999731.git.joe@perches.com>
 <efa062542c692c3f7743bf2d97b5987ab989e27e.1305999731.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efa062542c692c3f7743bf2d97b5987ab989e27e.1305999731.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> A mis-configured filter can spam the logs with lots of stack traces.
> 
> Rate-limit the warnings and add printout of the bogus filter information.
> 
> Original-patch-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/core/filter.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 0eb8c44..0e3622f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -350,7 +350,9 @@ load_b:
>  			continue;
>  		}
>  		default:
> -			WARN_ON(1);
> +			WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
> +				       fentry->code, fentry->jt,
> +				       fentry->jf, fentry->k);
>  			return 0;
>  		}

This change (now upstream) fails to build in about 20% of all 
randconfigs. Fix is below.

Thanks,

	Ingo

--------------------->
>From b658026bc4915d16ff3e0f59b0edda11dbd6b991 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 26 May 2011 14:11:14 +0200
Subject: [PATCH] net/core/filter.c: Fix build error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix:

  net/core/filter.c:353:4: error: invalid storage class for function ‘DEFINE_RATELIMIT_STATE’

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 net/core/filter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0e3622f..36f975f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -38,6 +38,7 @@
 #include <asm/unaligned.h>
 #include <linux/filter.h>
 #include <linux/reciprocal_div.h>
+#include <linux/ratelimit.h>
 
 /* No hurry in this branch */
 static void *__load_pointer(const struct sk_buff *skb, int k, unsigned int size)
