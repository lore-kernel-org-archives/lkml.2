Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab0KXLlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:41:31 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53065 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab0KXLla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:41:30 -0500
Subject: Re: perf: some questions about perf software events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Francis Moreau <francis.moro@gmail.com>
In-Reply-To: <m3tyj73qev.fsf@gmail.com>
References: <m3tyj73qev.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 12:41:46 +0100
Message-ID: <1290598906.2072.461.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 12:35 +0100, Franck Bui-Huu wrote:
> Hello Peter,
> 
> I've still a couple of questions after looking at the software events
> code, hope you don't mind.
> 
> For pure software events (ie excluding {task,cpu}-clock), does it make
> sense to set a sample frequency ? I would have done something like this:
> 
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 31515200..df27fd8 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4671,6 +4671,8 @@ static int perf_swevent_init(struct perf_event *event)
>  
>  	if (event->attr.type != PERF_TYPE_SOFTWARE)
>  		return -ENOENT;
> +	if (event->attr.freq)
> +		return -EINVAL;
>  
>  	switch (event_id) {
>  	case PERF_COUNT_SW_CPU_CLOCK:
> 
> 
> 
> That is for no 'contiguous' events, setting a sampling frequency doesn't
> really make sense since for example you could set a frequency to 1000 HZ
> for the software ALIGNMENT_FAULT event and never get any samplings or at
> least getting sampling but with a totally different rate. And the
> current code doesn't look to handle sample_freq anyway.

All the freq bits are in the generic code, it re-computes the rate on
the timer-tick as well as on each event occurrence. 

Freq driven sampling should work just fine with swevents.

> Also I'm currently not seeing any real differences between cpu-clock and
> task-clock events. They both seem to count the time elapsed when the
> task is running on a CPU. Am I wrong ?

No, Francis already noticed that, I probably wrecked it when I added the
multi-pmu stuff, its on my todo list to look at (Francis also handed me
a little patchlet), but I keep getting distracted with other stuff :/
