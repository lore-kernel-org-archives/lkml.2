Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1IFUKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:10:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:40107 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab1IFUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:10:13 -0400
Date: Tue, 6 Sep 2011 22:10:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
In-Reply-To: <1315337411.3400.12.camel@edumazet-laptop>
Message-ID: <alpine.LFD.2.02.1109062146150.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>  <1314661157-22173-4-git-send-email-andi@firstfloor.org>  <alpine.LFD.2.02.1109021135270.2723@ionos>  <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> 
 <20110906031411.GA24024@alboin.amr.corp.intel.com>  <20110906145124.GA15390@redhat.com>  <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.LFD.2.02.1109061823100.2723@ionos>  <20110906184926.GA25997@redhat.com>  <alpine.LFD.2.02.1109062110090.2723@ionos>
 <1315337411.3400.12.camel@edumazet-laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1298013382-1315339803=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1298013382-1315339803=:2723
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 6 Sep 2011, Eric Dumazet wrote:
> Le mardi 06 septembre 2011 à 21:16 +0200, Thomas Gleixner a écrit :
> > On Tue, 6 Sep 2011, Oleg Nesterov wrote:
> > Right, but we can solve this by moving the whole detach code into rcu.
> > 
> 
> Why ? Is the dequeue thing guaranteed in the rcu grace period ?

No, as Oleg pointed out we need an rcu_read_lock() in dequeue_signal()
 
> ALso, delaying the idr_remove() probably makes next Andi patch more
> complex (move global timer id management to signal_struct)
> 
> struct k_itimer will need a backpointer to signal_struct, and an
> additional refcount on it.

Well, first of all we need that problem at hand to be fixed.

And the backpointer is not rocket science at all.

--- linux-2.6.orig/include/linux/posix-timers.h
+++ linux-2.6/include/linux/posix-timers.h
@@ -82,7 +82,10 @@ struct k_itimer {
 			unsigned long expires;
 		} mmtimer;
 		struct alarm alarmtimer;
-		struct rcu_head rcu;
+		struct {
+			struct rcu_head rcu;
+			struct signal_struct *it_signal;
+		} rcu;
 	} it;
 };
 
Solves that nicely and we still can get rid of the original *it_signal
and rely on the list_head.

Vs. the refcounting, that should be solvable by a rcu_barrier() before

+   idr_destroy(&sig->posix_timers_id);

in exit_itimers().

Thanks,

	tglx
--8323328-1298013382-1315339803=:2723--
