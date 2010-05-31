Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab0EaTGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:06:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46648 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab0EaTGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YvuqMfJh++jwcRCNOpSLkReEYkgm18+i9+PHWs5Ou41Si6duvMpv3Xqd9STvd31Qc0
         xfn8OTRyAcE1fm2CjsJW4blrmN9i4t+KcNwYf5PpmWakE9CdjQPmqCr0x/Er9cVi0LSn
         rhE44GfmXZ+/jIlrgGNGTgoKr/IzhyIsNd9V4=
Subject: Re: [PATCH] trace-event-python: give field dict to unhandled
 callback
From: Tom Zanussi <tzanussi@gmail.com>
To: Pierre Tardy <tardyp@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikn53S1Gd_lf4jeu5dEy9C_RTGxxioN4EEYxM2C@mail.gmail.com>
References: <1275147754-3037-1-git-send-email-tardyp@gmail.com>
	 <AANLkTikn53S1Gd_lf4jeu5dEy9C_RTGxxioN4EEYxM2C@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 14:06:36 -0500
Message-Id: <1275332796.6696.24.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 18:23 +0200, Pierre Tardy wrote:
> Ingo, Tom,
> Now rc1 is over...
> 
> Any comment on this patch? It is relatively minor.
> Do you intent to accept it?
> 

Yeah, sorry, long weekend here...

Yes, I like this - as you say, it is more pythonic, which is welcome
since I'm not really much of a python programmer myself.

I did try it out, and it worked fine, but I ran into one compile error
on my Ubuntu 8.10 system - the Py_DECREF() macro expands into an if
statement, see warning/error below.   So putting curly braces around the
if body fixed it for me (see below)

Other than that,

Acked-by: Tom Zanussi <tzanussi@gmail.com>

