Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1JWRHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:07:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:21733 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1JWRHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="66242098"
From: "Xu, Anhua" <anhua.xu@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Oct 2011 01:07:02 +0800
Subject: RE: perf tools: interface for improved PEBS ABI can accept wrong
	parameter
Thread-Topic: perf tools: interface for improved PEBS ABI can accept wrong
	parameter
Thread-Index: AcyOacaH/6Ru/UwcTYqzZ2i4Y3hs0QDPDghA
Message-ID: <1A42CE6F5F474C41B63392A5F80372B212DCA0302A@shsmsx501.ccr.corp.intel.com>
References: <1A42CE6F5F474C41B63392A5F80372B212DC93638A@shsmsx501.ccr.corp.intel.com>
 <20111018181943.GC21666@elte.hu> <1318962501.14880.6.camel@twins>
 <1A42CE6F5F474C41B63392A5F80372B212DC9365C1@shsmsx501.ccr.corp.intel.com>
 <20111019141506.GA8132@ghostprotocols.net>
In-Reply-To: <20111019141506.GA8132@ghostprotocols.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have update my patch. Hope it is not so horrid :)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c816075..837f416 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -238,6 +238,17 @@ struct perf_event_attr {
 	};
 };
 
+enum perf_sample_ip_constraints {
+	PERF_SAMPLE_IP_ARBITRARY_SKID,
+	PERF_SAMPLE_IP_CONSTANT_SKID,
+	PERF_SAMPLE_IP_REQUEST_NOSKID,
+
+	/*
+	 *  The PEBS implementation now supports up to 2.
+	 */
+	PERF_SMAPLE_IP_CONSTRAINT_MAX,
+};
+
 /*
  * Ioctls that can be done on a perf event fd:
  */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 928918b..55567ec 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -775,7 +775,10 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	attr->exclude_user   = eu;
 	attr->exclude_kernel = ek;
 	attr->exclude_hv     = eh;
-	attr->precise_ip     = precise;
+	if ( precise < PERF_SMAPLE_IP_CONSTRAINT_MAX )
+		attr->precise_ip = precise;
+	else
+		return -EOPNOTSUPP;
 
 	return 0;
 }

-----Original Message-----
From: Arnaldo Carvalho de Melo [mailto:acme@redhat.com] 
Sent: Wednesday, October 19, 2011 10:15 PM
To: Xu, Anhua
Cc: Peter Zijlstra; Ingo Molnar; linux-kernel@vger.kernel.org
Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong parameter

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
