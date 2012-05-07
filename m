Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab2EGLam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:30:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab2EGL32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:29:28 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Caspar Zhang <czhang@redhat.com>
Subject: [PATCHv3 0/5] perf, tool: Fix endian issues
Date: Mon,  7 May 2012 13:29:04 +0200
Message-Id: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fixies to properly handle perf.data endians.

v3 changes:
  - added patch 5 to fix addons bitmask handling

v2 changes:
  - added patches 3 and 4 to handle sample_id_all header endianity


Attached patches:
  1/5 perf, tool: Handle different endians properly during symbol load
  2/5 perf, tool: Carry perf_event_attr bitfield throught different endians
  3/5 perf, tool: Handle endianity swap on sample_id_all header data
  4/5 perf, tool: Fix 32 bit values endianity swap for sample_id_all header
  5/5 perf, tool: Fix endianity trick for adds_features bitmask


Tested by running following usecase:
  - origin system:
    # perf record -a -- sleep 10 (any perf record will do)
    # perf report > report.origin
    # perf archive perf.data
    
  - copy the perf.data, report.origin and perf.data.tar.bz2
    to a target system and run:
    # tar xjvf perf.data.tar.bz2 -C ~/.debug
    # perf report > report.target
    # diff -u report.origin report.target
    
  - the diff should produce no output
    (besides some white space stuff and possibly different
     date/TZ output)

Tested by above usecase cross following architectures:
  i386, x86_64, s390x, ppc64

Big thank to Caspar Zhang who verified this within RH QE testsuites.

thanks,
jirka

CC: Caspar Zhang <czhang@redhat.com>
---
 tools/perf/util/evsel.c                |   32 ++++++++--
 tools/perf/util/header.c               |   20 +++++--
 tools/perf/util/include/linux/bitops.h |    1 +
 tools/perf/util/session.c              |  101 ++++++++++++++++++++++++++++----
 tools/perf/util/symbol.c               |   33 ++++++++++-
 tools/perf/util/symbol.h               |   30 +++++++++
 6 files changed, 192 insertions(+), 25 deletions(-)
