Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1L1POo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 10:14:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64934 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1L1POk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 10:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <1325083051.2327.47.camel@deadeye>
References: <1325075319-13464-1-git-send-email-gurligebis@gentoo.org>
	<1325083051.2327.47.camel@deadeye>
Date: Wed, 28 Dec 2011 16:14:39 +0100
X-Google-Sender-Auth: PEtifHPRc1Vp4U7o8Yv9NdYYyzs
Message-ID: <CACPM=kWpGnBOuKPUK9MgzyETe4VmvEtVXkYtPA_+Xgn=COkCPw@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Roger Luethi <rl@hellgate.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/28 Ben Hutchings <bhutchings@solarflare.com>:
> On Wed, 2011-12-28 at 12:28 +0000, Bjarke Istrup Pedersen wrote:
>> Working around problem causing high CPU load and hanging system when
>> there is alot of network trafic.
>>
>> It is kind of an ugly way to work around it, but it allows the Soekris
>> net5501 to have trafic between two of it's NICs without hanging so much
>> that the watchdog kicks in and does a hard reboot of the system.
>>
>> There is more info on the problem here:
>> http://http://lists.soekris.com/pipermail/soekris-tech/2010-October/016889.html
>>
>> Tested with positive results on two Soekris net5501-70 boxes.
>
> This is completely wrong.  In a UP configuration the extra spinlock
> calls have no effect (except perhaps a small delay).  In an SMP
> configuration they will cause rhine_tx() to deadlock when it also tries
> to acquire the spinlock.
>
> Ben.

Okay, the Soekris net5501-70 boxes are single-core, and I haven't got
any SMP boxes with that nic.
Is there a better solution for the problem then, to avoid it hanging
the box on a non-smp machine with a slow (500mhz) cpu?

/Bjarke

> [...]
>> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
>> index f34dd99..8c77dcd 100644
>> --- a/drivers/net/ethernet/via/via-rhine.c
>> +++ b/drivers/net/ethernet/via/via-rhine.c
>> @@ -1567,6 +1567,9 @@ static irqreturn_t rhine_interrupt(int irq, void *dev_instance)
>>         int boguscnt = max_interrupt_work;
>>         int handled = 0;
>>
>> +       if (!spin_trylock(&rp->lock))
>> +               return IRQ_RETVAL(handled);
>> +
>>         while ((intr_status = get_intr_status(dev))) {
>>                 handled = 1;
>>
>> @@ -1616,6 +1619,8 @@ static irqreturn_t rhine_interrupt(int irq, void *dev_instance)
>>                 }
>>         }
>>
>> +       spin_unlock(&rp->lock);
>> +
>>         if (debug > 3)
>>                 netdev_dbg(dev, "exiting interrupt, status=%08x\n",
>>                            ioread16(ioaddr + IntrStatus));
>
> --
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
>
