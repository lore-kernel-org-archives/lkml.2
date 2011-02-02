Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1BBOxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:53:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34283 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1BBOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:53:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SmfwUtGh3OMbdCdg01809a4qwOzQkX6M7COgw+98brDPe9/6YpV6JIyVdrv8+Dedha
         FkMxnZNFb8OX3hHdzLK3JEccSIYNXbIzqaIAoBCT3a3lMeE+F/SgDczKQ1ZpFvBV+BS/
         7k4mxVq6rWmwfrk0oNQ2TVvV9Llm0+xMUOupc=
Subject: Re: kernel 2.6.37 : oops in cleanup_once
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <4D495765.4090806@univ-nantes.fr>
References: <4D491B8D.1000107@univ-nantes.fr>
	 <1296643972.20445.9.camel@edumazet-laptop>
	 <1296645887.20445.11.camel@edumazet-laptop>
	 <4D495765.4090806@univ-nantes.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 15:53:27 +0100
Message-ID: <1296658407.20445.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 février 2011 à 14:08 +0100, Yann Dupont a écrit :
> Le 02/02/2011 12:24, Eric Dumazet a écrit :
> > Le mercredi 02 février 2011 à 11:52 +0100, Eric Dumazet a écrit :
> >> Le mercredi 02 février 2011 à 09:53 +0100, Yann Dupont a écrit :
> >>> Hello.
> >>> We recently upgraded one machine with vanilla 2.6.37, and experienced 2
> >>> kernel oops since. Each oops is after ~1 week of uptime.
> >>> The last oops was last night but we didn't had any trace.
> > oops, 2.6.37 "only"
> >
> >> Yes this is a known problem.
> >>
> >> Please try commit 3408404a4c2a4eead9d73b0bbbfe3f225b65f492
> >> (inetpeer: Use correct AVL tree base pointer in inet_getpeer())
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3408404a4c2a4eead9d73b0bbbfe3f225b65f492
> >>
> >> I believe David will send it to stable team shortly, if not already
> >> done :)
> > Please ignore, this patch was for linux-2.6 tree, 2.6.37 was not
> > affected by the problem.
> >
> > So its another problem... Is there anything particular you do on this
> > machine ?
> >
> >
> >
> >
> Nothing really special there, we run a lot (20) of KVM guest (mainly 
> linux firewalls for lots of differents vlan), so we have a lot of 
> bridges vlan & tun/tap.
> Oh, and CONFIG_BRIDGE_IGMP_SNOOPING is set to n (because of  the other 
> bug already sent to netdev - more to come on next mail)
> 
> Hard to say if this BUG is new in 2.6.37. This host was running fine 
> with 2.6.34.2 since August 2010.
> Bisecting will be hard due to the time to trigger the bug (and the fact 
> that this machine is a production machine)
> 
> Anyway, I can test with a specific kernel version if you suspect something.
> 

I suspect a mem corruption from another layer (not inetpeer)

Unfortunately many kmem caches share the "64 bytes" cache.

Could you please add "slub_nomerge" on your boot command ?


This way, we can separate corruptions on each cache.


On your crash, one inetpeer contain garbage on unused_lists next/prev
pointers :

RCX: 0000000000000005
RDX: 0b000209f1beadde

Definitly something overwrote these values with non pointers values.



