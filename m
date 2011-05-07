Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1EGFCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 01:02:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1EGFCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 01:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LpoDtU8awoa1boCMtUvg/Sua3q59s+nciKNtLsLOq7A3Wm0FXG24TQxd7SoZp5pVit
         arJlW6ZbrWcmyQlT5D88d952FOE+6RBqw4CPRk3zczVgqDvfzVTcL8oiivvK3auQu39V
         LnHieWWjTJmuGrJipLbQLP9UyITgmV6wLR7JA=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304724519.20980.139.camel@work-vm>
References: <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
	 <1304703767.3066.211.camel@edumazet-laptop>
	 <20110506175051.GL11636@one.firstfloor.org>
	 <1304710003.2821.0.camel@edumazet-laptop>
	 <1304712267.2821.29.camel@edumazet-laptop>
	 <1304713443.20980.124.camel@work-vm>
	 <1304721004.2821.148.camel@edumazet-laptop>
	 <1304722000.20980.130.camel@work-vm>
	 <1304722835.2821.192.camel@edumazet-laptop>
	 <1304724519.20980.139.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 07:02:32 +0200
Message-ID: <1304744552.2821.571.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 mai 2011 à 16:28 -0700, john stultz a écrit :

> Defeating seqlock power? My thoughts are that seqlocks are nice
> lightweight reader/writer locks that avoid writer starvation. You seem
> to be trying to redefine or extend them to be something else which is
> more subtle. 
> 

All I am trying to explain is that a seqlock is a compound of two
things : One spinlock to synchronize writers among themselves, one
seqcount to synchronize readers with a writer.

But the API provides only a compound one. Writer uses the whole locking,
while it would be nice to be able to separate the two steps. Note that
because write_seqlock() and write_sequnlock() are inlined, this would
not increase text size.

One another problem is that spinlock is in same cache line than
seqcount, while a reader doesnt need the spinlock.


> I agree, the code is complex!  I'm just not sure adding more
> complicated/subtle locking mechanisms is a good solution. Instead I'd
> suggest simply splitting up the locks (by using new locks) to reduce the
> amount of data that is being protected by a single lock.
> 
> But again, maybe I'm misunderstanding you?

Adding locks might be fine, I really dont know yet. Its adding yet
another pieces of memory to be dirtied. And total number of cache lines
to be dirtied gives the latency.

I would like to have a ktime_get() service as fast as possible, with
guarded latencies.

Typical workloads need to call it hundred of thousands times per second.



