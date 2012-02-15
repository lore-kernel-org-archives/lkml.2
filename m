Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2BORsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:48:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51980 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2BORr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:47:59 -0500
Date: Wed, 15 Feb 2012 15:47:48 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Luigi Semenzato <semenzato@chromium.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] Perf: bug fix: distinguish between rename and exec
Message-ID: <20120215174748.GN28614@infradead.org>
References: <1329195360-10699-1-git-send-email-semenzato@chromium.org>
 <1329310113.2293.72.camel@twins>
 <20120215134733.GL28614@infradead.org>
 <CAA25o9SW+EqsUhv-Ze6fX5-DyZ4fTHXL5CZd0rHnTLsOBxV7xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA25o9SW+EqsUhv-Ze6fX5-DyZ4fTHXL5CZd0rHnTLsOBxV7xg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 15, 2012 at 09:07:47AM -0800, Luigi Semenzato escreveu:
> On Wed, Feb 15, 2012 at 5:47 AM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Wed, Feb 15, 2012 at 01:48:33PM +0100, Peter Zijlstra escreveu:
> >> I really dislike changing generic code purely for the purpose of
> >> instrumentation like this. Better to pull perf_event_comm() out of here
> >> if you want to change semantics.
> >>
> >> Personally I couldn't care less about renames, I think they're a waste
> >> of time, so I'm ok with the simple patch moving the perf_event_comm()
> >> into setup_new_exec() and possibly renaming it to perf_event_exec().
> >>
> >> Acme, do you care about renames?
> >
> > I like your idea of keeping the semantics of PERF_RECORD_COMM and
> > introducing a PERF_RECORD_EXEC, just have to think about how to handle
> > that in a way that the tools detect that we have PERF_RECORD_EXEC...
> 
> I considered this but I don't know how important it is to be backward
> compatible.  Adding a new record type makes old "perf report" fail to
> parse new perf.data files.  (Unless we pad the new record to a

Hey, old perf record would still see the PERF_RECORD_COMM, i.e. we would
continue asking for PERF_RECORD_COMM in new versions. Together with
PERF_RECORD_EXEC.

> multiple of 8 bytes, but I don't think we want to go down that path).
> 
> If looking forward is more important, I agree a new new record type is
> best.  We might want to consider adding a PERF_RECORD_RENAME for

PERF_RECORD_COMM is good enough, well, it always was confusing for most
people that asked "hey, that means an EXEC, right?"

First thing pople think is "hey, this is when it sets the thread COMM,
right?"

> renames, and leaving the COMM record to its historical meaning (exec),
> possibly renaming it to PERF_RECORD_EXEC for clarity.  And yes, the
> perf instrumentation should not be in set_task_comm(), that's why the
> bug exists in the first place.
> 
> We might also want to change the parsing of perf.data so that in the
> future it is more tolerant of new record types.

Yes, what is the behaviour now? Lemme see... Well, difficult, I'm barely
reading this, just after magnifying it, dilated pupils two hours ago,
grrr

Wiĺl check later, but IIRC it just warns and skips the record, right?
 
> > Humm, will be yet another fallback for setting an perf_event_attr bit,
> > just like with .sample_id_all and .exclude_{guest,host}...
> >
> > That together with the per class errnos + __strerror() method will allow
> > to move all the event creation finally to perf_evlist__open() where all
> > this gets nicely hidden away from poor tools.
> >
> > We can then even have an ui__evlist_perror() method that does all the
> > ui__warning calls, etc.
> >
> > So, yes, from a tooling perspective, I want to be notified of renames
> > and being able to stop relying on PERF_RECORD_COMM to call
> > map_groups__flush and instead do it at PERF_RECORD_EXEC seems a
> > bonus.
> >
> > - Arnaldo
