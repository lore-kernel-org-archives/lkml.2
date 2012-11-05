Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2KEUIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:08:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab2KEUID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:08:03 -0500
Date: Mon, 5 Nov 2012 17:07:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v2 03/16] perf, core: Add a concept of a weightened sample
Message-ID: <20121105200747.GC7962@infradead.org>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
 <1352123463-7346-4-git-send-email-eranian@google.com>
 <20121105200147.GB7962@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105200147.GB7962@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 05, 2012 at 05:01:47PM -0300, Arnaldo Carvalho de Melo escreveu:
> > +
> >  	if (sample_type & PERF_SAMPLE_READ)
> >  		size += event->read_size;
> >  
> > @@ -4080,6 +4083,9 @@ void perf_output_sample(struct perf_output_handle *handle,
> >  	if (sample_type & PERF_SAMPLE_PERIOD)
> >  		perf_output_put(handle, data->period);
> >  
> > +	if (sample_type & PERF_SAMPLE_WEIGHT)
> > +		perf_output_put(handle, data->weight);
> > +
> 
> Yeap, it should go after PERF_SAMPLE_STACK_USER
> 
> >  	if (sample_type & PERF_SAMPLE_READ)
> >  		perf_output_read(handle, event);
> >  

I mean this, on top of the above patch:

diff -u b/kernel/events/core.c b/kernel/events/core.c
--- b/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4083,9 +4083,6 @@
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		perf_output_put(handle, data->period);
 
-	if (sample_type & PERF_SAMPLE_WEIGHT)
-		perf_output_put(handle, data->weight);
-
 	if (sample_type & PERF_SAMPLE_READ)
 		perf_output_read(handle, event);
 
@@ -4175,6 +4172,9 @@
 		perf_output_sample_ustack(handle,
 					  data->stack_user_size,
 					  data->regs_user.regs);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		perf_output_put(handle, data->weight);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,

------------

To match what this patch series will do on a later patch, i.e.
parse the weight at the end of perf_evsel__parse_sample, after
it parses PERF_SAMPLE_READ, PERF_SAMPLE_CALLCHAIN, PERF_SAMPLE_RAW,
PERF_SAMPLE_BRANCH_STACK, PERF_SAMPLE_REGS_USER and
PERF_SAMPLE_STACK_USER:

+++ b/tools/perf/util/evsel.c
@@ -1020,6 +1020,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
                }
        }

+       if (type & PERF_SAMPLE_WEIGHT) {
+               data->weight= *array;
+               array++;
+       }
+
        return 0;
 }

- Arnaldo