> Pierre
> 
> On Sat, May 29, 2010 at 5:42 PM, Pierre Tardy <tardyp@gmail.com> wrote:
> > trace_unhandled() callback does not allow to access event fields, this
> > patch resolves the problem.
> >
> > It can also been used as a more pythonic and flexible way for script
> > writters to demux event types
> >
> > This will for example greatly simplify pytimechart event demux.
> >
> > Signed-off-by: Pierre Tardy <tardyp@gmail.com>
> > ---
> >  tools/perf/scripts/python/check-perf-trace.py      |    3 +-
> >  .../util/scripting-engines/trace-event-python.c    |   51 +++++++++++++------
> >  2 files changed, 36 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
> > index 964d934..d9f7893 100644
> > --- a/tools/perf/scripts/python/check-perf-trace.py
> > +++ b/tools/perf/scripts/python/check-perf-trace.py
> > @@ -51,8 +51,7 @@ def kmem__kmalloc(event_name, context, common_cpu,
> >
> >                flag_str("kmem__kmalloc", "gfp_flags", gfp_flags)),
> >
> > -def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
> > -               common_pid, common_comm):
> > +def trace_unhandled(event_name, context, event_fields_dict):
> >     try:
> >         unhandled[event_name] += 1
> >     except TypeError:
> > diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> > index 81f39ca..db7c18a 100644
> > --- a/tools/perf/util/scripting-engines/trace-event-python.c
> > +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> > @@ -208,7 +208,7 @@ static void python_process_event(int cpu, void *data,
> >                                 int size __unused,
> >                                 unsigned long long nsecs, char *comm)
> >  {
> > -       PyObject *handler, *retval, *context, *t, *obj;
> > +       PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
> >        static char handler_name[256];
> >        struct format_field *field;
> >        unsigned long long val;
> > @@ -232,6 +232,14 @@ static void python_process_event(int cpu, void *data,
> >
> >        sprintf(handler_name, "%s__%s", event->system, event->name);
> >
> > +       handler = PyDict_GetItemString(main_dict, handler_name);
> > +       if (handler && !PyCallable_Check(handler))
> > +               handler = NULL;
> > +       if (!handler) {
> > +               dict = PyDict_New();
> > +               if (!dict)
> > +                       Py_FatalError("couldn't create Python dict");
> > +       }
> >        s = nsecs / NSECS_PER_SEC;
> >        ns = nsecs - s * NSECS_PER_SEC;
> >
> > @@ -242,12 +250,20 @@ static void python_process_event(int cpu, void *data,
> >        PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
> >        PyTuple_SetItem(t, n++,
> >                        PyCObject_FromVoidPtr(scripting_context, NULL));
> > -       PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
> > -       PyTuple_SetItem(t, n++, PyInt_FromLong(s));
> > -       PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
> > -       PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
> > -       PyTuple_SetItem(t, n++, PyString_FromString(comm));
> >
> > +       if (handler) {
> > +               PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
> > +               PyTuple_SetItem(t, n++, PyInt_FromLong(s));
> > +               PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
> > +               PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
> > +               PyTuple_SetItem(t, n++, PyString_FromString(comm));
> > +       } else {
> > +               PyDict_SetItemString(dict, "common_cpu", PyInt_FromLong(cpu));
> > +               PyDict_SetItemString(dict, "common_s", PyInt_FromLong(s));
> > +               PyDict_SetItemString(dict, "common_ns", PyInt_FromLong(ns));
> > +               PyDict_SetItemString(dict, "common_pid", PyInt_FromLong(pid));
> > +               PyDict_SetItemString(dict, "common_comm", PyString_FromString(comm));
> > +       }
> >        for (field = event->format.fields; field; field = field->next) {
> >                if (field->flags & FIELD_IS_STRING) {
> >                        int offset;
> > @@ -272,22 +288,25 @@ static void python_process_event(int cpu, void *data,
> >                                        obj = PyLong_FromUnsignedLongLong(val);
> >                        }
> >                }
> > -               PyTuple_SetItem(t, n++, obj);
> > +               if (handler)
> > +                       PyTuple_SetItem(t, n++, obj);
> > +               else
> > +                       PyDict_SetItemString(dict, field->name, obj);
> > +
> >        }
> > +       if (!handler)
> > +               PyTuple_SetItem(t, n++, dict);
> >
> >        if (_PyTuple_Resize(&t, n) == -1)
> >                Py_FatalError("error resizing Python tuple");
> >
> > -       handler = PyDict_GetItemString(main_dict, handler_name);
> > -       if (handler && PyCallable_Check(handler)) {
> > +       if (handler) {
> >                retval = PyObject_CallObject(handler, t);
> >                if (retval == NULL)
> >                        handler_call_die(handler_name);
> >        } else {
> >                handler = PyDict_GetItemString(main_dict, "trace_unhandled");
> >                if (handler && PyCallable_Check(handler)) {
> > -                       if (_PyTuple_Resize(&t, N_COMMON_FIELDS) == -1)
> > -                               Py_FatalError("error resizing Python tuple");
> >
> >                        retval = PyObject_CallObject(handler, t);
> >                        if (retval == NULL)
> > @@ -296,6 +315,8 @@ static void python_process_event(int cpu, void *data,
> >        }
> >
> >        Py_DECREF(t);
> > +       if (!handler)
> > +               Py_DECREF(dict);

This produces a warning, treated as an error:

CC util/scripting-engines/trace-event-python.o
cc1: warnings being treated as errors
util/scripting-engines/trace-event-python.c: In function
‘python_process_event’:
util/scripting-engines/trace-event-python.c:318: error: suggest explicit
braces to avoid ambiguous ‘else’
make: *** [util/scripting-engines/trace-event-python.o] Error 1

The if statement expands to:

if (!handler)
  if ( --(dict)->ob_refcnt != 0) ; else
( (*((PyObject*)(dict))->ob_type->tp_dealloc)((PyObject *)((PyObject
*)(dict))));


Changing the line to:

	if (!handler) {
		Py_DECREF(dict);
	}

fixes the compile error for me...

My system is:

Ubuntu 8.10
Python 2.5.2 (r252:60911, Oct  5 2008, 19:29:17)

Thanks,

Tom

> >  }
> >
> >  static int run_start_sub(void)
> > @@ -548,12 +569,10 @@ static int python_generate_script(const char *outfile)
> >        }
> >
> >        fprintf(ofp, "def trace_unhandled(event_name, context, "
> > -               "common_cpu, common_secs, common_nsecs,\n\t\t"
> > -               "common_pid, common_comm):\n");
> > +               "event_fields_dict):\n");
> >
> > -       fprintf(ofp, "\t\tprint_header(event_name, common_cpu, "
> > -               "common_secs, common_nsecs,\n\t\tcommon_pid, "
> > -               "common_comm)\n\n");
> > +       fprintf(ofp, "\t\tprint ' '.join(['%%s=%%s'%%(k,str(v))"
> > +               "for k,v in sorted(event_fields_dict.items())])\n\n");
> >
> >        fprintf(ofp, "def print_header("
> >                "event_name, cpu, secs, nsecs, pid, comm):\n"
> > --
> > 1.7.0.4
> >
> >
> 
> 
> 

