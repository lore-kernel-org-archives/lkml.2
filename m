Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2LCKje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:39:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50955 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2LCKjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:39:33 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-4b-50bc816356a0
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/18] perf ui/hist: Add support for event group view
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	<1354171126-14387-14-git-send-email-namhyung@kernel.org>
	<20121130132943.GC1080@krava.brq.redhat.com>
	<CAM9d7ciOhUE9njWM2apYbiD-Ld3UP7JqhAzz76-DEemONR0OzA@mail.gmail.com>
	<20121203102327.GB1131@krava.redhat.com>
Date: Mon, 03 Dec 2012 19:39:31 +0900
In-Reply-To: <20121203102327.GB1131@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 3 Dec 2012 11:23:27 +0100")
Message-ID: <87a9tvifmk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012 11:23:27 +0100, Jiri Olsa wrote:
> On Mon, Dec 03, 2012 at 10:56:28AM +0900, Namhyung Kim wrote:
>> On Fri, Nov 30, 2012 at 10:29 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > ok, so this is the part thats common for both multi diff and group
>> > report and hugely depends on how we link matching hist_entry
>> >
>> > To sum to what group report does here:
>> >
>> > 1) starting with event group
>> > 2) the function 'he' belongs to leader hists
>> > 3) display leaders data value
>> > 4) if 'symbol_conf.event_group' is enabled, we want to display all
>> >    group members data values in a column
>> > 5) say we have group of 3 events 'e1,e2,e3' and e1 being the leader,
>> >    we have following possibilities:
>> >    - e1 have no pairs
>> >    - e1 is paired with e2
>> >    - e1 is paired with e3
>> >    - e1 is paired with e2 and e3 (e1 could also be dummy one)
>> > 6) need to display 3 values wrt to e1,e2,e3 output order
>> > 7) because events belongs to a group, each evsel carries group idx
>> > 8) so we walk all pairs and compute the eX value and put it
>> >    into temporary array based on its group idx
>> > 9) finally we display all temporary array values
>> >
>> >
>> > To sum up what multi diff needs to do here:
>> >
>> > 1) starting with 3 separate matching events from different
>> >    evlists(sessions)
>> > 2 - 5) are similar
>> > 6) need to display single diff value of hist_entry that
>> >    belongs to evsel, that belongs to a column we are just
>> >    displaying value for
>> > 7) events are not part of group; based on
>> >    [PATCH 02/14] perf tool: Add struct perf_hpp_fmt into hpp callbacks
>> >    we can tell what column we are in -> session -> evlist
>> > 8) we need to walk all pairs and for each hist_entry:
>> >    - compare all evsels (from point 7 evlist)
>> >      and match hists pointer
>> >    - when found, we have a matching hist_entry for this column
>> > 9) print out the value of matching hist_entry
>> >
>> >
>> > I think both this processing could be simplified by having hist_entry
>> > pairs connected via array and not linked list.
>> >
>> >
>> > For group report, each leader hist_entry would have 'pairs' array
>> > with the size of event group. Then we could omit the temporary array
>> > creation by:
>> >   - walking the leaders pairs
>> >   - when pair is found -> compute data -> display
>> >   - when pair is NULL  -> display 0
>> >
>> >
>> > For multi diff, each baseline hist_entry would have 'pairs' array
>> > with the size equal to number of data files on diff command input.
>> > This way we could use the data from point 7 to directly access
>> > related hist_entry.
>> >
>> >
>> > ufff... thoughts? ;-)
>> 
>> Nice summary, really! :)
>> 
>> Yeah, I do think it's better to use array for this.  If Arnaldo has no
>> objection to this approach, I'll convert my code to use the array.
>
> we discussed with Arnaldo and decided to stay with current approach and
> make the change later if needed.. to be able to see/meassure the benefit
>
> I made some initial attempt to workaround this and it appears to be
> not that bad ;) I'll repost my changes shortly..

Hmm.. so are you OK with this patch now?

Thanks,
Namhyung
