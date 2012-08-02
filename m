Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2HBIsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab2HBIsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:48:30 -0400
Date: Thu, 2 Aug 2012 10:42:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: "acme@redhat.com" <acme@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
        "cjashfor@linux.vnet.ibm.com" <cjashfor@linux.vnet.ibm.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "eranian@google.com" <eranian@google.com>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "tzanussi@gmail.com" <tzanussi@gmail.com>,
        "mhiramat@redhat.com" <mhiramat@redhat.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "fche@redhat.com" <fche@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "drepper@gmail.com" <drepper@gmail.com>,
        "asharma@fb.com" <asharma@fb.com>,
        "benjamin.redelings@nescent.org" <benjamin.redelings@nescent.org>,
        Andrew Vagin <avagin@openvz.org>
Subject: Re: [PATCH 07/13] perf: Add attribute to filter out callchains
Message-ID: <20120802084256.GA991@krava.brq.redhat.com>
References: <1343815865-5511-1-git-send-email-jolsa@redhat.com>
 <1343815865-5511-8-git-send-email-jolsa@redhat.com>
 <20120802073826.GA6847@avaginn.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802073826.GA6847@avaginn.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 11:38:26AM +0400, Andrew Vagin wrote:
> On Wed, Aug 01, 2012 at 02:10:59PM +0400, Jiri Olsa wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com> 
> > 
> > Introducing following bits to the the perf_event_attr struct:
> >   - exclude_callchain_kernel to filter out kernel callchain
> >     from the sample dump
> >   - exclude_callchain_user to filter out user callchain
> >     from the sample dump
> > 
> > We need to be able to disable standard user callchain dump
> > when we use the dwarf cfi callchain mode, because frame
> > pointer based user callchains are useless in this mode.
> > 
> > Implementing also exclude_callchain_kernel to have complete
> > set of options.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > [ Added kernel callchains filtering ]
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > CC: Andrew Vagin <avagin@openvz.org>
> 
> Acked-by: Andrew Vagin <avagin@openvz.org>
> 
> 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index c4582bb..0902d4a 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -4130,8 +4130,12 @@ void perf_prepare_sample(struct perf_event_header *header,
> >  
> >  	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
> >  		int size = 1;
> > +		int kernel = !event->attr.exclude_callchain_kernel;
> > +		int user   = !event->attr.exclude_callchain_user;
> >  
> > -		data->callchain = perf_callchain(event, regs);
> > +		if (kernel || user)
> > +			data->callchain = perf_callchain(event, regs,
> > +							 kernel, user);
> I am not sure, that we need two arguments kernel and user here,
> we can get them from event inside perf_callchain...

right.. I'll send an update with other fixies

thanks
jirka
