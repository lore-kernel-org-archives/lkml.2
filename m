Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0HPTfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:35:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45682
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771Ab0HPTfu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:35:50 -0400
Date: Mon, 16 Aug 2010 12:36:07 -0700 (PDT)
Message-Id: <20100816.123607.57459160.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1281883637.2942.42.camel@edumazet-laptop>
References: <20100814.220945.232761341.davem@davemloft.net>
	<1281869722.2942.20.camel@edumazet-laptop>
	<1281883637.2942.42.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 15 Aug 2010 16:47:17 +0200

> Le dimanche 15 août 2010 à 12:55 +0200, Eric Dumazet a écrit :
> 
>> We have one lock per cpu, and only one cpu can possibly lock its
>> associated lock under softirq. So the usual lockdep check, warning a
>> lock is taken with BH enabled, while same lock was taken inside softirq
>> handler is triggering a false positive here.
>> 
>> I believe no existing lockdep annotation can instruct lockdep this use
>> is OK, I guess we have following choice :
>> 
>> 1) Mask BH again, using xt_info_wrlock_lockdep(cpu) instead of
>> xt_info_wrlock(cpu).
>> 
>> xt_info_wrlock_lockdep() being a variant, that disables BH in case
>> CONFIG_PROVE_LOCKING=y
>> 
>> 2) temporally switch off lockdep in get_counters(), using a
>> lockdep_off()/lockdep_on() pair, and a comment why this is necessary.
>> 
> 
> In any case, here is patch implementing the later

I'm hesistent to say that we should put this kind of patch in.

It will shut up lockdep for this specific case, but it also means
that if we do any other kinds of locking in this sequence we will
not validate it.

The valuable of this is open for debate I guess.

But locking is hard so I would say that disabling lockdep to kill a
warning it generates should be an absolute last resort.

I also don't think making the locking mechanics conditional upon
LOCKDEP is sane either, exactly because it means lockdep is testing
something other than what actually gets used in practice. :-)
