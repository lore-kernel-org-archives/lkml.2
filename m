Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab1CHI7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:59:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36487 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1CHI7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RgTZkRplf++Kxl0XJ7y9/UE+okqCpw6naPRKWzBGR0RXwz/fv5dRLhV2Xa2StxVv7t
         hRmKszSu0L2g6/GCs5CotQF7bdwQksb1pBmfvlaikoGvsi8v0xwp5u+VObD0/HJZGsfJ
         H0vuHTYE59NTUMuz7fmG6UpZNHGGG6zDcnWp0=
MIME-Version: 1.0
In-Reply-To: <20110307180619.GG1873@nowhere>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
	<20110307180619.GG1873@nowhere>
Date: Tue, 8 Mar 2011 16:59:30 +0800
Message-ID: <AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
From: Sam Liao <phyomh@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 2:06 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Mar 07, 2011 at 09:43:27PM +0800, Sam Liao wrote:
>> Add "-r" option to support inverted butterfly report, in the
>> inverted report, the call graph start from the callee's ancestor,
>> like main->func1->func2 style. users can use such view to catch
>> system's performance bottleneck, find the software's design
>> problem not just some function's poor performance.
>
> Yeah, that can be interesting.
>
>>
>> Current pref implementation is not easy to add such inversion, so this
>> fix just invert the ip and callchain in an ugly style. But I do think
>> this invert
>> view help developer to find performance root cause for complex
>> software.
>> ---
>>  tools/perf/builtin-report.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 43 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
>> index c27e31f..ac2ec0e 100644
>> --- a/tools/perf/builtin-report.c
>> +++ b/tools/perf/builtin-report.c
>> @@ -33,6 +33,7 @@
>>  static char          const *input_name = "perf.data";
>>
>>  static bool          force, use_tui, use_stdio;
>> +static bool          reverse_call;
>>  static bool          hide_unresolved;
>>  static bool          dont_use_callchains;
>>
>> @@ -155,6 +156,41 @@ static int process_sample_event(event_t *event,
>> struct sample_data *sample,
>>  {
>>       struct addr_location al;
>>       struct perf_event_attr *attr;
>> +
>> +     /* reverse call chain data */
>> +     if (reverse_call && symbol_conf.use_callchain && sample->callchain) {
>> +             struct ip_callchain *chain;
>> +             int i, j;
>> +             u64 tmp_ip;
>> +             event_t *reverse_event;
>> +
>> +             chain = malloc(sizeof(u64) * (sample->callchain->nr + 1));
>> +             if (!chain) {
>> +                     pr_debug("malloc failed\n");
>> +                     return -1;
>> +             }
>> +             reverse_event = malloc(sizeof(event_t));
>> +             if (!reverse_event) {
>> +                     pr_debug("malloc failed\n");
>> +                     return -1;
>> +             }
>> +             memcpy(reverse_event, event, sizeof(event_t));
>> +
>> +             chain->nr = sample->callchain->nr;
>> +             j = sample->callchain->nr;
>> +             tmp_ip = event->ip.ip;
>> +             reverse_event->ip.ip = sample->callchain->ips[j-1];
>> +             chain->ips[j-1] = tmp_ip;
>> +             for (i = 0, j = sample->callchain->nr - 2; i < j; i++, j--) {
>> +                     chain->ips[i] = sample->callchain->ips[j];
>> +                     chain->ips[j] = sample->callchain->ips[i];
>> +             }
>> +
>> +             sample->callchain = chain;
>> +             call_chain_reversed = true;
>> +             event = reverse_event;
>> +     }
>
> So, instead of having such temporary copy, could you rather feed the callchain
> into the cursor in reverse from perf_session__resolve_callchain() ?
>
> You can keep the common part inside the loop into a seperate helper
> but have two different kinds of loops.

In perf_session__resolve_callchain, only the callchain itself can be reversed,
which means the root of report will still be the ip of the event with a reversed
call chain sub tree. But what is more impressive to user is to make "main" like
function to be the root of the report, and this means that both the ip
and call chain is
involved to the reversion process.

Since the ip of event is resolved in event__preprocess_sample, so it is kind
hard to do such reversion in a better way.

>
>>
>>       if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
>>               fprintf(stderr, "problem processing %d event, skipping it.\n",
>> @@ -177,6 +213,11 @@ static int process_sample_event(event_t *event,
>> struct sample_data *sample,
>>               return -1;
>>       }
>>
>> +     if (reverse_call && call_chain_reversed) {
>> +             free(sample->callchain);
>> +             free(event);
>> +     }
>> +
>>       return 0;
>>  }
>>
>> @@ -469,6 +510,8 @@ static const struct option options[] = {
>>       OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
>>                    "Display callchains using output_type (graph, flat, fractal,
>> or none) and min percent threshold. "
>>                    "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
>> +     OPT_BOOLEAN('r', "reverse-call", &reverse_call,
>> +                     "reverse call chain report (butterfly view)"),
>
> What about making it an argument to the exisiting -g option, something
> that defines the base of the callchain like "caller" and "callee"
>
> Like "-g graph,0.5,caller".
>
> caller would be what we call here reverse and callee the current and future default.
>
> Does that look sensible?
>
This option looks better.

Thanks,
-Sam
