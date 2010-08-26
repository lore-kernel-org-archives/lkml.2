Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0HZJzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:55:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:47479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab0HZJzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:55:33 -0400
Message-ID: <4C7638B7.9060306@kernel.org>
Date: Thu, 26 Aug 2010 11:49:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
References: <20100825132815.108d8217@bike.lwn.net> <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com> <4C762BF9.5010305@kernel.org> <20100826094613.GA6411@amd>
In-Reply-To: <20100826094613.GA6411@amd>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 09:55:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/26/2010 11:46 AM, Nick Piggin wrote:
> Oh, I thought we quiesce / preempt all online cpus before adding
> another one. That sucks if we don't because then you need a big
> heavy get_online_cpus when a simple preempt_disable would have
> worked.
> 
> Why is that? Don't tell me realtime people want some latency "guarantee"
> while onlining CPUs? :)

Probably similar rationale of not doing stop_machine() on module
unload, I suppose.  Onlining something is usually considered hotter
path than offlining.  Performance penalty caused by the difference
between possible and online cpumask or cpu onlining probably only
matters for very large machines and on those machines stop-machine is
very expensive.  If there's a pressing need, doing stop_machine for
onlining too is definitely an option.

>> So, yeah, given that there's no cpu notifier implemented, the use of
>> for_each_online_cpu for brlock seems fishy to me.  It probably should
>> use for_each_possible_cpu().
> 
> It should if that's the case, yes.

IMHO, in most configurations the difference between possible and
online cpumasks doesn't matter much (they're the same during normal
operation), so just using possible cpumask should be fine.  It's
already a pretty heavy path, right?

Thanks.

-- 
tejun
