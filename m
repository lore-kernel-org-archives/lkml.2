Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2ENWKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:10:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47274 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2ENWKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:10:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120514150544.6b17d3c5@nehalam.linuxnetplumber.net>
References: <1337032626-7104-1-git-send-email-levinsasha928@gmail.com> <20120514150544.6b17d3c5@nehalam.linuxnetplumber.net>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 15 May 2012 00:09:49 +0200
Message-ID: <CA+1xoqe6=nu0nvGVa_Hei+XVfRE0QaAtTa+n=ZQc22mj3Xm8Rg@mail.gmail.com>
Subject: Re: [PATCH v2] net: codel: fix build errors
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: edumazet@google.com, dave.taht@bufferbloat.net, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 12:05 AM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Mon, 14 May 2012 23:57:06 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
>
>> Fix the following build error:
>>
>> net/sched/sch_fq_codel.c: In function 'fq_codel_dump_stats':
>> net/sched/sch_fq_codel.c:464:3: error: unknown field 'qdisc_stats' specified in initializer
>> net/sched/sch_fq_codel.c:464:3: warning: missing braces around initializer
>> net/sched/sch_fq_codel.c:464:3: warning: (near initialization for 'st.<anonymous>')
>> net/sched/sch_fq_codel.c:465:3: error: unknown field 'qdisc_stats' specified in initializer
>> net/sched/sch_fq_codel.c:465:3: warning: excess elements in struct initializer
>> net/sched/sch_fq_codel.c:465:3: warning: (near initialization for 'st')
>> net/sched/sch_fq_codel.c:466:3: error: unknown field 'qdisc_stats' specified in initializer
>> net/sched/sch_fq_codel.c:466:3: warning: excess elements in struct initializer
>> net/sched/sch_fq_codel.c:466:3: warning: (near initialization for 'st')
>> net/sched/sch_fq_codel.c:467:3: error: unknown field 'qdisc_stats' specified in initializer
>> net/sched/sch_fq_codel.c:467:3: warning: excess elements in struct initializer
>> net/sched/sch_fq_codel.c:467:3: warning: (near initialization for 'st')
>> make[1]: *** [net/sched/sch_fq_codel.o] Error 1
>>
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>> ---
>>  net/sched/sch_fq_codel.c |    9 +++++----
>>  1 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
>> index a7b3754..337ff20 100644
>> --- a/net/sched/sch_fq_codel.c
>> +++ b/net/sched/sch_fq_codel.c
>> @@ -461,13 +461,14 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
>>       struct fq_codel_sched_data *q = qdisc_priv(sch);
>>       struct tc_fq_codel_xstats st = {
>>               .type                           = TCA_FQ_CODEL_XSTATS_QDISC,
>> -             .qdisc_stats.maxpacket          = q->cstats.maxpacket,
>> -             .qdisc_stats.drop_overlimit     = q->drop_overlimit,
>> -             .qdisc_stats.ecn_mark           = q->cstats.ecn_mark,
>> -             .qdisc_stats.new_flow_count     = q->new_flow_count,
>>       };
>>       struct list_head *pos;
>>
>> +     st.qdisc_stats.maxpacket = q->cstats.maxpacket;
>> +     st.qdisc_stats.drop_overlimit = q->drop_overlimit;
>> +     st.qdisc_stats.ecn_mark = q->cstats.ecn_mark;
>> +     st.qdisc_stats.new_flow_count = q->new_flow_count;
>> +
>>       list_for_each(pos, &q->new_flows)
>>               st.qdisc_stats.new_flows_len++;
>>
>
> Cleaner and simpler to just use nested initialization.
>        struct tc_fq_codel_xstats st = {
>                .type                           = TCA_FQ_CODEL_XSTATS_QDISC,
>                .qdisc_stats = {
>                        .maxpacket      = q->cstats.maxpacket,
>                        .drop_overlimit = q->drop_overlimit,
>                        .ecn_mark       = q->cstats.ecn_mark,
>                        .new_flow_count = q->new_flow_count,
>                },
>        };

You'll get the same errors. You can't directly initialize members that
are in an anonymous union.
