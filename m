Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1AUSGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:06:24 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab1AUSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=eTVBWjPkoLJUDU8LzxNxrgK/e+t+zYG0rQ4K5/YX4hdGqQ3NODT5uYbNvCuWcJRTZF
         5Q1ng+KVOZsmT6wep5MQ==
MIME-Version: 1.0
Date: Fri, 21 Jan 2011 19:06:18 +0100
Message-ID: <AANLkTikX=tQwYKj9VZhCNudErf4TP-74+Jv3WPvSdUMn@mail.gmail.com>
Subject: perf_events: question about __perf_event_read()
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think the code below still has a problem in case of a per-cpu event.

If you issue a read() on a different CPU, then you IPI to the event's cpu.
By the time you get there, the event may be de-scheduled in which
case you don't want to issue event->pmu_read() nor update context
timings. The function has a test but it seems to be checking the per-cpu
case only.

I have seen panics on P4 with this code because it goes all the way
down to rdmsrl() with a bogus counter index (like -1).

Am I missing something here?

static void __perf_event_read(void *info)
{
        struct perf_event *event = info;
        struct perf_event_context *ctx = event->ctx;
        struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);

        /*
         * If this is a task context, we need to check whether it is
         * the current task context of this cpu.  If not it has been
         * scheduled out before the smp call arrived.  In that case
         * event->count would have been updated to a recent sample
         * when the event was scheduled out.
         */
        if (ctx->task && cpuctx->task_ctx != ctx)
                return;

        raw_spin_lock(&ctx->lock);
        update_context_time(ctx);
        update_event_times(event);
        raw_spin_unlock(&ctx->lock);

        event->pmu->read(event);
}
