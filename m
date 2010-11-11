Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0KKPc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:32:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49928 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0KKPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QL1tTRKci4BIuO5TyumVTIrPjKymD5d7vub0Z/NSNDDWX6nFVl3dUk2v9/4+IwlRWI
         5jruf0AMXcLx4d3RAT+M7DJka4xmBpzjeV9sJYEnkRE5LNyK0U/RAZa2fwnQFtZziKCE
         DSRpoLeb8c2ghudP2mHmpaucpRNyZ5NAr/+xc=
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1289489007.17691.1310.camel@edumazet-laptop>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 16:32:22 +0100
Message-ID: <1289489542.17691.1325.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 11 novembre 2010 à 16:23 +0100, Eric Dumazet a écrit :
> Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :
> 
> Hi
> 
> CC netdev, since you ask questions about network stuff _and_ rwlock
> 
> 
> > I'm using TILEPro and its rwlock in kernel is a liitle different than
> > other platforms. It have a priority for write lock that when tried it
> > will block the following read lock even if read lock is hold by
> > others. Its code can be read in Linux Kernel 2.6.36 in
> > arch/tile/lib/spinlock_32.c.
> 
> This seems a bug to me.
> 
> read_lock() can be nested. We used such a schem in the past in iptables
> (it can re-enter itself),
> and we used instead a spinlock(), but with many discussions with lkml
> and Linus himself if I remember well.

I meant, a percpu spinlock, and extra logic to spin_lock() it one time,
even if nested.

static inline void xt_info_rdlock_bh(void)
{
        struct xt_info_lock *lock;

        local_bh_disable();
        lock = &__get_cpu_var(xt_info_locks);
        if (likely(!lock->readers++))
                spin_lock(&lock->lock);
}

static inline void xt_info_rdunlock_bh(void)
{
        struct xt_info_lock *lock = &__get_cpu_var(xt_info_locks);

        if (likely(!--lock->readers))
                spin_unlock(&lock->lock);
        local_bh_enable();
}

The write 'rwlock' side has to lock the percpu spinlock of all possible
cpus.

/*
 * The "writer" side needs to get exclusive access to the lock,
 * regardless of readers.  This must be called with bottom half
 * processing (and thus also preemption) disabled.
 */
static inline void xt_info_wrlock(unsigned int cpu)
{
        spin_lock(&per_cpu(xt_info_locks, cpu).lock);
}

static inline void xt_info_wrunlock(unsigned int cpu)
{
        spin_unlock(&per_cpu(xt_info_locks, cpu).lock);
}



