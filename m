Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2JDLwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:52:00 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:33178 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab2JDLv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:51:59 -0400
Date: Thu, 4 Oct 2012 13:51:57 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty_init_dev: 24 callbacks suppressed
Message-ID: <20121004115157.GA245@x4>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004112347.GA245@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.10.04 at 13:23 +0200, Markus Trippelsdorf wrote:
> On 2012.10.04 at 11:20 +0200, Borislav Petkov wrote:
> > Hi,
> > 
> > I'm seeing this on today's Linus tree:
> > 
> > [   24.048278] tty_init_dev: 24 callbacks suppressed
> > [   45.630349] tty_init_dev: 3 callbacks suppressed
> > 
> > It is either from that WARN_RATELIMIT thing or the printk_ratelimited
> > further below in tty_init_dev but I don't know for sure because the
> > actual text message from both printk's doesn't come out in dmesg - only
> > that something got suppressed.
> > 
> > And it quiets down later, after the machine has finished booting. Still,
> > this doesn't tell me anything about any issue. So what's up?
> 
> I'm seeing the same thing.
> This can be fixed by a slightly modified version of:
> https://patchwork.kernel.org/patch/1339221/

My first patch was wrong. This one should be correct:

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index e11ccb4..d8de255 100644
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
+	if (unlikely(rtn && __ratelimit(&_rs)))		\
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
 
-- 
Markus
