Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1DWMdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 08:33:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50315 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1DWMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 08:33:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kpvacX7GUSDkzuR24vJpe6VeMB7Gr4XK8+1nJfxVi9SUNUVy3ic1WyFyAU9TioNGll
         V+Yzh0suQDSLfvPDyo4wpLtENpufM7Ls2JA9iRhJc1LpQOlJXtYlR+G/FKGnLVS9GMX5
         svo6mfHcQ2moE0ofeIjGRCP40LY+fdCDcBo2w=
Date: Sat, 23 Apr 2011 20:33:10 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: ignore cached chain key for recursive read
Message-ID: <20110423123310.GA7404@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110417094505.865828233@chello.nl>
 <201104180341.p3I3fnxc000638@www262.sakura.ne.jp>
 <BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com>
 <201104220744.p3M7indA004922@www262.sakura.ne.jp>
 <BANLkTikXSz-AK6BFvnDGEr6Qhx-dekzOQg@mail.gmail.com>
 <201104220831.p3M8VgAO017323@www262.sakura.ne.jp>
 <BANLkTikaU-2g-p676+a6aMdk+CPdSBQE1g@mail.gmail.com>
 <201104220919.p3M9JWfw029700@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201104220919.p3M9JWfw029700@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 06:19:32PM +0900, Tetsuo Handa wrote:
> Yong Zhang wrote:
> > 2011/4/22 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> > >> But if you call locktest1/locktest2 firstly, the chain will not be established
> > >> just because recursive read is not added to prev->after.
> > >
> > > This part is not OK. At least, I think lockdep should be able to establish the
> > > chain when locktest1 is called AGAIN after locktest2 is called (i.e.
> > > "cat /proc/locktest1 /proc/locktest2 /proc/locktest1" case).
> > 
> > I guess lockdep will warn on "cat /proc/locktest1 /proc/locktest2
> > /proc/locktest1"
> 
> It should warn, but it doesn't warn.
> You can confirm it using locktest.c in this thread.

Just confirmed it on my side.

I think below patch could fix it.
BTW, I make it on top of Peter's patch, if you want to apply
it on vanilla kernel, just change "is_rec_read(hlock->rw_state"
to "hlock->read == 2"

Thanks,
Yong

---
Subject: [PATCH] lockdep: ignore cached chain key for recursive read

Currently we don't add recursive read to the dependence
chain but cached the chain key.

So for recursive read, we shoule validate it all the time,
and don't care whether it's cached or not.

If we have such sequence:
1) lock(A); rlock(B);
2) wlock(B); lock(A);
3) lock(A); rlock(B);
lockdep should warn at 3 for "possible circular locking dependency",
but it fails because we have cached the key at 1 and don't validate
again.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/lockdep.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index da6a8be..3ad3442 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1885,7 +1885,23 @@ cache_hit:
 					"%016Lx tail class: [%p] %s\n",
 					(unsigned long long)chain_key,
 					class->key, class->name);
-			return 0;
+			/*
+			 * For recursive read, we validate it all the time,
+			 * since we don't know when wlock is coming.
+			 *
+			 * If we have such sequence:
+			 * 1) lock(A); rlock(B);
+			 * 2) wlock(B); lock(A);
+			 * 3) lock(A); rlock(B);
+			 * lockdep should warn at 3 for "possible circular
+			 * locking dependency", but it fails because
+			 * we have cached the key at 1 and don't validate
+			 * again.
+			 */
+			if (is_rec_read(hlock->rw_state) && graph_lock())
+				return 1;
+			else
+				return 0;
 		}
 	}
 	if (very_verbose(class))
-- 
1.7.1

