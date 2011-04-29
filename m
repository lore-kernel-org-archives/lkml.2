Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab1D2TYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:24:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab1D2TYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 15:24:02 -0400
Date: Fri, 29 Apr 2011 21:23:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/stat] perf stat: Fail softly on unsupported events
Message-ID: <20110429192347.GA15068@elte.hu>
References: <tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org>
 <4DBACC5C.1020502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBACC5C.1020502@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> 
> 
> On 04/29/11 08:27, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  370faf1dd0461ad811852c8abbbcd3d73b1e4fc4
> > Gitweb:     http://git.kernel.org/tip/370faf1dd0461ad811852c8abbbcd3d73b1e4fc4
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Fri, 29 Apr 2011 16:11:03 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 29 Apr 2011 16:22:33 +0200
> > 
> > perf stat: Fail softly on unsupported events
> > 
> > David Ahern reported this perf stat failure:
> > 
> >> # /tmp/build-perf/perf stat -- sleep 1
> >>   Error: stalled-cycles-frontend event is not supported.
> >>   Fatal: Not all events could be opened.
> >>
> >> This is a Dell R410 with an E5620 processor.
> > 
> > Fail in a softer fashion on unknown/unsupported events.
> > 
> > Reported-by: David Ahern <dsahern@gmail.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Link: http://lkml.kernel.org/n/tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  tools/perf/builtin-stat.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> > index 9e596ab..c8b535b 100644
> > --- a/tools/perf/builtin-stat.c
> > +++ b/tools/perf/builtin-stat.c
> > @@ -377,7 +377,7 @@ static int run_perf_stat(int argc __used, const char **argv)
> >  
> >  	list_for_each_entry(counter, &evsel_list->entries, node) {
> >  		if (create_perf_stat_counter(counter) < 0) {
> > -			if (errno == EINVAL || errno == ENOSYS)
> > +			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT)
> >  				continue;
> >  
> >  			if (errno == EPERM || errno == EACCES) {
> > @@ -385,8 +385,6 @@ static int run_perf_stat(int argc __used, const char **argv)
> >  				      "\t Consider tweaking"
> >  				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
> >  				      system_wide ? "system-wide " : "");
> > -			} else if (errno == ENOENT) {
> > -				error("%s event is not supported. ", event_name(counter));
> 
> This silently ignores events -- including ones that a user requested. I
> think a better option is a continue here.
> 
>  /tmp/build-perf/perf stat -- sleep 1
>   Error: stalled-cycles-frontend event is not supported.
>   Error: stalled-cycles-backend event is not supported.

Ok. Got time to send a patch for that, which prints whichever message you find 
the most intuitive? Perhaps word it as:

 Info: stalled-cycles-frontend event is not supported by the kernel

to not yell 'error!' at users all the time?

Thanks,

	Ingo
