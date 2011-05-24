Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab1EXTxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:53:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54094 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab1EXTxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:53:46 -0400
Date: Tue, 24 May 2011 15:53:37 -0400 (EDT)
Message-Id: <20110524.155337.1293466135362760665.davem@davemloft.net>
To: joe@perches.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for May 24 (ratelimits, CONFIG_PRINTK not
 enabled)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306266580.2298.55.camel@Joe-Laptop>
References: <1306262988.2298.49.camel@Joe-Laptop>
	<20110524.153222.1953796640575918161.davem@davemloft.net>
	<1306266580.2298.55.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 May 2011 12:53:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 24 May 2011 12:49:40 -0700

> On Tue, 2011-05-24 at 15:32 -0400, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Tue, 24 May 2011 11:49:48 -0700
>> > On Tue, 2011-05-24 at 11:33 -0700, Randy Dunlap wrote:
>> >> Adding <linux/ratelimit.h> to <asm-generic/bug.h> causes other problems:
>> > Yup, that's not a good solution.
>> Please come up with a fix or I'll have to revert, thanks Joe.
> 
> I have some errands to run for awhile.
> 
> Probably a revert today and another patch set tomorrow
> might be best.
> 
> This seems to work and doesn't cause any extra state to be
> instantiated when !CONFIG_PRINTK.  What do you think?

Seems fine, here it is as a patch.

Randy please test this, thanks:

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 12b250c..9178484 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -162,6 +162,8 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_once);				\
 })
 
+#ifdef CONFIG_PRINTK
+
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
@@ -181,6 +183,25 @@ extern void warn_slowpath_null(const char *file, const int line);
 	__WARN_RATELIMIT(condition, &_rs, format);		\
 })
 
+#else
+
+#define WARN_ON_RATELIMIT(condition, state)			\
+	WARN_ON(condition)
+
+#define __WARN_RATELIMIT(condition, state, format...)		\
+({								\
+	int rtn = WARN(condition, format);			\
+	rtn;							\
+})
+
+#define WARN_RATELIMIT(condition, format...)			\
+({								\
+	int rtn = WARN(condition, format);			\
+	rtn;							\
+})
+
+#endif
+
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.
