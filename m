Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030899Ab2ERC6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:58:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:2748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030744Ab2ERC6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:58:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167905587"
Date: Fri, 18 May 2012 10:55:27 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <robert.richter@amd.com>,
        <ak@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf script/python: Pass thread/dso name and symbol
 info to event handler in python
Message-ID: <20120518105527.154fe294@feng-i7>
In-Reply-To: <20120517154726.GC2636@infradead.org>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
	<1337173155-25780-3-git-send-email-feng.tang@intel.com>
	<20120517154726.GC2636@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012 12:47:26 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Wed, May 16, 2012 at 08:59:15PM +0800, Feng Tang escreveu:
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  .../util/scripting-engines/trace-event-python.c    |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/scripting-engines/trace-event-python.c
> > b/tools/perf/util/scripting-engines/trace-event-python.c index
> > a202881..c96f5e2 100644 ---
> > a/tools/perf/util/scripting-engines/trace-event-python.c +++
> > b/tools/perf/util/scripting-engines/trace-event-python.c @@ -336,6 +336,7
> > @@ static void python_process_general_event(union perf_event *pevent
> > __unused, static char handler_name[64]; unsigned n = 0;
> >  	void *data = sample->raw_data;
> > +	struct thread *thread = al->thread;
> >  
> >  	t = PyTuple_New(MAX_FIELDS);
> >  	if (!t)
> > @@ -348,13 +349,21 @@ static void python_process_general_event(union
> > perf_event *pevent __unused, goto exit;
> >  	}
> >  
> > -	/* Pass 3 parameters: event_attr, perf_sample, raw data, thread
> > name */
> > +	/* Pass parameters: attr, perf_sample, raw data, thread and dso
> > name */ PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> >  			(const char *)&evsel->attr, sizeof(evsel->attr)));
> >  	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> >  			(const char *)sample, sizeof(*sample)));
> >  	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> >  			data, sample->raw_size));
> > +	PyTuple_SetItem(t, n++, PyString_FromString(thread->comm));
> > +	PyTuple_SetItem(t, n++, PyString_FromString(al->map->dso->name));
> > +
> > +	/* Pass the resolved symbol if there is, othersize pass "Unkown" */
> > +	if (al->sym)
> > +		PyTuple_SetItem(t, n++,
> > PyString_FromString(al->sym->name));
> > +	else
> > +		PyTuple_SetItem(t, n++, PyString_FromString("Unknown"));
> 
> Isn't this getting a little bit convoluted?
> 
> I.e. python has dictionaries, perhaps we could pass a dict instead of a
> tuple, in that case we would simply not add the "symbol" key.

IIRC, the PyObject_CallObjects() only accept "tuple" arguments, or did
you mean make the "symbol" a dict and an item of the "t" tuple?

I agree the symbol code is ugly, is following a little better?	
	PyTuple_SetItem(t, n++, PyString_FromString((al->sym) ? al->sym->name : "Unknown"));

Thanks,
Feng


> 
> >  	if (_PyTuple_Resize(&t, n) == -1)
> >  		Py_FatalError("error resizing Python tuple");
> > -- 
> > 1.7.1
