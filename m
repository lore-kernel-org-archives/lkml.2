Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2E3MY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab2E3MYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:24:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com
Subject: [PATCHv5 0/3] perf, tool: Fix endian issues
Date: Wed, 30 May 2012 14:23:41 +0200
Message-Id: <1338380624-7443-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fixies to properly handle perf.data endians.

This patchset contains 3 updated patches with comments from David.

I can see still some discrepancies when reporting data on target
and origin system. It's not related to endianity but to kallsyms
symbols processing and deserves another patchset.

There's another David's fix that needs to be taken as well:
http://marc.info/?l=linux-kernel&m=133770186330032&w=2

v5 changes:
  - patch 1/3 s/DSO__READ/DSO__SWAP/
  - updated all changelogs with perf report diff example

v4 changes:
  - fixed patch 6/7 which was broken for -fstrict-aliasing related optimization
  - added patch 3/7 and 7/7

v3 changes:
  - added patch 5 to fix addons bitmask handling

v2 changes:
  - added patches 3 and 4 to handle sample_id_all header endianity


Attached patches:
  1/3 perf, tool: Handle different endians properly during symbol load
  2/3 perf, tool: Handle endianity swap on sample_id_all header data
  3/3 perf, tool: Fix 32 bit values endianity swap for sample_id_all header


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
---
 tools/perf/util/evsel.c   |   29 +++++++++++++++-----
 tools/perf/util/session.c |   67 +++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.c  |   33 +++++++++++++++++++++-
 tools/perf/util/symbol.h  |   30 ++++++++++++++++++++
 4 files changed, 139 insertions(+), 20 deletions(-)
