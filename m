Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab2F1Iyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:54:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:31027 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2F1Iyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:54:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="163875181"
Date: Thu, 28 Jun 2012 16:50:27 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 3/3] perf script/python: Pass event/thread/dso name
 and symbol info to event handler in python
Message-ID: <20120628165027.43806b3d@feng-i7>
In-Reply-To: <20120627185817.GD20530@infradead.org>
References: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
	<1339999839-14007-4-git-send-email-feng.tang@intel.com>
	<20120627185817.GD20530@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 27 Jun 2012 15:58:17 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Mon, Jun 18, 2012 at 02:10:39PM +0800, Feng Tang escreveu:
> > Also as suggested by Arnaldo, pack all these parameters to a dictionary,
> > which is more expandable for adding new parameters while keep the
> > compatibility for old scripts.
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  .../util/scripting-engines/trace-event-python.c    |   32
> > +++++++++++++++---- 1 files changed, 25 insertions(+), 7 deletions(-)
> > 
> > diff --git a/tools/perf/util/scripting-engines/trace-event-python.c
> > b/tools/perf/util/scripting-engines/trace-event-python.c index
> > 97f4fad..e8ac480 100644 ---
> > a/tools/perf/util/scripting-engines/trace-event-python.c +++
> > b/tools/perf/util/scripting-engines/trace-event-python.c @@ -336,15 +336,23
> > @@ static void python_process_general_event(union perf_event *pevent
> > __unused, struct machine *machine __unused, struct addr_location *al)
> >  {
> > -	PyObject *handler, *retval, *t;
> > +	PyObject *handler, *retval, *t, *dict;
> >  	static char handler_name[64];
> >  	unsigned n = 0;
> > -	void *data = sample->raw_data;
> > +	struct thread *thread = al->thread;
> >  
> > +	/*
> > +	 * Use the MAX_FIELDS to make the function expandable, though
> > +	 * currently there is only one itme for the tuple.
> > +	 */
> >  	t = PyTuple_New(MAX_FIELDS);
> >  	if (!t)
> >  		Py_FatalError("couldn't create Python tuple");
> >  
> > +	dict = PyDict_New();
> > +	if (!dict)
> > +		Py_FatalError("couldn't create Python dictionary");
> > +
> >  	snprintf(handler_name, sizeof(handler_name), "%s",
> > "process_event"); 
> >  	handler = PyDict_GetItemString(main_dict, handler_name);
> > @@ -353,14 +361,23 @@ static void python_process_general_event(union
> > perf_event *pevent __unused, goto exit;
> >  	}
> >  
> > -	/* Pass 4 parameters: event_attr, perf_sample, raw data, thread
> > name */
> > -	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> > +	PyDict_SetItemString(dict, "ev_name",
> > PyString_FromString(event_name(evsel)));
> > +	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
> >  			(const char *)&evsel->attr, sizeof(evsel->attr)));
> > -	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> > +	PyDict_SetItemString(dict, "sample", PyString_FromStringAndSize(
> >  			(const char *)sample, sizeof(*sample)));
> > -	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> > -			data, sample->raw_size));
> > +	PyDict_SetItemString(dict, "raw_buf", PyString_FromStringAndSize(
> > +			(const char *)sample->raw_data, sample->raw_size));
> > +	PyDict_SetItemString(dict, "comm",
> > +			PyString_FromString(thread->comm));
> > +	PyDict_SetItemString(dict, "dso",
> > +			PyString_FromString(al->map->dso->name));
> > +	if (al->sym) {
> > +		PyDict_SetItemString(dict, "symbol",
> > +			PyString_FromString(al->sym->name));
> > +	}
> >  
> > +	PyTuple_SetItem(t, n++, dict);
> 
> Now old scrips will break, as the tuple they expect:
> 
>  (attr, sample, raw_data)
> 
> will not be there.

Actually, there are no such scripts out. Current perf python script only
supports the trace point type, while perl scriptt has the support for
general events. It is my first patch "perf script: Add general python 
handler to process non-tracepoint events" which bring this (attr, sample,
raw_data) in to be on the same page as perl. So this won't be a problem
when the 3 patches are merged together. 

> 
> The first two patches in this series don't apply anymore, please find
> them attached fixed, please check if they work as expected.
Thanks a lot for fixing them, I'll generate perf tool patch against the
"perf/core" branch of your git tree on kernel.org from now on.

Btw, I have 2 more python scripts based on these patches, will add them
to this serie for your review.

Thanks,
Feng

