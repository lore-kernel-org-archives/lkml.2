Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab1EFRmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:42:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53094 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1EFRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mfy+9wgKzcm3sqBSrxzZMj3FR4LNMpfZxIBsv1mqiQzWN0iQAnGp3tIHvFcmxZyfkM
         UspL//VfbP5ZQPYkR+ylfII2dnYuZBpMpx/bkYIT2SRp3TBEavJM5+D+yMHoshNTmQKP
         0XGVybyspUCiL1UwObj3MPc4VwrJgrq+X7j8I=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110506165913.GF11636@one.firstfloor.org>
References: <m2oc3jxgtt.fsf@firstfloor.org>
	 <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 19:42:47 +0200
Message-ID: <1304703767.3066.211.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 mai 2011 à 18:59 +0200, Andi Kleen a écrit :

> If you have a better way to make it faster please share it.

Ideally we could use RCU :)

Have whatever state hold in one structure (possibly big, it doesnt
matter) and switch pointer in writer once everything is setup in new
structure.

struct {
	struct timespec xtime;
	struct timespec wall_to_monotonic;
	...
	} time_keep_blob;

struct time_keep_blob __rcu *xtime_cur;

ktime_t ktime_get(void)
{
	const struct time_keep_blob *xp;
	s64 secs, nsecs;

	rcu_read_lock();
	xp = rcu_dereference(xtime_cur);
	secs = xp->xtime.tv_sec + xp->wall_to_monotonic.tv_sec;
	nsecs = xp->xtime.tv_nsec + xp->wall_to_monotonic.tv_nsec;
	nsecs += timekeeping_get_ns(xp);
	rcu_read_unlock();

	return ktime_add_ns(ktime_set(secs, 0), nsecs);
}

I dont know timekeeping details, maybe its necessary to loop if
xtime_cur changes :

ktime_t ktime_get(void)
{
	const struct time_keep_blob *xp;
	s64 secs, nsecs;

	rcu_read_lock();
	do {
		xp = rcu_dereference(xtime_cur);
		secs = xp->xtime.tv_sec + xp->wall_to_monotonic.tv_sec;
		nsecs = xp->xtime.tv_nsec + xp->wall_to_monotonic.tv_nsec;
		nsecs += timekeeping_get_ns(xp);
	} while (rcu_dereference(xtime_cur) != xp);
	rcu_read_unlock();
	return ktime_add_ns(ktime_set(secs, 0), nsecs);
}



