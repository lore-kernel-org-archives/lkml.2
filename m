Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1AZV5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:57:09 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41411 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab1AZV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:57:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XoM0j9JwBSsJwwThi0hF/SQHOrpWUCtN2H8p/yhW8cCkJMWWcyBqXhZNjddPlxsNkU
         udSVbDDjMNALevXSrmpdmdTxI2eFRdlHpeNtupfaCzm2atu3VpTkxg1y6wTwjzAYI+sR
         9hqYfC/KqmKf8BtrgYOR3o/6aZ77/qsXCMiUY=
Message-ID: <4D4098AC.4090102@gmail.com>
Date: Wed, 26 Jan 2011 22:57:00 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: lkml <linux-kernel@vger.kernel.org>, Han Pingtian <phan@redhat.com>
Subject: Re: [PATCH 1/2] perf-tools: Fix tracepoint event type recording
References: <m34o97wg94.fsf@gmail.com> <20110117195034.GF2085@ghostprotocols.net>
In-Reply-To: <20110117195034.GF2085@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for my (very) late answer...

On 01/17/2011 08:50 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 17, 2011 at 07:13:11PM +0100, Franck Bui-Huu escreveu:
[...]

> 
> Please try not to do multiple, unrelated changes in a single patch, see
> below:

Well, they're not unrelated because of the place I choose to put
perf_header__push_event().

But I agree with you, placing it after parse_events() is much better.

>>
>> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
>> index 989fa2d..35b707c 100644
>> --- a/tools/perf/util/header.c
>> +++ b/tools/perf/util/header.c
>> @@ -104,10 +104,12 @@ int perf_header__add_attr(struct perf_header *self,
>>  static int event_count;
>>  static struct perf_trace_event_type *events;
>>  
>> -int perf_header__push_event(u64 id, const char *name)
>> +int perf_header__push_event(u64 id, const char *name, size_t len)
>>  {
>> -	if (strlen(name) > MAX_EVENT_NAME)
>> +	if (len > MAX_EVENT_NAME - 1) {
>>  		pr_warning("Event %s will be truncated\n", name);
>> +		len = MAX_EVENT_NAME - 1;
>> +	}
>>  
>>  	if (!events) {
>>  		events = malloc(sizeof(struct perf_trace_event_type));
>> @@ -123,7 +125,8 @@ int perf_header__push_event(u64 id, const char *name)
>>  	}
>>  	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
>>  	events[event_count].event_id = id;
>> -	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
>> +	strncpy(events[event_count].name, name, len);
>> +	events[event_count].name[len] = '\0';
> 
> Is this change related to what you describe in the changelog comment? It
> is a cleanup, can be done as a follow up patch, for perf/core.

It's not really unrelated if you place perf_header__push_event() where I
did.

BTW it's not a cleanup too, it's rather a fix since the original code is
broken if the name is truncated since the null byte is missing in this case.
[...]

> Since you're changing the point where perf_header__push_event() is
> called, consider doing it _after_ parse_events() finishes, by traversing
> the evsel_list, that way, as a bonus, later, in perf/core we can kill
> some more global variables:
> 
> static int event_count;
> static struct perf_trace_event_type *events;
> 
> These variables should be in 'struct perf_header', but anyway, this is
> for later, I'm digressing, please just try to do it after
> parse_events(), traversing the evsel_list and getting the tracepoint
> name in string form using event_name(evsel) (that also uses an static
> variagle, argh, another fix to do).
> 
> Doing it that way and excluding the strnlen cleanup, the patch should be
> much smaller.
> 
> We also untie event parsing from header handling, that are only together
> in record, not in, say, top.

Agreed.

		Franck
