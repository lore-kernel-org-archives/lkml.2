Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0JTKcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:32:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:36012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0JTKcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:32:46 -0400
Subject: Re: [PATCH] perf_events: fix the fix for transaction recovery in
 group_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <4cbe1191.8709d80a.1d10.ffff9970@mx.google.com>
References: <4cbe1191.8709d80a.1d10.ffff9970@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 12:32:25 +0200
Message-ID: <1287570745.2703.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 23:45 +0200, Stephane Eranian wrote:
> This patch fixes the group_sched_in() fix added by commit 8e5fc1a.
> Although the patch solved the issue with time_running, time_enabled
> for all events in a group, it had one flaw in case the group could
> never be scheduled. It would cause time_enabled to get negative.
> The issue was that tstamp_stopped was never updated, even though
> tstamp_enabled was.
> 
> This new version is much simpler and ensures that in case of
> error in group_sched_in() during event_sched_in(), the events up
> to the failed event go through regular event_sched_out(). But the
> failed event and the remaining events in the group have their timings
> adjusted as if they had also gone through event_sched_in() and
> event_sched_out(). This ensures timing uniformity across all
> events in a group. This also takes care of the tstamp_stopped problem
> in case the group could never be scheduled. The tstamp_stopped is
> updated as if the event had actually run.
> 
> With this patch, the following now reports correct time_enabled,
> in case the NMI watchdog is active:

Hehe, good thing I didn't tag that commit as stable then.. ;-)

Could you respin this one as two patches, one a clean revert and two the
proper fix? That way its clearer what the actual change is and it eases
backporting..
