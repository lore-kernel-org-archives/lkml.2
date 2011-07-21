Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1GUQng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:43:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41534 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GUQnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:43:35 -0400
Subject: Re: sched: fix/optimise some issues
From: Peter Zijlstra <peterz@infradead.org>
To: Stephan =?ISO-8859-1?Q?B=E4rwolf?= 
	<stephan.baerwolf@tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4E28557A.7040704@tu-ilmenau.de>
References: <4E26DB41.9070002@tu-ilmenau.de>
	 <1311260895.29152.153.camel@twins>  <4E28557A.7040704@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 18:43:28 +0200
Message-ID: <1311266608.29152.170.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(you seem to have lost CC's, restored them)

On Thu, 2011-07-21 at 18:36 +0200, Stephan Bärwolf wrote:
> > How horrid is the current vruntime situation?
> This is a point, which needs further discussion/observation.
> 
> When for example NICE0_LOAD is increased by 6 Bit (and I think
> "c8b281161dfa4bb5d5be63fb036ce19347b88c63" did it by 10bits
> on x86_64) the maximum timeslice (I am not quite sure if it was on
> HZ=1000) with a PRE kernel will be around 2**38.
> Adding this every ms (lets say 1024 times per sec) to min_vruntime
> might cause overflows too fast (after 2**(63-38-10)sec = 2**15sec ~ 9h).

9h should be just fine, and I think we can get down to minutes without
really breaking much. As long as the wrap period is at least twice the
duration of the period needed to service all tasks.

So what we want is the wrap to be > 2*nr_running*sched_min_granularity.

> Long story short: on x86_64 an unsigned long (timeslice) could be
> as large as the whole u64 for min_vruntime and this is dangerous.

> Of course limiting the maximum timeslice in "calc_delta_mine()" would
> help, too - but without the comfort using the whole x86_64 capabilties.
> (and mostly therefore finer priority-resolutions) 

It should be limited by HZ, that is I don't think there is a situation
where we can get a bigger real-time delta than 1s/HZ.
