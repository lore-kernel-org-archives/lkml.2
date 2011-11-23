Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1KWLkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:40:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54195 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1KWLkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:40:04 -0500
Message-ID: <1322048382.14799.41.camel@twins>
Subject: Re: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 12:39:42 +0100
In-Reply-To: <4ECC6AAC.4010504@mips.com>
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>
		 ,<1321959115.5148.22.camel@twins>
		 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA82C@exchdb03.mips.com>
		,<1321969559.14799.7.camel@twins>
		 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA871@exchdb03.mips.com>
	 <1321971798.14799.12.camel@twins> <4ECC6AAC.4010504@mips.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 11:38 +0800, Deng-Cheng Zhu wrote:

> +	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
> +		ret = event_enable_on_exec(event, ctx);
> +		if (ret)
> +			enabled = 1;
> +	}
> +
>   	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
>   		ret = event_enable_on_exec(event, ctx);
>   		if (ret)

This isn't correct either, in this case you should then remove the other
two iterations of pinned/flexible group lists.

Also your use of list_for_each_entry_rcu() is incorrect, either you then
should also use rcu_read_lock(), or its not needed and not use the _rcu
list primitive at all.

Now since event_list is modified under ctx->lock, and we hold that lock
no fancy stuff is needed and we can do without.

---
Subject: perf: Fix enable_on_exec for sibling events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Nov 22 11:25:43 CET 2011

Deng-Cheng Zhu reported that sibling events that were created disabled
with enable_on_exec would never get enabled. Iterate all events instead
of the group lists.

Reported-by: Deng-Cheng Zhu <dczhu@mips.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-299rxrpmmle8hp3spyxfo202@git.kernel.org
---
 kernel/events/core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -2494,13 +2494,7 @@ static void perf_event_enable_on_exec(st
 	raw_spin_lock(&ctx->lock);
 	task_ctx_sched_out(ctx);
 
-	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
-		ret = event_enable_on_exec(event, ctx);
-		if (ret)
-			enabled = 1;
-	}
-
-	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
+	list_for_each_entry(event, &ctx->event_list, group_entry) {
 		ret = event_enable_on_exec(event, ctx);
 		if (ret)
 			enabled = 1;

