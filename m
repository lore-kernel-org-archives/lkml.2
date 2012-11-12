Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2KLCK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:10:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48860 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2KLCKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:10:55 -0500
X-AuditID: 9c930197-b7b45ae000000e9e-90-50a05aaca58d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Vinson Lee <vlee@twitter.com>,
        Zheng Liu <wenqing.lz@taobao.com>, acme@ghostprotocols.net,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Date: Mon, 12 Nov 2012 11:10:52 +0900
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Fri, 9 Nov 2012 18:42:49 -0300")
Message-ID: <87390fo9jn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri,  9 Nov 2012 18:42:49 -0300, Arnaldo Carvalho de Melo wrote:
> Hi Ingo,
>
> 	Please consider pulling.
>
> - Arnaldo
>
> The following changes since commit 8dfec403e39b7c37fd6e8813bacc01da1e1210ab:
>
>   perf tests: Removing 'optional' field (2012-11-05 14:03:59 -0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
>
> for you to fetch changes up to 27f94d52394003d444a383eaf8d4824daf32432e:
>
>   tools lib traceevent: Use 'const' in variables pointing to const strings (2012-11-09 17:42:47 -0300)
>
> ----------------------------------------------------------------
> perf/core improvements and fixes:
>
> . Add a 'link' method for hists, so that we can have the leader with
>   buckets for all the entries in all the hists.  This new method
>   is now used in the default 'diff' output, making the sum of the 'baseline'
>   column be 100%, eliminating blind spots. Now we need to use this
>   for 'diff' with > 2 perf.data files and for multi event 'report' and
>   'annotate'.

I'm not sure it can be used for group report at least in its current
form.  IIUC it connects multiple hist entries using a list head and
create a dummy entry in the leader if need be.  But it didn't handle
non-leader entries so it's hard to tell which is which if less entries
are present only.  For example consider following case:

	leader		member1		member2
	A		A		A
	B
			C
					D

where leader, member1 and member2 are evsel/hists and A, B, C and D are
hist entries.  After 'linking' the entries the leader will have
following linkage:

	leader
	A	->	A	->	A
	B
	C (dummy) ->	C
	D (dummy)		->	D

In this case, for entry A the leader can determine which entry came from
which hists by looking its order in the list.  For entry B the leader
can use zero value for them since the list is empty.  However for
entries C and D, it cannot know which one is the right hists unless it
records a hist index or creates dummy entry and insert it in a correct
order (looks far from an optimal solution).  Am I missing something?

Thanks,
Namhyung
