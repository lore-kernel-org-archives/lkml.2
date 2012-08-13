Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2HMPw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:52:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:53547 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2HMPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:52:55 -0400
Date: Mon, 13 Aug 2012 17:52:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <maze@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, hank <pyu@redhat.com>
Subject: Re: [PATCH net-next] time: jiffies_delta_to_clock_t() helper to the
 rescue
In-Reply-To: <1344496433.28967.443.camel@edumazet-glaptop>
Message-ID: <alpine.LFD.2.02.1208131749230.32033@ionos>
References: <1344496433.28967.443.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Eric Dumazet wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> Various /proc/net files sometimes report crazy timer values, expressed
> in clock_t units.
> 
> This happens when an expired timer delta (expires - jiffies) is passed
> to jiffies_to_clock_t().
>
> This function has an overflow in :
> 
> return div_u64((u64)x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);
> 
> commit cbbc719fccdb8cb (time: Change jiffies_to_clock_t() argument type
> to unsigned long) only got around the problem.
> 
> As we cant output negative values in /proc/net/tcp without breaking
> various tools, I suggest adding a jiffies_delta_to_clock_t() wrapper
> that caps the negative delta to a 0 value.

That's correct for 64bit, but for 32bit you do the same for valid
timer values where expires < jiffies. So you might output 0 for valid
armed timers for quite a while around the point where jiffies are
close to the wrapping point.

Dunno if that's an issue, but it want's to be documented at least.

Thanks,

	tglx
