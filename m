Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1JSOPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab1JSOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:15:41 -0400
Date: Wed, 19 Oct 2011 12:15:06 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: "Xu, Anhua" <anhua.xu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong
	parameter
Message-ID: <20111019141506.GA8132@ghostprotocols.net>
References: <1A42CE6F5F474C41B63392A5F80372B212DC93638A@shsmsx501.ccr.corp.intel.com> <20111018181943.GC21666@elte.hu> <1318962501.14880.6.camel@twins> <1A42CE6F5F474C41B63392A5F80372B212DC9365C1@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A42CE6F5F474C41B63392A5F80372B212DC9365C1@shsmsx501.ccr.corp.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 19, 2011 at 10:23:12AM +0800, Xu, Anhua escreveu:
> Thanks Peter:). The key point for this is that the detailed information about "PRECISE_IP" may not be exposed to user space.
> Error reporting may come from syscall. Anyway, expect acme's suggestions.


Well, at least we can do as you did and avoid requests completely
invalid per the ABI or look the other way, truncate and silently provide
different behaviour than requested.

Point is how to propagate back from parse_event_modifier so that we
provide a sensible error message.

One could try to reuse errno and find things like -EINVAL, ELEVEL or
define some enum.
 
> 
> -----Original Message-----
> From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
> Sent: Wednesday, October 19, 2011 2:28 AM
> To: Ingo Molnar
> Cc: Xu, Anhua; Arnaldo Carvalho de Melo; linux-kernel@vger.kernel.org
> Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong parameter
> 
> On Tue, 2011-10-18 at 20:19 +0200, Ingo Molnar wrote:
> > > +#define SAMPLE_IP_MAX        3 
> > >                               precise_ip     :  2, /* skid constraint       */
> > >                               mmap_data      :  1, /* non-exec mmap data    */
> > >                               sample_id_all  :  1, /* sample_type all events */
> > > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > > index 928918b..a2068cc 100644
> > > --- a/tools/perf/util/parse-events.c
> > > +++ b/tools/perf/util/parse-events.c
> > > @@ -775,7 +775,10 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
> > >       attr->exclude_user   = eu;
> > >       attr->exclude_kernel = ek;
> > >       attr->exclude_hv     = eh;
> > > -     attr->precise_ip     = precise;
> > > +     if ( precise < SAMPLE_IP_MAX )
> > > +             attr->precise_ip = precise;
> > > +     else
> > > +             return -1; 
> 
> That name is horrid, how about PRECISE_IP_MAX? Also, I suspect acme will
> want a better error return than -1, but I'll leave that up to him.
