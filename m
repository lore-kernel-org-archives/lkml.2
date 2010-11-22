Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0KVNlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:41:04 -0500
Received: from 206.83.70.70.ptr.us.xo.net ([206.83.70.70]:58259 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab0KVNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:41:03 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 08:41:02 EST
Message-ID: <4CEA71AD.5010606@tilera.com>
Date: Mon, 22 Nov 2010 08:35:41 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Cypher Wu <cypher.w@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: fix rwlock so would-be write lockers don't
 block new readers
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>	<1289489007.17691.1310.camel@edumazet-laptop>	<AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>	<ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>	<4CDF1945.8090101@tilera.com>	<AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>	<201011151425.oAFEPU3W005682@farm-0010.internal.tilera.com> <AANLkTikGj+zG9OqVJseKh4fGqQNnqnJpHgcaaXOL8nNi@mail.gmail.com>
In-Reply-To: <AANLkTikGj+zG9OqVJseKh4fGqQNnqnJpHgcaaXOL8nNi@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2010 12:39 AM, Cypher Wu wrote:
> 2010/11/15 Chris Metcalf <cmetcalf@tilera.com>:
>> This avoids a deadlock in the IGMP code where one core gets a read
>> lock, another core starts trying to get a write lock (thus blocking
>> new readers), and then the first core tries to recursively re-acquire
>> the read lock.
>>
>> We still try to preserve some degree of balance by giving priority
>> to additional write lockers that come along while the lock is held
>> for write, so they can all complete quickly and return the lock to
>> the readers.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>> This should apply relatively cleanly to 2.6.26.7 source code too.
>> [...]
>
> I've finished my business trip and tested that patch for more than an
> hour and it works. The test is still running now.
>
> But it seems there still has a potential problem: we used ticket lock
> for write_lock(), and if there are so many write_lock() occurred, is
> 256 ticket enough for 64 or even more cores to avoiding overflow?
> Since is we try to write_unlock() and there's already write_lock()
> waiting we'll only adding current ticket.

This is OK, since each core can issue at most one (blocking) write_lock(),
and we have only 64 cores.  Future >256 core machines will be based on
TILE-Gx anyway, which doesn't have the 256-core limit since it doesn't use
the spinlock_32.c implementation.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

