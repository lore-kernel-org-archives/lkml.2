Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3ADHqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:46:43 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62946 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3ADHqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:46:40 -0500
Subject: Re: [PATCH net-next] softirq: reduce latencies
From: Eric Dumazet <erdnetdev@gmail.com>
To: "Oleg A.Arkhangelsky" <sysoleg@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <787701357283699@web24e.yandex.ru>
References: <1357216132.21409.24107.camel@edumazet-glaptop>
	 <20130103124608.136fd65b.akpm@linux-foundation.org>
	 <1357252875.21409.26390.camel@edumazet-glaptop>
	 <787701357283699@web24e.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jan 2013 23:46:37 -0800
Message-ID: <1357285597.21409.28406.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-04 at 11:14 +0400, Oleg A.Arkhangelsky wrote:

> It leads to many context switches when softirqs processing deffered to
> ksoftirqd kthreads which can be very expensive. Here is some evidence
> of ksoftirqd activation effects:
> 
> http://marc.info/?l=linux-netdev&m=124116262916969&w=2
> 
> Look for "magic threshold". Yes, I know there was another bug in scheduler
> discovered that time, but this bug was only about tick accounting.
> 

This thread is 3 years old : 

- It was a router workload. Forwarded packets should not wakeup a task.
- The measure of how cpus spent their cycles was completely wrong.
- A lot of things have changed, both in network stack and scheduler.

In fact, under moderate load, my patch is able to loop more than 10
times before deferring to ksoftirqd.

Under stress, ksoftirqd will be started anyway, and its a good thing,
because it enables process migration.

500 "context switches" [1] per second instead of 50 on behalf of
ksoftirqd is absolutely not measurable. It also permits smoother RCU
cleanups.

I did a lot of benchmarks, and didnt see any regression yet, but usual
noise.

[1] Under load, __do_softirq() would be called 500 times per second,
instead of ~50 times per second.



