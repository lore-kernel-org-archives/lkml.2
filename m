Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab1KWDjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:39:21 -0500
Received: from dns1.mips.com ([12.201.5.69]:43415 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab1KWDjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:39:20 -0500
Message-ID: <4ECC6AAC.4010504@mips.com>
Date: Wed, 23 Nov 2011 11:38:20 +0800
From: Deng-Cheng Zhu <dczhu@mips.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] perf: Enable applicable siblings when group leader
 is enable-on-exec
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>	 ,<1321959115.5148.22.camel@twins>	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA82C@exchdb03.mips.com>	,<1321969559.14799.7.camel@twins>	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA871@exchdb03.mips.com> <1321971798.14799.12.camel@twins>
In-Reply-To: <1321971798.14799.12.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: hG4xBjO096kZgH5A3Anudw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 10:23 PM, Peter Zijlstra wrote:
> On Tue, 2011-11-22 at 14:20 +0000, Zhu, DengCheng wrote:
>>> @@ -2463,11 +2461,25 @@ static int event_enable_on_exec(struct p
>>>         if (event->state>= PERF_EVENT_STATE_INACTIVE)
>>>                 return 0;
>>>
>>> -       __perf_event_mark_enabled(event, ctx);
>>> +       event->state = PERF_EVENT_STATE_INACTIVE;
>>>
>>>         return 1;
>>>   }
>>
>> By simply setting the event state in here, we bypass time stamp stuff as a result.
>> This might lead to inaccuracies...
>
> Ah, but it calls a __perf_event_mark_enabled() at the tail of
> group_enable_on_exec() which should fix that up, right?

Oh, yes. Aside from a slight piece that the __perf_event_mark_enabled()
in group_enable_on_exec() will reassign PERF_EVENT_STATE_INACTIVE to the
group leader, your patch looks good.

In fact, my another candidate for this patch is as follows (The
comment of perf_event_enable_on_exec() says "Enable all of a task's
events that have been marked enable-on-exec", so I think the added
traversal makes sense in here):

From: Deng-Cheng Zhu <dczhu@mips.com>
Date: Wed, 23 Nov 2011 11:31:18 +0800
Subject: [PATCH] perf: Enable enable-on-exec siblings

Currently, when grouped events are created disabled and enable-on-exec,
the siblings won't be enabled on exec in fact. The problem looks like:

======================================================================
-sh-4.0# perf stat -g -e r14,cycles,instructions,r12 find / >/dev/null
^Cfind: Interrupt

  Performance counter stats for 'find /':

           60684699 r14
      <not counted> cycles
      <not counted> instructions
      <not counted> r12

        4.291975113 seconds time elapsed
======================================================================

This patch fixes it.

Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
---
  kernel/events/core.c |    6 ++++++
  1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0e8457d..63527d0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2476,6 +2476,12 @@ static void perf_event_enable_on_exec(struct 
perf_event_context *ctx)
  	raw_spin_lock(&ctx->lock);
  	task_ctx_sched_out(ctx);

+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+		ret = event_enable_on_exec(event, ctx);
+		if (ret)
+			enabled = 1;
+	}
+
  	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
  		ret = event_enable_on_exec(event, ctx);
  		if (ret)
