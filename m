Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab1D2QSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:18:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691Ab1D2QS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G3y/B5m+22o8XB4s3aX5Z/A4y4FY/25lONW0ZArGHxNPOrMlkostrBt+2thrmL6Gpg
         iF6/TMejMoI/lOd5HyJF18Gv/+N4Viub4fPRNHRCuaup9jpCZ1/ioHekt8iVuaSbcvKx
         3acAF9m1MKAXol780Yy6XdxGnDv9BgNQe6cjI=
Date: Fri, 29 Apr 2011 18:18:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: [PATCH] workqueue: fix deadlock in worker_maybe_bind_and_lock()
Message-ID: <20110429161824.GQ16552@htj.dyndns.org>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
 <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
 <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
 <20110426131132.GG878@htj.dyndns.org>
 <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
 <20110428103036.GB10721@htj.dyndns.org>
 <BANLkTinK3jZmKewkbtmOn54cRXhszh_5sQ@mail.gmail.com>
 <20110429160039.GP16552@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429160039.GP16552@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5035b20fa5cd146b66f5f89619c20a4177fb736d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 29 Apr 2011 18:08:37 +0200

If a rescuer and stop_machine() bringing down a CPU race with each
other, they may deadlock on non-preemptive kernel.  The CPU won't
accept a new task, so the rescuer can't migrate to the target CPU,
while stop_machine() can't proceed because the rescuer is holding one
of the CPU retrying migration.  GCWQ_DISASSOCIATED is never cleared
and worker_maybe_bind_and_lock() retries indefinitely.

This problem can be reproduced semi reliably while the system is
entering suspend.

 http://thread.gmane.org/gmane.linux.kernel/1122051

A lot of kudos to Thilo-Alexander for reporting this tricky issue and
painstaking testing.

stable: This affects all kernels with cmwq, so all kernels since and
        including v2.6.36 need this fix.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
Tested-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: stable@kernel.org
---
Will soon send pull request to Linus.  Thank you very much.

 kernel/workqueue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 04ef830..e3378e8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1291,8 +1291,14 @@ __acquires(&gcwq->lock)
 			return true;
 		spin_unlock_irq(&gcwq->lock);
 
-		/* CPU has come up inbetween, retry migration */
+		/*
+		 * We've raced with CPU hot[un]plug.  Give it a breather
+		 * and retry migration.  cond_resched() is required here;
+		 * otherwise, we might deadlock against cpu_stop trying to
+		 * bring down the CPU on non-preemptive kernel.
+		 */
 		cpu_relax();
+		cond_resched();
 	}
 }
 
-- 
1.7.1

