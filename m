Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab2EQI7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:59:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43104 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369Ab2EQI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:59:06 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-4d-4fb4bdd7c914
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Revert 'perf evlist: Fix creation of cpu map'
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
	<1337161549-9870-2-git-send-email-namhyung.kim@lge.com>
	<20120516152619.GD7864@infradead.org>
Date: Thu, 17 May 2012 17:57:16 +0900
In-Reply-To: <20120516152619.GD7864@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Wed, 16 May 2012 12:26:19 -0300")
Message-ID: <87txzf18yb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 May 2012 12:26:19 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, May 16, 2012 at 06:45:48PM +0900, Namhyung Kim escreveu:
>> The commit 55261f46702c ("perf evlist: Fix creation of cpu
>> map") changed to create a per-task event when no cpu target
>> is specified. However it caused a problem since perf-task do
>> not allow event inheritance due to scalability issues so
>> that the result will contain samples only from parent, not
>> from its children.
>> 
>> So we should use perf-task-per-cpu events anyway to get the
>> right result. Revert it.
>> 
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Analysed-by: Ingo Molnar <mingo@kernel.org>
>> Acked-and-tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> I'm applying it, but while trying to figure out if the logic was right I
> tried:
>
> perf top -C 0 -u acme
>
> To check what is that this user is doing on that CPU, and its not
> possible :-\
>
> UID switch overriding CPU!
>

Maybe I need to rethink about it since I wasn't aware of the
per-task-per-cpu events at that time.

AFAIK the uid switch is basically a same thing as pid/tid switch, so
your complain should be extended to them too. And I think we can remove
the check from perf_target__validate(). But before that something like
below is needed also IMHO:


diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ebcd15883ab8..8e3cf429dd18 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -900,6 +900,9 @@ static void perf_top__start_counters(struct perf_top *top)
                        attr->read_format |= PERF_FORMAT_ID;
                }
 
+               if (perf_target__has_cpu(&top->target))
+                       attr->sample_type |= PERF_SAMPLE_CPU;
+
                if (symbol_conf.use_callchain)
                        attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d7a2b4b9801d..d26b8fe0abd1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -107,7 +107,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
        if (opts->call_graph)
                attr->sample_type       |= PERF_SAMPLE_CALLCHAIN;
 
-       if (opts->target.system_wide)
+       if (perf_target__has_cpu(&opts->target))
                attr->sample_type       |= PERF_SAMPLE_CPU;
 
        if (opts->period)
