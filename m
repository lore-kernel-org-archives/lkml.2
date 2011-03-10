Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1CJAVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:21:24 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:18155 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1CJAVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:21:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALOod02rR7Ht/2dsb2JhbACmcnSnE5w6hWUEhSKHGINI
X-IronPort-AV: E=Sophos;i="4.62,293,1297036800"; 
   d="scan'208";a="413228408"
Message-ID: <4D7819A7.2000409@cisco.com>
Date: Wed, 09 Mar 2011 17:21:59 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 09/10] perf script: Add support for dumping symbols
References: <1299695491-15786-1-git-send-email-acme@infradead.org> <1299695491-15786-10-git-send-email-acme@infradead.org> <20110309233039.GA2533@nowhere>
In-Reply-To: <20110309233039.GA2533@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/09/11 16:30, Frederic Weisbecker wrote:
> On Wed, Mar 09, 2011 at 03:31:30PM -0300, Arnaldo Carvalho de Melo wrote:
>> @@ -868,6 +892,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
>>  		exit(-1);
>>  	}
>>  
>> +	symbol_conf.use_callchain = no_callchain ? false : true;
>> +
> 
> That also depend on (sample_type & PERF_SAMPLE_CALLCHAIN)...
> 
>>  	if (rec_script_path)
>>  		script_path = rec_script_path;
>>  	if (rep_script_path)
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index f642615..51fac44 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -1145,3 +1145,64 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
>>  
>>  	return ret;
>>  }
>> +
>> +void perf_session__print_symbols(union perf_event *event,
>> +				struct perf_sample *sample,
>> +				struct perf_session *session)
>> +{
>> +	struct addr_location al;
>> +	const char *symname, *dsoname;
>> +	struct callchain_cursor *cursor = &session->callchain_cursor;
>> +	struct callchain_cursor_node *node;
>> +
>> +	if (perf_event__preprocess_sample(event, session, &al, sample,
>> +					  NULL) < 0) {
>> +		error("problem processing %d event, skipping it.\n",
>> +			event->header.type);
>> +		return;
>> +	}
>> +
>> +	if (symbol_conf.use_callchain && sample->callchain) {
> 
> ...otherwise you may deref some crap there. sample->callchain is
> random when there is actually no callchain.

Doh. I'll add a check to perf_session__check_attr for
PERF_SAMPLE_CALLCHAIN and reset use_callchain if necessary.

David
