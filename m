Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2LCBlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:41:12 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51430 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2LCBlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:41:11 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-fb-50bc0334a044
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/18] perf hists: Exchange order of comparing items when collapsing hists
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	<1354171126-14387-9-git-send-email-namhyung@kernel.org>
	<20121129185257.GC1957@ghostprotocols.net>
Date: Mon, 03 Dec 2012 10:41:08 +0900
In-Reply-To: <20121129185257.GC1957@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 29 Nov 2012 15:52:57 -0300")
Message-ID: <87pq2ryksr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 15:52:57 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Nov 29, 2012 at 03:38:35PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> When comparing entries for collapsing put the given entry first, and
>> then the iterated entry.  This is for the sake of consistency and will
>
> consistency with what? and, see below:
>
>> be required by the event group report.
>> 
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Stephane Eranian <eranian@google.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/util/hist.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index 82df1b26f0d4..161c35e7ed0e 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -433,7 +433,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
>>  		parent = *p;
>>  		iter = rb_entry(parent, struct hist_entry, rb_node_in);
>>  
>> -		cmp = hist_entry__collapse(iter, he);
>> +		cmp = hist_entry__collapse(he, iter);
>>  
>>  		if (!cmp) {
>>  			he_stat__add_stat(&iter->stat, &he->stat);
>
> doesn't this now gets inconsistent with the hist_entry__collapse() call?
> I.e. iter first, he after, also there is the case for callchains, below,
> care to elaborate here?

I meant it by consistent with hist_entry__cmp() and didn't consider
he_stat__add_stat and callchain_merge things - thought that they're
other kind of operation.

I needed this change because I introduced hists__{match,link}_collapsed
function in the patch 8 and I found that hist_entry__cmp and
hist_entry__collapse received same kind of arguments in different
order.  Sorry about missing this in the changelog.

However on the second thought, I feel like I don't need those _collapsed
functions at all and perf diff can be converted to use collapsed rb tree
directly instead.  IIUC perf diff use those functions to match entries
by sort keys and do additional resort output rb tree by sort keys (IMHO
the function names - _name_resort and _insert_by_name - are misnomers)
to do the match.

Since output resorting (by period) is only needed for the baseline,
other data files doesn't need to do this additional step.  So I can get
rid of those hists__{match,link}_collapsed functions and change plain
hists__{match,link} functions to use collapsed (or input) rb tree
directly.

Jiri, what do you think?  What am I missing? :)

Thanks,
Namhyung
