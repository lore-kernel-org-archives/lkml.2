Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1BQXSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:18:33 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:48901 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1BQXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:18:31 -0500
Message-ID: <4D5DACC5.60105@tilera.com>
Date: Thu, 17 Feb 2011 18:18:29 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <xiyou.wangcong@gmail.com>, <cypher.w@gmail.com>,
        <linux-kernel@vger.kernel.org>, <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: IGMP and rwlock: Dead ocurred again on TILEPro
References: <4D5DA60A.8080201@tilera.com>	<20110217.145333.232751283.davem@davemloft.net>	<4D5DA96D.5060200@tilera.com> <20110217.151147.35033921.davem@davemloft.net>
In-Reply-To: <20110217.151147.35033921.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/2011 6:11 PM, David Miller wrote:
> From: Chris Metcalf <cmetcalf@tilera.com>
> Date: Thu, 17 Feb 2011 18:04:13 -0500
>
>> On 2/17/2011 5:53 PM, David Miller wrote:
>>> From: Chris Metcalf <cmetcalf@tilera.com>
>>> Date: Thu, 17 Feb 2011 17:49:46 -0500
>>>
>>>> The fix is to disable interrupts for the arch_read_lock family of methods. 
>>> How does that help handle the race when it happens between different
>>> cpus, instead of between IRQ and non-IRQ context on the same CPU?
>> There's no race in that case, since the lock code properly backs off and
>> retries until the other cpu frees it.  The distinction here is that the
>> non-IRQ context is "wedged" by the IRQ context.
>>
>>> Why don't you just use the generic spinlock based rwlock code on Tile,
>>> since that is all that your atomic instructions can handle
>>> sufficiently?
>> The tile-specific code encodes reader/writer information in the same 32-bit
>> word that the test-and-set instruction manipulates, so it's more efficient
>> both in space and time.  This may not really matter for rwlocks, since no
>> one cares much about them any more, but that was the motivation.
> Ok, but IRQ disabling is going to be very expensive.

The interrupt architecture on Tile allows a write to a special-purpose
register to put you into a "critical section" where no interrupts or faults
are delivered.  So we just need to bracket the read_lock operations with
two SPR writes; each takes six machine cycles, so we're only adding 12
cycles to the total cost of taking or releasing a read lock on an rwlock.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

