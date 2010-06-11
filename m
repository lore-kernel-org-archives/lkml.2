Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0FKQaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:30:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab0FKQ36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:29:58 -0400
Subject: perf_disable()
From: Peter Zijlstra <peterz@infradead.org>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 11 Jun 2010 18:29:44 +0200
Message-ID: <1276273784.2077.2055.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been going over perf_disable() usage in kernel/perf_event.c and
wondered if we actually need it at all.

Currently the only thing we seem to require it for is around pmu::enable
calls (and for that powerpc at least does it itself, on x86 we rely on
it to call ->enable_all and reprogram the pmu state).

But I can't really find any NMI races wrt data structures or the like as
seems implied by some comments. 

There is a fun little recursion issue with perf_adjust_period(), where
if we fully removed perf_disable() we could end up calling pmu::stop()
twice and such.

But aside from that it looks to me its mostly about optimizing hardware
writes.

If nobody else known about/can find anything, I'm going to mostly remove
perf_disable() for now and later think about how to optimize the
hardware writes again.
