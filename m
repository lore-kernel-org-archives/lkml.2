Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1JSSo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:44:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48695 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1JSSo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:44:56 -0400
Message-ID: <4E9F1AA0.4010706@gmail.com>
Date: Wed, 19 Oct 2011 12:44:48 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com> <20111019183848.GE2229@ghostprotocols.net>
In-Reply-To: <20111019183848.GE2229@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/19/2011 12:38 PM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 19, 2011 at 12:23:18PM -0600, David Ahern escreveu:
>> Hitting an annotate case where src is not set and
>> perf-top crashes.
> 
> How did you got there? 

One stack trace:
#0  0x0000000000434ba8 in list_add_tail (new=0x7fffec000c30, head=0x0)
    at util/include/../../../../include/linux/list.h:76
#1  0x00000000004351a5 in objdump__add_line (head=0x0,
line=0x7fffec000c30) at util/annotate.c:101
#2  0x000000000043584f in symbol__parse_objdump_line (sym=0xf505f0,
map=0x98de00, file=0x7fffec000aa0,
    privsize=40) at util/annotate.c:256
#3  0x0000000000435d45 in symbol__annotate (sym=0xf505f0, map=0x98de00,
privsize=40) at util/annotate.c:346
#4  0x00000000004829a0 in symbol__tui_annotate (sym=0xf505f0,
map=0x98de00, evidx=0, nr_events=1,
    timer=0x426f9e <perf_top__sort_new_samples>, arg=0x77a300,
delay_secs=2) at util/ui/browsers/annotate.c:405
#5  0x0000000000482867 in hist_entry__tui_annotate (he=0x991ca0,
evidx=0, nr_events=1,
    timer=0x426f9e <perf_top__sort_new_samples>, arg=0x77a300,
delay_secs=2) at util/ui/browsers/annotate.c:373
#6  0x0000000000485684 in perf_evsel__hists_browse (evsel=0x910710,
nr_events=1,
    helpline=0x5201e8 "For a higher level overview, try: perf top --sort
comm,dso", ev_name=0x910990 "cycles",
    left_exits=false, timer=0x426f9e <perf_top__sort_new_samples>,
arg=0x77a300, delay_secs=2)
    at util/ui/browsers/hists.c:991
...


I was starting perf top, selecting a symbol and pressing 'a'. In the
crash case it was the perf command itself.

David


> Navigating thru callq? I  wonder if in this case
> we'd instead shouldn't call
> 
> symbol__alloc_hist(sym, evlist->nr_entries)
> 
> And proceed, only complaining on ENOMEM, like we do in parse_source in
> builtin-top.c.
> 
> I.e. if the user asked to go to a function without hits, no problem,
> allocate the data structures needed for doing the annotation and show 0
> hits on all lines.
> 
> - Arnaldo
>  
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>>  tools/perf/util/annotate.c             |    3 +++
>>  tools/perf/util/ui/browsers/annotate.c |    2 ++
>>  2 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
>> index bc8f477..26652b1 100644
>> --- a/tools/perf/util/annotate.c
>> +++ b/tools/perf/util/annotate.c
>> @@ -205,6 +205,9 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
>>  	size_t line_len;
>>  	s64 line_ip, offset = -1;
>>  
>> +	if (!notes->src)
>> +		return -1;
>> +
>>  	if (getline(&line, &line_len, file) < 0)
>>  		return -1;
>>  
>> diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
>> index a2c351c..5a67ead 100644
>> --- a/tools/perf/util/ui/browsers/annotate.c
>> +++ b/tools/perf/util/ui/browsers/annotate.c
>> @@ -410,6 +410,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
>>  	ui_helpline__push("Press <- or ESC to exit");
>>  
>>  	notes = symbol__annotation(sym);
>> +	if (!notes->src)
>> +		return -1;
>>  
>>  	list_for_each_entry(pos, &notes->src->source, node) {
>>  		struct objdump_line_rb_node *rbpos;
>> -- 
>> 1.7.6.4
