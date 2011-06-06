Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1FFJCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:02:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:50524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab1FFJCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:02:15 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Arne Jansen <lists@die-jansens.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <4DEBE3DF.70104@die-jansens.de>
References: <20110605151323.GA30590@elte.hu>
	 <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu>
	 <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de>
	 <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu>
	 <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu>
	 <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu>
	 <4DEBE3DF.70104@die-jansens.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 11:01:49 +0200
Message-ID: <1307350909.2353.7408.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 22:15 +0200, Arne Jansen wrote:
> 
> Can lockdep just get confused by the lockdep_off/on calls in printk
> while scheduling is allowed? There aren't many users of lockdep_off().

Yes!, in that case lock_is_held() returns false, triggering the warning.
I guess there's an argument to be made in favour of the below..

---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 53a6895..e4129cf 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3242,7 +3242,7 @@ int lock_is_held(struct lockdep_map *lock)
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);

