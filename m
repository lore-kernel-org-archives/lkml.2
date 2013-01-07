Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3AGN2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab3AGN17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:27:59 -0500
Date: Mon, 7 Jan 2013 14:27:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v4 05/18] perf: add minimal support for PERF_SAMPLE_WEIGHT
Message-ID: <20130107132744.GE963@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-6-git-send-email-eranian@google.com>
 <20130102140752.GC931@krava.brq.redhat.com>
 <CABPqkBQW0zKZoFoFZrTAV2f7vDeB8-CeMtQWcbA+K_aZatGrEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQW0zKZoFoFZrTAV2f7vDeB8-CeMtQWcbA+K_aZatGrEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 02:10:20PM +0100, Stephane Eranian wrote:
> On Wed, Jan 2, 2013 at 3:07 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Dec 20, 2012 at 04:41:35PM +0100, Stephane Eranian wrote:
> >> Ensure we grab the weight from  raw sample struct
> >> and that we can dump it via perf report -D.
> >>
> >> Signed-off-by: Stephane Eranian <eranian@google.com>
> >> ---
> >>  tools/perf/util/event.h   |    1 +
> >>  tools/perf/util/evsel.c   |    5 +++++
> >>  tools/perf/util/session.c |    3 +++
> >>  3 files changed, 9 insertions(+)
> >>
> >> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> >> index 0d573ff..cf52977 100644
> >> --- a/tools/perf/util/event.h
> >> +++ b/tools/perf/util/event.h
> >> @@ -90,6 +90,7 @@ struct perf_sample {
> >>       u64 period;
> >>       u32 cpu;
> >>       u32 raw_size;
> >> +     u64 weight;
> >>       void *raw_data;
> >>       struct ip_callchain *callchain;
> >>       struct branch_stack *branch_stack;
> >> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> >> index 1b16dd1..4374c07 100644
> >> --- a/tools/perf/util/evsel.c
> >> +++ b/tools/perf/util/evsel.c
> >> @@ -1058,6 +1058,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
> >>               }
> >>       }
> >>
> >> +     if (type & PERF_SAMPLE_WEIGHT) {
> >> +             data->weight= *array;
> >> +             array++;
> >> +     }
> >> +
> >
> > this bit should be placed right after PERF_SAMPLE_PERIOD (where
> > you placed it in kernel path), otherwise you get wrong data
> >
> 
> Thought some more about this. I think this new WEIGHT sample type is
> in the wrong place in Andi's patch.
> It's new, it should be put at the end of perf_output_sample(). That's
> necessary to ensure older versions
> of perf (without the knowledge about WEIGHT) can still decode
> PERF_SAMPLE_READ in case
> PERF_SAMPLE_WEIGHT is present in the perf.data file.

agreed
