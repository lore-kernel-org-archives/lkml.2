Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2AZOYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:24:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2AZOYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:24:02 -0500
Date: Thu, 26 Jan 2012 12:23:49 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com
Subject: Re: [PATCH] perf: fix broken perf inject -b
Message-ID: <20120126142349.GC7968@infradead.org>
References: <20120113144731.GA5458@quad> <20120113165315.GA24387@infradead.org> <CABPqkBTe1uqiLm02fijYE2bwF=rWWu=V0mjZQbEzW0TUKa4-+Q@mail.gmail.com> <CABPqkBQyOuDv5Xt4hSHz2+GJCOUOVxZMGJHW3QpkNRdUBukMiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBQyOuDv5Xt4hSHz2+GJCOUOVxZMGJHW3QpkNRdUBukMiw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 26, 2012 at 03:16:15PM +0100, Stephane Eranian escreveu:
> On Fri, Jan 13, 2012 at 5:54 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Fri, Jan 13, 2012 at 5:53 PM, Arnaldo Carvalho de Melo
> > <acme@redhat.com> wrote:
> >> Em Fri, Jan 13, 2012 at 03:47:31PM +0100, Stephane Eranian escreveu:
> >>>
> >>> perf inject -b was broken. It would not inject any build_ids
> >>> into the stream. Furthermore, it would strip samples from the
> >>> stream.
> >>
> >> Against which tree is this patch?
> >>
> > 3.2.0-rc7-tip.
> > Did that get fixed later on?
> >
> Did you look at this patch?

Looking at it now.

- Arnaldo
 
> >>> The reason was a missing initialization of the event attribute
> >>> structures. The perf_tool.tool.attr() callback was pointing to
> >>> a simple repipe. But there was no initialization of internal data
> >>> structures to keep track of events and event ids. That later caused
> >>> event id lookups to fail, and samples would get dropped.
> >>>
> >>> The patch simply adds back the call to perf_event__process_attr()
> >>> to initialize the evlist structure. Build_ids are again injected.
> >>> The PID is also inject for PERF_RECORD_HEADER_BUILD_ID.
> >>>
> >>> Signed-off-by: Stephane Eranian <eranian@google.com>
> >>> ---
> >>>
> >>> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> >>> index 09c1061..f38f370 100644
> >>> --- a/tools/perf/builtin-inject.c
> >>> +++ b/tools/perf/builtin-inject.c
> >>> @@ -60,6 +60,11 @@ static int perf_event__repipe_tracing_data_synth(union perf_event *event,
> >>>  static int perf_event__repipe_attr(union perf_event *event,
> >>>                                  struct perf_evlist **pevlist __used)
> >>>  {
> >>> +     int ret;
> >>> +     ret = perf_event__process_attr(event, pevlist);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>>       return perf_event__repipe_synth(NULL, event, NULL);
> >>>  }
> >>>
> >>> @@ -173,6 +178,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
> >>>                      event->header.type);
> >>>               goto repipe;
> >>>       }
> >>> +     machine->pid = event->ip.pid;
> >>>
> >>>       thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
> >>>                             event->ip.ip, &al);
