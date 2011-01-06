Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1AFXez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:34:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37245 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1AFXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nMUaDMYgzx7xOS7L1onoHvRKIlJeI/ZmjxYRK9jzsql/IB2OezPtDO4RbmjYC0tUYh
         J65HOJO1K2HPSktTjrVxvTRU+7F8xvtYrwKIIkDopiU42gh7cNgicWLoyW3ESjWxoXFK
         qovMKKnuls1ybhzeqXYoWYniJPj7cMk+nAcY8=
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not
 used
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jesse Gross <jesse@nicira.com>
Cc: Matt Carlson <mcarlson@broadcom.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <AANLkTincX-wPQE9gs16v53E4=Skivzc4ZSJS43oNBLD_@mail.gmail.com>
References: <1291536233.2806.102.camel@edumazet-laptop>
	 <20101205105528.49fa9a9f@xenia.leun.net>
	 <20101205114404.7c0cddc2@xenia.leun.net>
	 <AANLkTikrDTCDxsyOG4m0XcrOY=3pTRwWqnPGsio9cBFj@mail.gmail.com>
	 <20101206203437.54b550e0@xenia.leun.net>
	 <AANLkTikKkAesHc4Fi4SwAkV0e65D0TQRztrRYoDNu3MP@mail.gmail.com>
	 <20101206222703.32fbe852@xenia.leun.net>
	 <AANLkTinLMCzKz7n45HdeAwNxsWjCADAkgfK+MjXVcFqh@mail.gmail.com>
	 <20101213224510.GB17400@mcarlson.broadcom.com>
	 <AANLkTi=9BYt=vkNkAiTBxnfnCjCX7AqCG=ML6coc4vdZ@mail.gmail.com>
	 <20101214191500.GD19951@mcarlson.broadcom.com>
	 <1293901393.2535.49.camel@edumazet-laptop>
	 <AANLkTinq9ABi0prxe0m1Ma6rno4UnAOzuW-b5L362ij9@mail.gmail.com>
	 <1293984348.2535.101.camel@edumazet-laptop>
	 <AANLkTincX-wPQE9gs16v53E4=Skivzc4ZSJS43oNBLD_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 00:34:47 +0100
Message-ID: <1294356887.2704.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 06 janvier 2011 à 16:01 -0500, Jesse Gross a écrit :

> Hmm, I thought that it might be some interaction with a corner case in
> the networking core but now it seems less likely.  There weren't too
> many vlan changes between the working and non-working states.  Plus,
> since the rx counter isn't increasing, the packets probably aren't
> making it anywhere.
> 
> I see that tg3 increases the drop counter in one place, which also
> happens to be checking for vlan errors (at tg3.c:4753).  That seems
> suspicious - maybe the NIC is only partially configured for vlan
> offloading.  If we can confirm that is where the drop counter is being
> incremented and what the error code is maybe it would shed some light.
> 

Hmm... I am pretty sure the drop counter is the dev rx_dropped (core
network handled, not tg3 one) incremented at the end of
__netif_receive_skb() : We found no suitable handler for packets.

atomic_long_inc(&skb->dev->rx_dropped);

But thats a guess, I'll have to check

> If it's a driver issue I don't have much insight - maybe Matt or
> bisect can help.
> 
> >> If it works on bnx2, it would seem to be a driver problem but it would
> >> be good to confirm that the tag in skb->vlan_tci is not being
> >> delievered to the networking core in this case.
> >
> > Hmm, where do you want me to check this ?
> 
> I was thinking right before vlan_gro_receive() at tg3.c:4837.  If my
> theory above is right then this obviously isn't relevant since it
> won't be hit at all.  Otherwise it would be good to know exactly what
> the driver is producing.


