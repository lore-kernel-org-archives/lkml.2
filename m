Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab1ELVAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:00:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559Ab1ELVAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:00:39 -0400
Date: Thu, 12 May 2011 23:00:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vsprintf: Turn kptr_restrict off by default
Message-ID: <20110512210028.GA16600@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <20110512.164319.1770509419224900253.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512.164319.1770509419224900253.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 12 May 2011 13:31:37 -0700
> 
> > That said, I have considered just reverting the thing that makes
> > kptr_restrict be 1 by default. I do like the security implications of
> > restricting visibility into kernel pointers, but I also think that
> > security rules that make the system less usable are dubious. So I
> > dunno.
> 
> We don't have any firewalling or SELINUX rules installed by default, even if 
> those features are enabled in the kernel.  Userspace asks for it.
> 
> Many people would claim that use of such things are "essential" these days.
> 
> I don't see a good reason to handle kptr_restrict any differently.

That's a good argument.

We'll fix the perf bug - i was bitten by another incarnation of it: 'perf top' 
stops showing kernel symbols and it took some time that kptr_restrict was 
turned on by default. I reported it to Arnaldo knows about it but there's no 
fix yet at the moment.

I didnt realize that perf diff got confused by this as well. (but it's logical)

So how about the patch below?

Thanks,

	Ingo

------------------------>
Subject: vsprintf: Turn kptr_restrict off by default

kptr_restrict has been triggering bugs in apps such as perf, and it also makes 
the system less useful by default, so turn it off by default.

This is how we generally handle security features that remove functionality, 
such as firewall code or SELinux - they have to be configured and activated 
from user-space.

Distributions can turn kptr_restrict on again via this line in 
/etc/sysctrl.conf:

kernel.kptr_restrict = 1

( Also mark the variable __read_mostly while at it, as it's typically modified 
  only once per bootup, or not at all. )

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index bc0ac6b..dfd6019 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -797,7 +797,7 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, uuid, spec);
 }
 
-int kptr_restrict = 1;
+int kptr_restrict __read_mostly;
 
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
