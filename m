Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1AOCC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 21:02:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56949 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1AOCC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 21:02:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:x-system-of-record;
	b=qznRZuRJOwjPCCT9LdruhhQe0ygBEZNTXyvmSauPGxvxp3PSXKCWYB4djSGbLGBw1
	Lc3oAxPc7x61bAFKhIJrQ==
Message-Id: <20110115015749.692623529@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 14 Jan 2011 17:57:49 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [wake_afine fixes/improvements 0/3] Introduction
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been looking at the wake_affine path to improve the group scheduling case
(wake affine performance for fair group sched has historically lagged) as well
as tweaking performance in general.

The current series of patches is attached, the first of which should probably be
considered for 2.6.38 since it fixes a bug/regression in the case of waking up
onto a previously (group) empty cpu.  While the others can be considered more
forwards looking.

I've been using an rpc ping-pong workload which is known be sensitive to poor affine 
decisions to benchmark these changes, I'm happy to run these patches against
other workloads.  In particular improvements on reaim have been demonstrated,
but since it's not as stable a benchmark the numbers are harder to present in
a representative fashion.  Suggestions/pet benchmarks greatly appreciated
here.

Some other things experimented with (but didn't pan out as a performance win):
- Considering instantaneous load on prev_cpu as well as current_cpu
- Using more gentle wl/wg values to reflect that they a task's contribution to
load_contribution is likely less than its weight.

Performance:

(througput is measured in txn/s across a 5 minute interval, with a 30 second 
warmup)

tip (no group scheduling):
throughput=57798.701988 reqs/sec.
throughput=58098.876188 reqs/sec.

tip: (autogroup + current shares code and associated broken effective_load)
throughput=49824.283179 reqs/sec.
throughput=48527.942386 reqs/sec.

tip (autogroup + old tg_shares code): [parity goal post]
throughput=57846.575060 reqs/sec.
throughput=57626.442034 reqs/sec.

tip (autogroup + effective_load rewrite):
throughput=58534.073595 reqs/sec.
throughput=58068.072052 reqs/sec.

tip (autogroup + effective_load + no affine moves for hot tasks):
throughput=60907.794697 reqs/sec.
throughput=61208.305629 reqs/sec.

Thanks,

- Paul



