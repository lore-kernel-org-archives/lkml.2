Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1BRDTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:19:07 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43570 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1BRDTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RUNuGHz7lkMEJPhcfgtpu6lVybnvlepGYtcqRT7euM2+ojsuqOGJmCFTHvh3J4YZHt
         Aa2LXuOa+KA+P7tJELKML/EoCuDnhuXjG2CQJAAc94DNxeurl76lnRiaSvxAnNobA4Bq
         tROF72xRnNxiQrMMdGR1Q8hXcJfQWPAVHXc+k=
MIME-Version: 1.0
In-Reply-To: <4D5DACC5.60105@tilera.com>
References: <4D5DA60A.8080201@tilera.com>
	<20110217.145333.232751283.davem@davemloft.net>
	<4D5DA96D.5060200@tilera.com>
	<20110217.151147.35033921.davem@davemloft.net>
	<4D5DACC5.60105@tilera.com>
Date: Fri, 18 Feb 2011 11:19:03 +0800
Message-ID: <AANLkTimNq0NSiB8SS7KCG2NRLKv9f=XfEKRM4-pQ0v7o@mail.gmail.com>
Subject: Re: IGMP and rwlock: Dead ocurred again on TILEPro
From: Cypher Wu <cypher.w@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 7:18 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 2/17/2011 6:11 PM, David Miller wrote:
>> From: Chris Metcalf <cmetcalf@tilera.com>
>> Date: Thu, 17 Feb 2011 18:04:13 -0500
>>
>>> On 2/17/2011 5:53 PM, David Miller wrote:
>>>> From: Chris Metcalf <cmetcalf@tilera.com>
>>>> Date: Thu, 17 Feb 2011 17:49:46 -0500
>>>>
>>>>> The fix is to disable interrupts for the arch_read_lock family of methods.
>>>> How does that help handle the race when it happens between different
>>>> cpus, instead of between IRQ and non-IRQ context on the same CPU?
>>> There's no race in that case, since the lock code properly backs off and
>>> retries until the other cpu frees it.  The distinction here is that the
>>> non-IRQ context is "wedged" by the IRQ context.
>>>
>>>> Why don't you just use the generic spinlock based rwlock code on Tile,
>>>> since that is all that your atomic instructions can handle
>>>> sufficiently?
>>> The tile-specific code encodes reader/writer information in the same 32-bit
>>> word that the test-and-set instruction manipulates, so it's more efficient
>>> both in space and time.  This may not really matter for rwlocks, since no
>>> one cares much about them any more, but that was the motivation.
>> Ok, but IRQ disabling is going to be very expensive.
>
> The interrupt architecture on Tile allows a write to a special-purpose
> register to put you into a "critical section" where no interrupts or faults
> are delivered.  So we just need to bracket the read_lock operations with
> two SPR writes; each takes six machine cycles, so we're only adding 12
> cycles to the total cost of taking or releasing a read lock on an rwlock.
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>
>


Bye the way, other RISC platforms, say ARM and MIPS, use store
conditional rather that TNS a temp value for lock-val, does Fx have
similar instructions?


-- 
Cyberman Wu
