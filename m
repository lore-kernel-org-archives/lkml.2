Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146Ab2FHQoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:44:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:27551 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2FHQoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="154958825"
Subject: Re: Does perf inject preserve call chain data?
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20120608143843.GA9954@infradead.org>
References: <1337712585.3796.186.camel@schen9-DESK>
	 <4FBC0C10.8010801@gmail.com>  <20120608143843.GA9954@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 09:44:56 -0700
Message-ID: <1339173896.3796.230.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 11:38 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, May 22, 2012 at 03:58:40PM -0600, David Ahern escreveu:
> > On 5/22/12 12:49 PM, Tim Chen wrote:
> > >Arnaldo,
> > >
> > >Wonder if perf inject munged the call chain data from perf record?
> > >
> > >When I do
> > >perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -
> > >I get a complain from perf report
> > >
> > >Warning:
> > >Selected -g but no callchain data. Did you call 'perf record' without -g?
> > >
> > 
> > I believe the root cause is that the event list is not written to
> > the pipe. Using Arnaldo's git repo as of today (has fixes from
> > Stephane) this hack shows the info is there and can be processed.
> 
> How things stand here? Tim, did this fix things for you? If so, David,
> please resend with a proper subject line and a Tested-by: Tim, ok?
> 
> Thanks,
> 
> - Arnaldo
>  

It didn't fix things for me when I was testing on a westmere-ex machine.
I got

# ./perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report -g  -i -
incompatible file format
incompatible file formatincompatible file formatselected -g but no callchain data. Did you call perf record without -g?

Testing was done on 3.5.0-rc1.

Tim

> > 
> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index d58e414..60f3f17 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -256,7 +257,7 @@ static int perf_report__setup_sample_type(struct
> > perf_report *rep)
> >                     "'perf record' without -g?\n");
> >             return -EINVAL;
> >         }
> > -       if (symbol_conf.use_callchain) {
> > +       if (!self->fd_pipe && symbol_conf.use_callchain) {
> >             ui__warning("Selected -g but no callchain data. Did "
> >                     "you call 'perf record' without -g?\n");
> >             return -1;
> > 
> > A proper solution is needed.
> > 
> > David


