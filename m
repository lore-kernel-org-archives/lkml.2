Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab2LVAs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 19:48:57 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48693 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2LVAsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 19:48:55 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20121221185613.1f4c9523@annuminas.surriel.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Dec 2012 16:48:52 -0800
Message-ID: <1356137332.21834.8155.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 18:56 -0500, Rik van Riel wrote:
> Argh, the first one had a typo in it that did not influence
> performance with fewer threads running, but that made things
> worse with more than a dozen threads...
> 
> Please let me know if you can break these patches.
> ---8<---
> Subject: x86,smp: auto tune spinlock backoff delay factor

> +#define MIN_SPINLOCK_DELAY 1
> +#define MAX_SPINLOCK_DELAY 1000
> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };

Using a single spinlock_delay per cpu assumes there is a single
contended spinlock on the machine, or that contended
spinlocks protect the same critical section.

Given that we probably know where the contended spinlocks are, couldnt
we use a real scalable implementation for them ?

A known contended one is the Qdisc lock in network layer. We added a
second lock (busylock) to lower a bit the pressure on a separate cache
line, but a scalable lock would be much better...

I guess there are patent issues...


