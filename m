Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2FNUkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:40:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab2FNUjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:39:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/6] perf, tool: Allow to use hw events in PMU syntax
Date: Thu, 14 Jun 2012 22:38:35 +0200
Message-Id: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
here's the change to make following syntax available:
  perf stat -e cpu/event=instructions/u ls

this is identical to:
  perf stat -e instructions:u ls

The patch 1 makes PERF_TYPE_HARDWARE events translations available
by the sysfs 'events' group attribute under the PMU record.

Once we hit the PERF_TYPE_HARDWARE event mnemonic within the
PMU event term parsing like:
   'event=cycles'
we translate the 'cycles' string into specific PERF_TYPE_HARDWARE
translation and assign this value to the 'event' term value.

So given that:
  $ cat /sys/devices/cpu/events/instructions
  0xc0

following examples are identical:
  perf stat -e cpu/event=0xc0/u ls
  perf stat -e cpu/event=instructions/u ls

It feels like a hack since it relies on:
  - kernel does no more than translating the 'cycles' value and putting it
    to the 'attr.config' - I'm not sure this is allways true.
  - user uses this translation with terms that fill the attr.config same way
    as kernel does, like for 'event':
      $ cat /sys/devices/cpu/format/event
      config:0-7

    This could be ensured by perf tool.. but it smells like CPU specific again.

note, it's not tested much.. ;)

attached patches:
  1/6 perf, x86: Making hardware events tranlations sysfs available
  2/6 perf tools: Fix generation of pmu list
  3/6 perf, tool: Properly free format data
  4/6 perf, tool: Add events support for pmu
  5/6 perf, tool: event parsing - split PE_VALUE_SYM to SW and HW tokens
  6/6 perf, tool: Support translate terms for hw events

thoughts? ;)
jirka
---
 arch/x86/kernel/cpu/perf_event.c |   44 +++++++++
 tools/perf/util/parse-events.c   |    8 ++-
 tools/perf/util/parse-events.h   |    3 +
 tools/perf/util/parse-events.l   |    2 +-
 tools/perf/util/parse-events.y   |   26 +++++-
 tools/perf/util/pmu.c            |  179 ++++++++++++++++++++++++++++++++-----
 tools/perf/util/pmu.h            |    2 +
 7 files changed, 233 insertions(+), 31 deletions(-)
