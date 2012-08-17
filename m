Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab2HQRjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:39:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58706 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752865Ab2HQRjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:39:07 -0400
Message-ID: <1345225144.10014.2.camel@joe2Laptop>
Subject: Re: [PATCH] ratelimit: check the condition in WARN_RATELIMIT first
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 10:39:04 -0700
In-Reply-To: <1345210942-26906-1-git-send-email-jslaby@suse.cz>
References: <1345210942-26906-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 15:42 +0200, Jiri Slaby wrote:
> Before calling __ratelimit in __WARN_RATELIMIT, check the condition
> first. When this check was not there, we got constant income of:
> tty_init_dev: 60 callbacks suppressed
> tty_init_dev: 59 callbacks suppressed
[]
> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
[]
> @@ -49,8 +49,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
>  #define __WARN_RATELIMIT(condition, state, format...)		\
>  ({								\
>  	int rtn = 0;						\
> -	if (unlikely(__ratelimit(state)))			\
> -		rtn = WARN(condition, format);			\
> +	int __rtcond = !!condition;				\
> +	if (unlikely(__rtcond && __ratelimit(state)))		\
> +		rtn = WARN(__rtcond, format);			\
>  	rtn;							\
>  })
>  

Hi Jiri.

This seems fine to me but are there any conditions that
are computationally expensive?  ratelimit(state) isn't
and this will now always do condition.

(looks instead of speculates)

There's 1 current use of WARN_RATELIMIT and there's
a condition of 1 so there's no problem here.

__WARN_RATELIMIT is pretty stupid.
It's only called from WARN_RATELIMIT.
I think it shouldn't exist at all.

Maybe something like this?

(has some neatening as well)

 include/linux/ratelimit.h |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index e11ccb4..f4acd61 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -46,20 +46,17 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
-#define __WARN_RATELIMIT(condition, state, format...)		\
-({								\
-	int rtn = 0;						\
-	if (unlikely(__ratelimit(state)))			\
-		rtn = WARN(condition, format);			\
-	rtn;							\
-})
-
-#define WARN_RATELIMIT(condition, format...)			\
+#define WARN_RATELIMIT(condition, fmt, ...)			\
 ({								\
 	static DEFINE_RATELIMIT_STATE(_rs,			\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);	\
-	__WARN_RATELIMIT(condition, &_rs, format);		\
+	int rtn = !!(condition);				\
+								\
+	if (unlikely(rtn && __ratelimit(state)))		\
+		WARN(rtn, fmt, ##__VA_ARGS__);			\
+								\
+	rtn;							\
 })
 
 #else
@@ -67,15 +64,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define WARN_ON_RATELIMIT(condition, state)			\
 	WARN_ON(condition)
 
-#define __WARN_RATELIMIT(condition, state, format...)		\
-({								\
-	int rtn = WARN(condition, format);			\
-	rtn;							\
-})
-
-#define WARN_RATELIMIT(condition, format...)			\
+#define WARN_RATELIMIT(condition, fmt, ...)			\
 ({								\
-	int rtn = WARN(condition, format);			\
+	int rtn = WARN(condition, fmt, ##__VA_ARGS__);		\
 	rtn;							\
 })
 



