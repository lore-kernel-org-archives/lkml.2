Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2LCB4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:56:50 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58195 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2LCB4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:56:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121130132943.GC1080@krava.brq.redhat.com>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-14-git-send-email-namhyung@kernel.org> <20121130132943.GC1080@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 3 Dec 2012 10:56:28 +0900
X-Google-Sender-Auth: ElWRn4QhfJY5vrWBjvjnCR_TqmM
Message-ID: <CAM9d7ciOhUE9njWM2apYbiD-Ld3UP7JqhAzz76-DEemONR0OzA@mail.gmail.com>
Subject: Re: [PATCH 12/18] perf ui/hist: Add support for event group view
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Nov 30, 2012 at 10:29 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Nov 29, 2012 at 03:38:40PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> +#define __HPP_COLOR_PERCENT_FN(_type, _field)                                        \
>> +static int hpp__color_##_type(struct perf_hpp *hpp, struct hist_entry *he)   \
>> +{                                                                            \
>> +     int ret;                                                                \
>> +     double percent = 0.0;                                                   \
>> +     struct hists *hists = he->hists;                                        \
>> +                                                                             \
>> +     if (hists->stats.total_period)                                          \
>> +             percent = 100.0 * he->stat._field / hists->stats.total_period;  \
>> +                                                                             \
>> +     ret = percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent); \
>> +                                                                             \
>> +     if (symbol_conf.event_group) {                                          \
>> +             int i;                                                          \
>> +             struct perf_evsel *evsel = hists_to_evsel(hists);               \
>> +             struct hist_entry *pair;                                        \
>> +             int nr_members = evsel->nr_members;                             \
>> +             double *percents;                                               \
>> +                                                                             \
>> +             if (nr_members <= 1)                                            \
>> +                     return ret;                                             \
>> +                                                                             \
>> +             percents = zalloc(sizeof(*percents) * nr_members);              \
>> +             if (percents == NULL) {                                         \
>> +                     pr_warning("Not enough memory!\n");                     \
>> +                     return ret;                                             \
>> +             }                                                               \
>> +                                                                             \
>> +             list_for_each_entry(pair, &he->pairs.head, pairs.node) {        \
>> +                     u64 period = pair->stat._field;                         \
>> +                     u64 total = pair->hists->stats.total_period;            \
>> +                                                                             \
>> +                     if (!total)                                             \
>> +                             continue;                                       \
>> +                                                                             \
>> +                     evsel = hists_to_evsel(pair->hists);                    \
>> +                     i = perf_evsel__group_idx(evsel);                       \
>> +                     percents[i] = 100.0 * period / total;                   \
>> +             }                                                               \
>> +                                                                             \
>> +             for (i = 1; i < nr_members; i++) {                              \
>> +                     ret += percent_color_snprintf(hpp->buf + ret,           \
>> +                                                   hpp->size - ret,          \
>> +                                                   " %6.2f%%", percents[i]); \
>> +             }                                                               \
>> +             free(percents);                                                 \
>> +     }                                                                       \
>> +     return ret;                                                             \
>> +}
>
> ok, so this is the part thats common for both multi diff and group
> report and hugely depends on how we link matching hist_entry
>
> To sum to what group report does here:
>
> 1) starting with event group
> 2) the function 'he' belongs to leader hists
> 3) display leaders data value
> 4) if 'symbol_conf.event_group' is enabled, we want to display all
>    group members data values in a column
> 5) say we have group of 3 events 'e1,e2,e3' and e1 being the leader,
>    we have following possibilities:
>    - e1 have no pairs
>    - e1 is paired with e2
>    - e1 is paired with e3
>    - e1 is paired with e2 and e3 (e1 could also be dummy one)
> 6) need to display 3 values wrt to e1,e2,e3 output order
> 7) because events belongs to a group, each evsel carries group idx
> 8) so we walk all pairs and compute the eX value and put it
>    into temporary array based on its group idx
> 9) finally we display all temporary array values
>
>
> To sum up what multi diff needs to do here:
>
> 1) starting with 3 separate matching events from different
>    evlists(sessions)
> 2 - 5) are similar
> 6) need to display single diff value of hist_entry that
>    belongs to evsel, that belongs to a column we are just
>    displaying value for
> 7) events are not part of group; based on
>    [PATCH 02/14] perf tool: Add struct perf_hpp_fmt into hpp callbacks
>    we can tell what column we are in -> session -> evlist
> 8) we need to walk all pairs and for each hist_entry:
>    - compare all evsels (from point 7 evlist)
>      and match hists pointer
>    - when found, we have a matching hist_entry for this column
> 9) print out the value of matching hist_entry
>
>
> I think both this processing could be simplified by having hist_entry
> pairs connected via array and not linked list.
>
>
> For group report, each leader hist_entry would have 'pairs' array
> with the size of event group. Then we could omit the temporary array
> creation by:
>   - walking the leaders pairs
>   - when pair is found -> compute data -> display
>   - when pair is NULL  -> display 0
>
>
> For multi diff, each baseline hist_entry would have 'pairs' array
> with the size equal to number of data files on diff command input.
> This way we could use the data from point 7 to directly access
> related hist_entry.
>
>
> ufff... thoughts? ;-)

Nice summary, really! :)

Yeah, I do think it's better to use array for this.  If Arnaldo has no
objection to this approach, I'll convert my code to use the array.

And please see my another post for thoughts on the hists__{link,match} too. ;-)

Thanks,
Namhyung
