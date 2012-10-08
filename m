Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2JHRRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:17:55 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39227 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2JHRRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:17:52 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/12] perf kvm: Add live mode for analyzing events
Date: Mon,  8 Oct 2012 11:17:24 -0600
Message-Id: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf kvm stat currently requires back to back record and report
commands to see stats. e.g.,

  perf kvm stat record -p $pid -- sleep 1
  perf kvm stat report

This is rather inconvenvient for on box monitoring of a VM. This
patch introduces a 'live' mode that in effect combines the record
plus report into one command. e.g., to monitor a single VM:
 
  perf kvm stat live -p $pid

Same stats options for the record+report path work with the live mode.
Display rate defaults to 1 and can be changed using the -d option.

The command works fine for low event rates, but as the number of events
increases (e.g., building a kernel in a 4-vcpu VM or nested virtualization)
the ordered samples code is failing. e.g,

  ...
  Total Samples:76309, Total events handled time:1121314.04us.

  Warning: Timestamp below last timeslice flush
  Failed to process event

This is on a 16-cpu server. For the kernel build in a 4 vcpu VM I am seeing on
the order of 50,000+ events per second and in the case of nested virtualization
(at least this one use case) I am seeing on the order of 100,000+ events per
second. Not surprising it's having problems keeping up.

I'll continue poking around the ordered samples code, but wanted to kick
this out in case someone has ideas or objections to the approach.

David Ahern (12):
  perf evlist: restore some methods removed in an earlier cleanup
  perf evlist: move tracepoint processing code to evlist.c
  perf evlist: add initialzation function for tracepoints
  perf session: export a few functions for event processing
  perf top: move CONSOLE_CLEAR to header file
  perf kvm: remove typecast in init_kvm_event_record
  perf kvm: handle realloc failures
  perf kvm: add braces around multi-line statements
  perf kvm: split out tracepoints from record args
  perf kvm: total count is a u64, print as so
  perf kvm: only process events for vcpus of interest
  perf kvm: add live mode

 tools/perf/builtin-kvm.c  |  717 ++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-top.c  |    2 -
 tools/perf/util/evlist.c  |  120 ++++++++
 tools/perf/util/evlist.h  |   10 +
 tools/perf/util/header.c  |   39 ---
 tools/perf/util/session.c |   15 +-
 tools/perf/util/session.h |    9 +
 tools/perf/util/top.h     |    2 +
 8 files changed, 819 insertions(+), 95 deletions(-)

-- 
1.7.10.1

