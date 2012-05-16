Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab2EPG71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759129Ab2EPG7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:59:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Caspar Zhang <czhang@redhat.com>
Subject: [PATCHv4 0/7] perf, tool: Fix endian issues
Date: Wed, 16 May 2012 08:59:01 +0200
Message-Id: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fixies to properly handle perf.data endians.

David,
could you please rerun your test? I tried it on my setup and
it works fine.


v4 changes:
  - fixed patch 6/7 which was broken for -fstrict-aliasing related optimization
  - added patch 3/7 and 7/7

v3 changes:
  - added patch 5 to fix addons bitmask handling

v2 changes:
  - added patches 3 and 4 to handle sample_id_all header endianity


Attached patches:
  1/7 perf, tool: Handle different endians properly during symbol load
  2/7 perf, tool: Carry perf_event_attr bitfield throught different endians
  3/7 perf, tool: Add union u64_swap type for swapping u64 data
  4/7 perf, tool: Handle endianity swap on sample_id_all header data
  5/7 perf, tool: Fix 32 bit values endianity swap for sample_id_all header
  6/7 perf, tool: Fix endianity trick for adds_features bitmask
  7/7 perf, tool: Fix callchain ip printf


Tested by running following usecases:
test 1)
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

test 2)
  - origin system:
    # perf record -ag -fo /tmp/perf.data -- sleep 1
  - mount origin system root to the target system on /mnt/origin
  - target system:
    # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
     --kallsyms /mnt/origin/proc/kallsyms
  - complete perf.data header is displayed 

test 3)
  - tested with old perf.data version, worked proplerly

Tested by above usecase cross following architectures:
  i386, x86_64, s390x, ppc64, ppc32

Big thank to Caspar Zhang who verified this within RH QE testsuites.

thanks,
jirka

CC: Caspar Zhang <czhang@redhat.com>
---
 tools/perf/util/evsel.c                |   39 ++++++++-----
 tools/perf/util/header.c               |   21 +++++--
 tools/perf/util/hist.c                 |    2 +-
 tools/perf/util/include/linux/bitops.h |    1 +
 tools/perf/util/session.c              |  101 ++++++++++++++++++++++++++++----
 tools/perf/util/symbol.c               |   33 ++++++++++-
 tools/perf/util/symbol.h               |   30 +++++++++
 tools/perf/util/types.h                |    5 ++
 8 files changed, 198 insertions(+), 34 deletions(-)
