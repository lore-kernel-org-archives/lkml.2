Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0GAPyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:54:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47040 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab0GAPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:04 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 00/21] RAS daemon prototype, v1
Date: Thu,  1 Jul 2010 17:55:42 +0200
Message-Id: <1277999763-20357-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

(resubmitting since lkml wasn't on CC list)

Hi guys,

here's the first rough version of all the jerky code that attempts to
implement a RAS daemon listening for MCEs using perf. This is a preview
code only, I still need to figure out how to do the sample parsing
the easiest and flesh out the daemon functionality a bit more. Also,
I wanted to reuse as much code as possible therefore a lot had to be
reengineered with the perf tool and all its library-like compilation
units.

With this, you can do

make perf

or

make ras

and build the respective tool.

Even though I tried to split the patchset for easier review, please bear
in mind that there are some fat guys there (241K is the biggest one).
However, they don't do anything special except moving code around. As
such, they might not appear on lkml due to vger size constraints so I've
upped the whole patchset also at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-v1

The patchset is based on tip/perf/core from last week. Here are some
more details to some of the patches individually:

2: enables the mce tracepoint unconditionally. I had a problem with
perf_event_attr.sample_period which is checked in perf_swevent_add().
Currently, I'm setting it to ULLONG_MAX but this is icky. I'd much
rather have the check do something like

	if (event->type != PERF_EVENT_TYPE_PERSISTENT)
		if (!hwc->sample_period)
			return;

or similar.

4: sys_perf_event_open needs to know about already allocated and
enabled events.

5-10: carves out a bunch of generic perf compilation units into a common
lib. Split into 5 patches for easier review.

12-14: those are pulled in when exporting parse_events.c for external use.

16: lib/perf/misc.c contains functions and global variables like
pager_in_use() or perf_guest or usage_with_options() which are used in
generic utilities but are strictly perf-specific. Long term we should
strive in making the library self-contained and getting rid of those.

19-20: those are only needed for testing, they'll go in over the edac
tree in the next merge window. Added for completeness here.

21: only bare-bones implementation, needs a lot of fleshing out

Anyways, please have a look and let me know either way :)

Thanks,
Boris.
