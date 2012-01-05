Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2AESPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:15:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab2AESPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:15:45 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Uad61z6EFVoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=YjAkv39DpMX50EvOdBYA:9 a=NLtazRfXxHU_26MMG-0A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325787342.12696.59.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] sched_rt: the task in irq context can be migrated
 during context switching
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chanho Min <chanho0207@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, chanho.min@lge.com
Date: Thu, 05 Jan 2012 13:15:42 -0500
In-Reply-To: <1325786132.3508.1.camel@twins>
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
	 <1325786132.3508.1.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 18:55 +0100, Peter Zijlstra wrote:

> So the problem is quite real, as already said we don't need to worry
> about the future, but we might want to fix this in previous kernels.
> What I'm not entirely sure of is the proposed solution, Steven don't we
> get in trouble by simply bailing out on the push?

It shouldn't break anything. We shouldn't be pushing tasks that are
running on a rq anyway. I don't see any harm here. As this scenario can
only happen if we get an interrupt after letting go of the rq lock and
before doing the switch_to(). The schedule_tail() calls
post_schedule_rt() which does the push again, and will push task A at
that time.

That said, I'm not sure this patch is enough. I'm worried about a pull
happening. As task A is running, we could possible possibly pick it on
another CPU to do a pull.

Hmm, looking at the code, the pull already does a task_running() test,
so I guess we should be fine.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


