Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0H3OMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:12:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:57133 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0H3OMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:12:43 -0400
Subject: Re: [RFC][PATCH 3/5] perf: Add hrtimer code for PMI-less hardware
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20100830132744.GB24828@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
	 <38d993baf1328403d9a1c4a2f012c4aa0e19feab.1283123521.git.matt@console-pimps.org>
	 <1283172902.1820.897.camel@laptop>
	 <20100830132744.GB24828@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 Aug 2010 16:12:24 +0200
Message-ID: <1283177544.1820.992.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 14:27 +0100, Matt Fleming wrote:

> I'm lost. Is it possible to do this patch entirely in userspace? How do
> we periodically sample the counters if it's not being done in the
> kernel?

perf_event_attr leader = {
 .type = PERF_TYPE_SOFTWARE,
 .config = PERF_COUNT_SW_TASK_CLOCK,
 .sample_period = xxx,
 .sample_type = PERF_SAMPLE_READ|...,
 .read_format = PERF_FORMAT_GROUP,
};

perf_event_attr counter = {
 .type = PERF_TYPE_HARDWARE,
 .config = PERF_COUNT_HW_CPU_CYCLES,
};
 
leader_fd = sys_perf_event_open(&leader, pid, cpu, 0, 0);
counter_fd = sys_perf_event_open(&counter, pid, cpu, leader_fd, 0);

Which gives you a group of 2 events, one software timer that samples,
one hardware counter that only counts.
