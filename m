Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2HWVOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934479Ab2HWVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:13:46 -0400
Date: Thu, 23 Aug 2012 17:11:04 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ShuoX Liu <shuox.liu@intel.com>,
        mjg59@srcf.ucam.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC][PATCH 0/3] c-state governor changes
Message-ID: <20120823171104.38574add@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that the c-state governor can be a performance issue
with certain workloads.  The problem workloads seem to involve
mixed length pauses between activities, eg. an occasional long
idle period, with a burst of activity involving short idle periods.

One example of this would be a system with a web server and a
database, where the web server gets a request "every once in a
while" (compared to c-state timescales), and then quickly bounces
stuff back and forth between itself and the database, before
sending anything back to the http client.

On the face of it, the use of average sleep times does not make
a whole lot of sense, when we can have sleep patterns like this:

	150 200 50 1000 30 180 10000 220

The bulk of the sleep time is spent in the one long sleep, but
planning for a 1500us sleep time (around the average) is pretty
much guaranteed to be wrong.

Instead, it might make more sense to plan for a sleep time just
under 200us. We may still need some kind of demotion scheme to
kick us into a deeper c-state when a truly long sleep period
comes along...

This patch set is mostly there to kick off a discussion in time
for Kernel Summit.  When running it on my laptop, with acpi_idle,
I see a promising change in powertop.

Time spent in C3 has gone down from 99% of CPU time, to 97-98% CPU 
time, but the average residency time in C3 has gone up.  The other
1-2% of CPU time is spent in C2 instead.

I have not run any meaningful benchmarks against this code yet.
It has had a benchmark run where the workload presents regular
sleep intervals, and performs identically to the old code.

Please let me know what you think :)

-- 
All Rights Reversed
