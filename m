Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1KEWRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 18:17:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53762 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1KEWRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 18:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <1320378386.3079.56.camel@deadeye>
References: <cover.1320369398.git.david.decotigny@google.com>
 <267015997eb594f2fd859acd572aa20dfc3e3e63.1320369398.git.david.decotigny@google.com>
 <1320378386.3079.56.camel@deadeye>
From: David Decotigny <david.decotigny@google.com>
Date: Sat, 5 Nov 2011 15:16:44 -0700
Message-ID: <CAG88wWbe3_=kuAJT1xuk-ihSs1oBU4R-gcWnT8TxTYOUh5-hiQ@mail.gmail.com>
Subject: Re: [PATCH net v2 6/8] forcedeth: Fix a race during rmmod of forcedeth
To: Ben Hutchings <bhutchings@solarflare.com>, Salman Qazi <sqazi@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for your feedback, Ben. I looked at this patch more carefully:

On Thu, Nov 3, 2011 at 8:46 PM, Ben Hutchings <bhutchings@solarflare.com> wrote:
> On Thu, 2011-11-03 at 18:41 -0700, David Decotigny wrote:
>> From: Salman Qazi <sqazi@google.com>
>>
>> The race was between del_timer_sync and nv_do_stats_poll called through
>> nv_get_ethtool_stats.
>
> I don't think so.  nv_close() and nv_get_ethtool_stats() are both called
> with RTNL held.
>
> Calling the timer function from nv_get_ethtool_stats is very likely part
> of the problem though, so why don't you stop doing that?

Right. As the initial author noted, the problem is presumably that
mod_timer was called after del_timer_sync, from a non-timer path
(which can only be via nv_get_ethtool_stats in our case). As you
noted, it's enough to ensure this path doesn't exist, which is easy to
do here and doesn't require synchro. I'll send an interim patch for
that to netdev (it should fix the race but will have the same
shortcomings as current code wrt 64b-correctness on 32b hosts).

When switching to the ndo_get_stats64 api, I will make sure
u64_stats_sync.h is used. This is for another patch series scheduled
later for net-next.

>> @@ -5189,13 +5198,13 @@ static int nv_close(struct net_device *dev)
>>
>>         spin_lock_irq(&np->lock);
>>         np->in_shutdown = 1;
>> +       del_timer_sync(&np->stats_poll);
>>         spin_unlock_irq(&np->lock);
>>         nv_napi_disable(dev);
>>         synchronize_irq(np->pci_dev->irq);
>>
>>         del_timer_sync(&np->oom_kick);
>>         del_timer_sync(&np->nic_poll);
>> -       del_timer_sync(&np->stats_poll);
>>
>>         netif_stop_queue(dev);
>>         spin_lock_irq(&np->lock);
>
> I don't believe this code movement is helpful.

I agree.

Regards,
