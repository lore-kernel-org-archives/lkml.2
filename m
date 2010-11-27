Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0K0N2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 08:28:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37183 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0K0N2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 08:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:message-id:user-agent
         :mime-version:content-type;
        b=B0dLHtkyHh4uvVz55UjhOUXPug+PTv744th3pQrS7PNTPkzlyNDgAUh4LARJa4o+88
         18CALmBbW6kvQt/aHFdegG34pO2I5FZW+8nSOk81t+FklQ/4m0Ku3m4zjTrOyYmfpKeH
         ZAp0TgEXBzBkMuZHYWguPGO7uaHoYYXWFp7Bc=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Francis Moreau <francis.moro@gmail.com>
Subject: Re: perf: some questions about perf software events
References: <m3tyj73qev.fsf@gmail.com> <1290598906.2072.461.camel@laptop>
Date: Sat, 27 Nov 2010 14:28:41 +0100
Message-ID: <m3oc9a520m.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> On Wed, 2010-11-24 at 12:35 +0100, Franck Bui-Huu wrote:

[...]

>> That is for no 'contiguous' events, setting a sampling frequency doesn't
>> really make sense since for example you could set a frequency to 1000 HZ
>> for the software ALIGNMENT_FAULT event and never get any samplings or at
>> least getting sampling but with a totally different rate. And the
>> current code doesn't look to handle sample_freq anyway.
>
> All the freq bits are in the generic code, it re-computes the rate on
> the timer-tick as well as on each event occurrence. 
>
> Freq driven sampling should work just fine with swevents.
>

Yes, but how does it behave with ALIGNMENT_FAULTS for example ?

Such event may happen at a very disparate rate or it can even never
happen at all.

>
>> Also I'm currently not seeing any real differences between cpu-clock and
>> task-clock events. They both seem to count the time elapsed when the
>> task is running on a CPU. Am I wrong ?
>
> No, Francis already noticed that, I probably wrecked it when I added the
> multi-pmu stuff, its on my todo list to look at (Francis also handed me
> a little patchlet), but I keep getting distracted with other stuff :/

OK.

Does it make sense to adjust the period for both of them ?

Also, when creating a task clock event, passing 'pid=-1' to
sys_perf_event_open() doesn't really make sense, does it ?

Same with cpu clock and 'pid=n': whatever <n> value, the event measure
the cpu wall time clock.

Perhaps proposing only one clock in the API and internally bind this
clock to the cpu or task clock depending on pid or cpu parameters would
have been better ?

Something like the following:


diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bb1884c..ad50551 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -105,6 +105,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_CLOCK			= 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1dabb54..f3ff342 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4981,7 +4981,14 @@ static int cpu_clock_event_init(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
 
-	if (event->attr.config != PERF_COUNT_SW_CPU_CLOCK)
+	switch (event->attr.config) {
+	case PERF_COUNT_SW_CPU_CLOCK:
+		break;
+	case PERF_COUNT_SW_CLOCK:
+		if (!(event->attach_state & PERF_ATTACH_TASK))
+			break;
+		/* fall-through */
+	default:
 		return -ENOENT;
 
 	return 0;
@@ -5058,8 +5065,16 @@ static int task_clock_event_init(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
 
-	if (event->attr.config != PERF_COUNT_SW_TASK_CLOCK)
+	switch (event->attr.config) {
+	case PERF_COUNT_SW_TASK_CLOCK:
+		break;
+	case PERF_COUNT_SW_CLOCK:
+		if (event->attach_state & PERF_ATTACH_TASK)
+			break;
+		/* fall-through */
+	default:
 		return -ENOENT;
+	}
 
 	return 0;
 }


-- 
		Franck
