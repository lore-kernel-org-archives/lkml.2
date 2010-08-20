Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0HTJec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:34:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0HTJea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:34:30 -0400
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Lin, Ming M" <ming.m.lin@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1282268675.5181.1608.camel@rui>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <20100818124116.GA17957@console-pimps.org>
	 <1282188497.11858.94.camel@minggr.sh.intel.com>
	 <1282208521.1926.4535.camel@laptop>  <1282268675.5181.1608.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 11:34:15 +0200
Message-ID: <1282296855.2605.724.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 09:44 +0800, Zhang Rui wrote:
> On Thu, 2010-08-19 at 17:02 +0800, Peter Zijlstra wrote:

> > its some obscure perf feature:
> > 
> >  leader = sys_perf_event_open(&hrtimer_attr, pid, cpu, 0, 0);
> >  sibling = sys_perf_event_open(&rapl_attr, pid, cpu, leader, 0);
> > 
> > will create an even group (which means that both events require to be
> > co-scheduled). If you then provided:
> > 
> > hrtimer_attr.read_format |= PERF_FORMAT_GROUP;
> > hrtimer_attr.sample_type |= PERF_SAMPLE_READ;
> > 
> hrtimer_attr is only shared in an event group, and rapl needs its owen
> event group, right?

Uhm, no. The idea is to group the hrtimer and rapl event in order to
obtain rapl 'samples'.

That is, you get hrtimer samples which include the rapl count. For this
we use the grouping construct where group siblings are always
co-scheduled and can report on each others count.

> so what do you think the rapl counter should look like in userspace?
> showing it in perf-stat looks nice, right? :)

Right, so the userspace interface would be using Lin's sysfs bits, which
I still need to read up on. But the general idea is that each PMU gets a
sysfs representation somewhere in the system topology reflecting its
actual site (RAPL would be CPU local), this sysfs representation would
then also allow you to discover all events it provides.

perf list will then use sysfs to discover all available events, and you
can still use perf stat -e $foo to select it, where foo is some to be
determined string that identifies the thing, maybe something like:
rapl:watts or somesuch (with rapl identifying the pmu and watts the
actual event for that pmu).



