Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424404Ab2LFQ0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:26:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424131Ab2LFQZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:25:57 -0500
Date: Thu, 6 Dec 2012 17:25:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/5] perf hists: Link hist entries before inserting to an
 output tree
Message-ID: <20121206162543.GC1080@krava.brq.redhat.com>
References: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
 <1354806581-5316-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354806581-5316-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 12:09:39AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> For matching and/or linking hist entries, they need to be sorted by
> given sort keys.  However current hists__match/link did this on the
> output trees, so that the entries in the output tree need to be resort
> before doing it.
> 
> This looks not so good since we have trees for collecting or
> collapsing entries before passing them to an output tree and they're
> already sorted by the given sort keys.  Since we don't need to print
> anything at the time of matching/linking, we can use these internal
> trees directly instead of bothering with double resort on the output
> tree.

this patch also makes diff working over collapsed entries,
which was not possible before.. nice ;)

outputs like:

[jolsa@krava perf]$ ./perf diff  -s comm
# Event 'cycles:u'
#
# Baseline    Delta          Command
# ........  .......  ...............
#
     5.24%  +68.96%          firefox
     2.34%   +5.66%                X
    48.51%  -41.53%             mocp
    14.98%  -11.53%            skype
    18.01%  -15.35%  plugin-containe
     1.03%   +1.48%            xchat
     5.54%   -4.61%          gkrellm
     1.41%   -0.93%            xterm
             +0.33%  xmonad-x86_64-l
             +0.23%              vim
             +0.07%     xscreensaver
     0.19%   -0.14%          swapper
     1.00%   -0.97%   NetworkManager
     0.28%   -0.25%              ssh
     0.11%   -0.09%            sleep
     0.84%   -0.83%      dbus-daemon
     0.02%   -0.01%             perf
     0.40%   -0.40%   wpa_supplicant
     0.05%   -0.05%              gpm
     0.04%   -0.04%            crond


small nitpick below, otherwise

Acked-by: Jiri Olsa <jolsa@redhat.com>


> 
> Its only user - at the time of this writing - perf diff can be easily
> converted to use the internal tree and can save some lines too by
> getting rid of unnecessary resorting codes.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-diff.c |   65 ++++++++++++---------------------------------
>  tools/perf/util/hist.c    |   49 +++++++++++++++++++++++++---------
>  2 files changed, 54 insertions(+), 60 deletions(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index b2e7d39f099b..044ad99dcc90 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -275,43 +275,6 @@ static struct perf_tool tool = {
>  	return NULL;A

SNIP

>  }
>  
> -static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
> +static void perf_evlist__resort_hists(struct perf_evlist *evlist)

this could be called 'perf_evlist__collapse_resort' now

>  {
>  	struct perf_evsel *evsel;
>  
>  	list_for_each_entry(evsel, &evlist->entries, node) {
>  		struct hists *hists = &evsel->hists;
>  
> -		hists__output_resort(hists);
> -
> -		if (name)
> -			hists__name_resort(hists);
> +		hists__collapse_resort(hists);
>  	}
>  }

SNIP
