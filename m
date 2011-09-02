Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab1IBKFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:05:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56054 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab1IBKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:05:21 -0400
Subject: Re: [PATCH 1/4] posix-timers: move global timer id management to
 signal_struct v2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <alpine.LFD.2.02.1109021104140.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
	 <alpine.LFD.2.02.1109021104140.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 12:05:23 +0200
Message-ID: <1314957923.2573.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 septembre 2011 à 11:19 +0200, Thomas Gleixner a écrit :
> On Mon, 29 Aug 2011, Andi Kleen wrote:
> 
> Hint: Ccing maintainers of affected code might help to get code
>       reviewed and eventually merged.

> 
> >  #include <net/net_namespace.h>
> >  
> >  #ifdef CONFIG_SMP
> > @@ -37,6 +38,7 @@ extern struct fs_struct init_fs;
> >  		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
> >  		.signal =  {{0}}},					\
> >  	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
> > +	.idr_lock	 = __SPIN_LOCK_UNLOCKED(idr_lock),		\
> 
>   sig.idr_lock
> 
> Also is there a requirement, that this is a spinlock? AFAICT it's all
> process context and slowpath, so we can make it a mutex.

If so, please Andi remove the idr_pre_get() call : This would be
useless, since we are allowed to sleep under mutex.

This would lower the memory needs of a per-process idr pre-initted with
IDR_FREE_MAX items in free list. This was OK for a system wide
posix_timers_id.



