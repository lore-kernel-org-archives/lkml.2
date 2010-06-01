Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab0FAVjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:39:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53681 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0FAVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kIG63YT9ZvowCHdCmURQBy14mAap6bojSBCySN4vwzsT1XPEVwNAiPyksPmlHpetmY
         /j9HppR64V0OrAad1t/3ekci2FhmaX+zf9amLJ7ywFVFpsqdlwiMgErG7MrhsnYYHThi
         22qGzZrHWJmyttDL4cADPxwAPY6krYjzVh6qA=
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <4C053ACC.5020708@redhat.com>
References: <20100601093515.GH24302@redhat.com>
	 <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com>
	 <20100601163807.GA11880@basil.fritz.box>  <4C053ACC.5020708@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 23:39:14 +0200
Message-ID: <1275428354.2638.104.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 juin 2010 à 19:52 +0300, Avi Kivity a écrit :

> What I'd like to see eventually is a short-term-unfair, long-term-fair 
> spinlock.  Might make sense for bare metal as well.  But it won't be 
> easy to write.
> 

This thread rings a bell here :)

Yes, ticket spinlocks are sometime slower, especially in workloads where
a spinlock needs to be taken several times to handle one unit of work,
and many cpus competing.

We currently have kind of a similar problem in network stack, and we
have a patch to speedup xmit path by an order of magnitude, letting one
cpu (the consumer cpu) to get unfair access to the (ticket) spinlock.
(It can compete with no more than one other cpu)

Boost from ~50.000 to ~600.000 pps on a dual quad core machine (E5450
@3.00GHz) on a particular workload (many cpus want to xmit their
packets)

( patch : http://patchwork.ozlabs.org/patch/53163/ )


It could be possible to write such a generic beast, with a cascade or
regular ticket spinlocks ?

One ticket spinlock at first stage (only if some conditions are met, aka
slow path), then an 'primary' spinlock at second stage.


// generic implementation
// (x86 could use 16bit fields for users_in & user_out)
struct cascade_lock {
	atomic_t 	users_in;
	int		users_out;
	spinlock_t	primlock;
	spinlock_t	slowpathlock; // could be outside of this structure, shared by many 'cascade_locks'
};

/*
 * In kvm case, you might call hypervisor when slowpathlock is about to be taken ?
 * When a cascade lock is unlocked, and relocked right after, this cpu has unfair
 * priority and could get the lock before cpus blocked in slowpathlock (especially if
 * an hypervisor call was done)
 *
 * In network xmit path, the dequeue thread would use highprio_user=true mode
 * In network xmit path, the 'contended' enqueueing thread would set a negative threshold,
 *  to force a 'lowprio_user' mode.
 */
void cascade_lock(struct cascade_lock *l, bool highprio_user, int threshold)
{
	bool slowpath = false;

	atomic_inc(&l->users_in); // no real need for atomic_inc_return()
	if (atomic_read(&l->users_in) - l->users_out > threshold && !highprio_user)) {
		spin_lock(&l->slowpathlock);
		slowpath = true;
	}
	spin_lock(&l->primlock);
	if (slowpath)
		spin_unlock(&l->slowpathlock);
}

void cascade_unlock(struct cascade_lock *l)
{
	l->users_out++;
	spin_unlock(&l->primlock);
}



