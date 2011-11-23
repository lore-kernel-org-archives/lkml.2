Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1KWMlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:41:45 -0500
Received: from dns1.mips.com ([12.201.5.69]:47578 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab1KWMln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:41:43 -0500
From: "Zhu, DengCheng" <dczhu@mips.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
Thread-Topic: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
Thread-Index: AQHMqMcPcUwfPrOJr0SdF29sueMmtJW5Pg2A//+cb6yAAJQ0gP//fV12gACNEACAAWQ9AIAAAGIA//+IhZw=
Date: Wed, 23 Nov 2011 12:40:47 +0000
Message-ID: <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA9FF@exchdb03.mips.com>
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>
		 ,<1321959115.5148.22.camel@twins>
		 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA82C@exchdb03.mips.com>
		,<1321969559.14799.7.camel@twins>
		 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA871@exchdb03.mips.com>
	 <1321971798.14799.12.camel@twins>
 <4ECC6AAC.4010504@mips.com>,<1322048382.14799.41.camel@twins>
In-Reply-To: <1322048382.14799.41.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.36.79]
x-ems-proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
x-ems-stamp: p6sDGCWvfZHIeHHZ1PSKvg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pANCftQc007911



åœ¨ 2011å¹´11æœˆ23æ—¥æ˜ŸæœŸä¸‰ï¼ŒPeter Zijlstra <a.p.zijlstra@chello.nl> å†™é“ï¼š
> On Wed, 2011-11-23 at 11:38 +0800, Deng-Cheng Zhu wrote:
>
>> + Â  Â  list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
>> + Â  Â  Â  Â  Â  Â  ret = event_enable_on_exec(event, ctx);
>> + Â  Â  Â  Â  Â  Â  if (ret)
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  enabled = 1;
>> + Â  Â  }
>> +
>> Â  Â  Â  list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
>> Â  Â  Â  Â  Â  Â  Â  ret = event_enable_on_exec(event, ctx);
>> Â  Â  Â  Â  Â  Â  Â  if (ret)
>
> This isn't correct either, in this case you should then remove the other
> two iterations of pinned/flexible group lists.
>
> Also your use of list_for_each_entry_rcu() is incorrect, either you then
> should also use rcu_read_lock(), or its not needed and not use the _rcu
> list primitive at all.
>
> Now since event_list is modified under ctx->lock, and we hold that lock
> no fancy stuff is needed and we can do without.

Ah, yes you are right. Thanks. Your following patch looks good except
that event_entry should be used for ctx event_list, rather than group_entry.
Tomorrow I'll test it and get back to you.


Deng-Cheng

> ---
> Subject: perf: Fix enable_on_exec for sibling events
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Nov 22 11:25:43 CET 2011
>
> Deng-Cheng Zhu reported that sibling events that were created disabled
> with enable_on_exec would never get enabled. Iterate all events instead
> of the group lists.
>
> Reported-by: Deng-Cheng Zhu <dczhu@mips.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-299rxrpmmle8hp3spyxfo202@git.kernel.org
> ---
> Â kernel/events/core.c | Â  Â 8 +-------
> Â 1 file changed, 1 insertion(+), 7 deletions(-)
>
> Index: linux-2.6/kernel/events/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/events/core.c
> +++ linux-2.6/kernel/events/core.c
> @@ -2494,13 +2494,7 @@ static void perf_event_enable_on_exec(st
> Â  Â  Â  Â raw_spin_lock(&ctx->lock);
> Â  Â  Â  Â task_ctx_sched_out(ctx);
>
> - Â  Â  Â  list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
> - Â  Â  Â  Â  Â  Â  Â  ret = event_enable_on_exec(event, ctx);
> - Â  Â  Â  Â  Â  Â  Â  if (ret)
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  enabled = 1;
> - Â  Â  Â  }
> -
> - Â  Â  Â  list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
> + Â  Â  Â  list_for_each_entry(event, &ctx->event_list, group_entry) {
> Â  Â  Â  Â  Â  Â  Â  Â ret = event_enable_on_exec(event, ctx);
> Â  Â  Â  Â  Â  Â  Â  Â if (ret)
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â enabled = 1;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at Â http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at Â http://www.tux.org/lkml/
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
