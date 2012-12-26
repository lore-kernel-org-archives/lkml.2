Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2LZTvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 14:51:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab2LZTva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 14:51:30 -0500
Message-ID: <50DB5531.90500@redhat.com>
Date: Wed, 26 Dec 2012 14:51:13 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
References: <20121221184940.103c31ad@annuminas.surriel.com>  <20121221185147.4ae48ab5@annuminas.surriel.com>  <20121221185613.1f4c9523@annuminas.surriel.com>  <20121222033339.GF27621@home.goodmis.org>  <50D52E0C.6000103@redhat.com> <1356549008.20133.20856.camel@edumazet-glaptop>
In-Reply-To: <1356549008.20133.20856.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 02:10 PM, Eric Dumazet wrote:

> I did some tests with your patches with following configuration :
>
> tc qdisc add dev eth0 root htb r2q 1000 default 3
> (to force a contention on qdisc lock, even with a multi queue net
> device)
>
> and 24 concurrent "netperf -t UDP_STREAM -H other_machine -- -m 128"
>
> Machine : 2 Intel(R) Xeon(R) CPU X5660  @ 2.80GHz
> (24 threads), and a fast NIC (10Gbps)
>
> Resulting in a 13 % regression (676 Mbits -> 595 Mbits)
>
> In this workload we have at least two contended spinlocks, with
> different delays. (spinlocks are not held for the same duration)
>
> It clearly defeats your assumption of a single per cpu delay being OK :
> Some cpus are spinning too long while the lock was released.

Thank you for breaking my patches.

I had been thinking about ways to deal with multiple
spinlocks, and hoping there would not be a serious
issue with systems contending on multiple locks.

> We might try to use a hash on lock address, and an array of 16 different
> delays so that different spinlocks have a chance of not sharing the same
> delay.
>
> With following patch, I get 982 Mbits/s with same bench, so an increase
> of 45 % instead of a 13 % regression.

Thank you even more for fixing my patches :)

That is a huge win!

Could I have your Signed-off-by: line, so I can merge
your hashed spinlock slots in?

I will probably keep it as a separate patch 4/4, with
your report and performance numbers in it, to preserve
the reason why we keep multiple hashed values, etc...

There is enough stuff in this code that will be
indishinguishable from magic if we do not document it
properly...

-- 
All rights reversed
