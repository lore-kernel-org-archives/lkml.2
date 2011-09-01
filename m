Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1IALxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:53:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IALxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:53:39 -0400
Subject: Re: Problem with perf hardware counters grouping
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Hommey <mh@glandium.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 13:53:32 +0200
In-Reply-To: <20110831085718.GB13884@glandium.org>
References: <20110831085718.GB13884@glandium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314878012.11566.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 10:57 +0200, Mike Hommey wrote:
> I'm having two different problems with perf hardware counters with a
> group leader:
> - perf_event_open()ing more than 3 makes all of them always return a
>   value of 0;
> - perf_event_open()ing more than 4 fails with ENOSPC. 


I'm guessing you're running on something x86, either AMD-Fam10-12 or
Intel-NHM+.

Both those have 4 generic hardware counters, but x86 defaults to
enabling the NMI watchdog which takes one, leaving you with 3 (try: echo
0 > /proc/sys/kernel/nmi_watchdog). If you had looked at your dmesg
output you'd have found lines like:

  NMI watchdog enabled, takes one hw-pmu counter.

The code can only check if the group as a whole could possibly fit on a
PMU, which is where your failure on >4 comes from.

What happens with your >3 case is that while the group is valid and
could fit on the PMU, it won't fit at runtime because the NMI watchdog
is taking one and won't budge (cpu-pinned counter have precedence over
any other kind), effectively starving your group of pmu runtime.

Also, we should fix that return to say -EINVAL or so.
