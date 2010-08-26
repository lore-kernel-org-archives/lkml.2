Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0HZJBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:01:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:53748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0HZJBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:01:12 -0400
Message-ID: <4C762BF9.5010305@kernel.org>
Date: Thu, 26 Aug 2010 10:55:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
References: <20100825132815.108d8217@bike.lwn.net> <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
In-Reply-To: <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 09:00:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/25/2010 10:00 PM, Linus Torvalds wrote:
>> lg_lock_global() currently only acquires spinlocks for online CPUs, but
>> it's meant to lock all possible CPUs.  At Nick's suggestion, change
>> for_each_online_cpu() to for_each_possible_cpu() to get the expected
>> behavior.
> 
> Can you say what this actually matters for? Don't we do stop-machine
> for CPU hotplug anyway? And if we don't, shouldn't we? Exactly because
> otherwise "for_each_online_cpu()" is always racy (and that has nothing
> to do with the lglock).

We only do stop-machine for cpu downs not ups, so code running w/
preemption disabled is guaranteed that no cpu goes down while it's
running but not the other way around.  There are two ways to achieve
synchronization against cpu up/down operations.  One is explicitly
using get/put_online_cpus() and the other is via cpu notifiers with
proper synchronization.

So, yeah, given that there's no cpu notifier implemented, the use of
for_each_online_cpu for brlock seems fishy to me.  It probably should
use for_each_possible_cpu().

Thanks.

-- 
tejun
