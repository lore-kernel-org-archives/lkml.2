Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2LCKtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:49:41 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52759 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2LCKtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:49:40 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-d7-50bc83c0ed10
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/18] perf hists: Exchange order of comparing items when collapsing hists
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	<1354171126-14387-9-git-send-email-namhyung@kernel.org>
	<20121129185257.GC1957@ghostprotocols.net>
	<87pq2ryksr.fsf@sejong.aot.lge.com>
	<20121203101952.GA1131@krava.redhat.com>
Date: Mon, 03 Dec 2012 19:49:36 +0900
In-Reply-To: <20121203101952.GA1131@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 3 Dec 2012 11:19:52 +0100")
Message-ID: <87624jif5r.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012 11:19:52 +0100, Jiri Olsa wrote:
> On Mon, Dec 03, 2012 at 10:41:08AM +0900, Namhyung Kim wrote:
>> On Thu, 29 Nov 2012 15:52:57 -0300, Arnaldo Carvalho de Melo wrote:
>> > doesn't this now gets inconsistent with the hist_entry__collapse() call?
>> > I.e. iter first, he after, also there is the case for callchains, below,
>> > care to elaborate here?
>> 
>> I meant it by consistent with hist_entry__cmp() and didn't consider
>> he_stat__add_stat and callchain_merge things - thought that they're
>> other kind of operation.
>> 
>> I needed this change because I introduced hists__{match,link}_collapsed
>> function in the patch 8 and I found that hist_entry__cmp and
>> hist_entry__collapse received same kind of arguments in different
>> order.  Sorry about missing this in the changelog.
>> 
>> However on the second thought, I feel like I don't need those _collapsed
>> functions at all and perf diff can be converted to use collapsed rb tree
>> directly instead.  IIUC perf diff use those functions to match entries
>> by sort keys and do additional resort output rb tree by sort keys (IMHO
>> the function names - _name_resort and _insert_by_name - are misnomers)
>> to do the match.
>> 
>> Since output resorting (by period) is only needed for the baseline,
>> other data files doesn't need to do this additional step.  So I can get
>> rid of those hists__{match,link}_collapsed functions and change plain
>> hists__{match,link} functions to use collapsed (or input) rb tree
>> directly.
>>
>> Jiri, what do you think?  What am I missing? :)
>
> feels like I'm missing something now :))
>
> right now I don't see a point in having sort__need_collapse enabled
> for group report.. there seems to be no special processing as it was
> in the initial patchset..?

Right.  It's not needed anymore, will remove.

>
> It seems like you could do only stadard period resort (collapsed if
> needed) and afterwards run current hists__match and hists_link function
> they are now.

But hists__match/link needs the tree sorted by sort keys.  That means I
have to do something like:

(1) add_hist_entry (sort by keys)
(2) (optionally) hists__collapse_resort (sort by keys)
(3) hists__output_resort (sort by period)
(4) manual resort (by keys)
(5) hists__match/link
(6) (duplicated) hists__output_resort (sort by period)

I think the step (3) and (4) are unnecessary if we use input (or
collapsed) tree directly.

>
> All you need at the output callback is paired leader hist entry.. where
> you do the temp array magic to get the data.

Yeah, this is what I'm saying.  So we don't need to use output tree for
matching and linking entries.

Thanks,
Namhyung
