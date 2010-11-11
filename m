Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0KKPXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:23:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53192 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab0KKPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:23:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mm+o92tqIF4yqb1gTKmrXwNTYRb1jXekNAwRHFSWeJa+kmUTsL+1gBObnSQtuhrh4g
         7WQ+fcyUBGhoTFywyI2tgox6gqITrxX8YthtjhJT7PbshJFLxCTZAPOCz1xjApPGXfb+
         +yt5LwPQykMb6xMb7hX9KfJ+LbredpcnpQ/7w=
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 16:23:27 +0100
Message-ID: <1289489007.17691.1310.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :

Hi

CC netdev, since you ask questions about network stuff _and_ rwlock


> I'm using TILEPro and its rwlock in kernel is a liitle different than
> other platforms. It have a priority for write lock that when tried it
> will block the following read lock even if read lock is hold by
> others. Its code can be read in Linux Kernel 2.6.36 in
> arch/tile/lib/spinlock_32.c.

This seems a bug to me.

read_lock() can be nested. We used such a schem in the past in iptables
(it can re-enter itself),
and we used instead a spinlock(), but with many discussions with lkml
and Linus himself if I remember well.


> 
> That different could cause a deadlock in kernel if we join/leave
> Multicast Group simultaneous and frequently on mutlicores. IGMP
> message is sent by
> 
> igmp_ifc_timer_expire() -> igmpv3_send_cr() -> igmpv3_sendpack()
> 
> in timer interrupt, igmpv3_send_cr() will generate the sk_buff for
> IGMP message with mc_list_lock read locked and then call
> igmpv3_sendpack() with it unlocked.
> But if we have so many join/leave messages have to generate and it
> can't be sent in one sk_buff then igmpv3_send_cr() -> add_grec() will
> call igmpv3_sendpack() to send it and reallocate a new buffer. When
> the message is sent:
> 
> __mkroute_output() -> ip_check_mc()
> 
> will read lock mc_list_lock again. If there is another core is try
> write lock mc_list_lock between the two read lock, then deadlock
> ocurred.
> 
> The rwlock on other platforms I've check, say, PowerPC, x86, ARM, is
> just read lock shared and write_lock mutex, so if we've hold read lock
> the write lock will just wait, and if there have a read lock again it
> will success.
> 
> So, What's the criteria of rwlock design in the Linux kernel? Is that
> read lock re-hold of IGMP a design error in Linux kernel, or the read
> lock has to be design like that?
> 

Well, we try to get rid of all rwlocks in performance critical sections.

I would say, if you believe one rwlock can justify the special TILE
behavior you tried to make, then we should instead migrate this rwlock
to a RCU + spinlock schem (so that all arches benefit from this work,
not only TILE)

> There is a other thing, that the timer interrupt will start timer on
> the same in_dev, should that be optimized?
> 

Not sure I understand what you mean.

> BTW: If we have so many cores, say 64, is there other things we have
> to think about spinlock? If there have collisions ocurred, should we
> just read the shared memory again and again, or just a very little
> 'delay' is better? I've seen relax() is called in the implementation
> of spinlock on TILEPro platform.
> --

Is TILE using ticket spinlocks ?


