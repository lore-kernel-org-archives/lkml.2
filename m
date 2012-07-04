Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab2GDMCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2GDMC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:02:26 -0400
Date: Wed, 4 Jul 2012 14:01:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
Message-ID: <20120704120155.GE960@krava.redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
 <1341397330.2507.85.camel@laptop>
 <1341398311.2507.98.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341398311.2507.98.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 12:38:31PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-07-04 at 12:22 +0200, Peter Zijlstra wrote:
> > How about something like:
> > 
> >  u64 config = x86_pmu.event_map(_id);
> >  u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
> >              (config & AMD64_EVENTSEL_EVENT) >> 24;
> >  u64 umask = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> > 
> >  WARN_ON_ONCE(config & (ARCH_PERFMON_EVENTSEL_INV |
> >                         ARCH_PERFMON_EVENTSEL_CMASK));
> > 
> >  sprintf("event=0x%02llx,umask=0x%02llx\n", event, umask); 
> 
> Oh wait, silly me, we actually need the inv and cmask too.
> 
> So that gets to be something like:
> 
>   u64 config = x86_pmu.event_map(_id);
>   u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
>               (config & AMD64_EVENTSEL_EVENT) >> 24;
>   u64 umask = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>   u64 inv   = (config & ARCH_PERFMON_EVENTSEL_INV) >> 23;
>   u64 cmask = (config & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
>   ssize_t ret;
> 
>   ret = sprintf(page, "event=0x%02llx", event);
>   if (umask)
>     ret += sprintf(page + ret, ",umask=0x%02llx", umask);
>   if (inv)
>     ret += sprintf(page + ret, ",inv");
>   if (cmask)
>     ret += sprintf(page + ret, ",cmask=0x%02llx", cmask);
>   sprintf(page + ret, "\n");
>  
>   return ret;
> 

ok
