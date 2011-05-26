Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab1EZTuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:50:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61822 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab1EZTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eg9jrKH4B/d7sUEKCwpME/vwt7zu/fHf7AteFijwkuqXiSWa9oCMW4lJWFTJNJgshB
         KNrqGOxSO0IeMPpBtyafC0v0FGleL0YHb2oIOG+JGlbSzt6uDu+kbIEX23yGDSAOCJbY
         FlyhG8VuPUJZkX6VlBDusF218IBJooqyq8nyM=
From: Jim Cromie <jim.cromie@gmail.com>
To: mingo@elte.hu
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perf-stat: refactor print/formatting into print-ops
Date: Thu, 26 May 2011 13:50:03 -0600
Message-Id: <1306439406-18037-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <BANLkTimJp9o5_P73eNn5rMJbfRC2sCRdJA@mail.gmail.com>
References: <BANLkTimJp9o5_P73eNn5rMJbfRC2sCRdJA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [PATCH 1/3] perf-stat: refactor print/formatting into print-ops for
 [PATCH 2/3] perf-stat: fix +- nan% in -Aa runs
 [PATCH 3/3] perf-stat: clean up <no count> handling, CPUx prefixing



[PATCH 1/3] perf-stat: refactor print/formatting into print-ops for

produces output like this for csv-output:

[jimc@harpo perf]$  sudo ./perf stat -Aa -x'\t' perl -e '$i++ for 1..100000'
CPU0	task-clock-msecs	16.255272
CPU0	context-switches	12
CPU0	CPU-migrations	0
CPU0	page-faults	445
CPU0	cycles	27441481	67.07%
CPU0	instructions	36775396	73.16%
CPU0	branches	8836245	20.72%
CPU0	branch-misses	21646	14.62%
CPU0	cache-references	58221	12.31%
CPU0	cache-misses	6815	12.28%
seconds-time-elapsed	0.016211262

This alters csv-output form by printing event-name in 1st column,
swapping cols 1, 2 from previous table.  This may be problematic for
some existing users, but is more "normal" and therefore better
long-term.  The 3rd - 5th colums match those in pretty

As before, csv-output is triggered by use of -x "sep", where sep can
be any string, not just a char.  This patch adds special case for
"\t", which is converted to a tab.

[PATCH 2/3] perf-stat: fix +- nan% in -Aa runs

without this patch, I get computations like this:

[jimc@groucho perf]$ sudo ./perf stat -r3 -Aa  perl -e '$i++ for 1..100000'

 Performance counter stats for 'perl -e $i++ for 1..100000' (3 runs):

CPU0             12.391883 task-clock-msecs         #      0.966 CPUs    ( +-    -nan% )
CPU1             12.446571 task-clock-msecs         #      0.970 CPUs    ( +-    -nan% )
CPU2             12.408014 task-clock-msecs         #      0.967 CPUs    ( +-    -nan% )
CPU3             12.422264 task-clock-msecs         #      0.968 CPUs    ( +-    -nan% )

I couldnt see anything wrong in the caller, so fixed it in stddev_stats()

[PATCH 3/3] perf-stat: clean up <no count> handling, CPUx prefixing

push <no-count> printing into print-ops to hide some cruft, and fold
away dynamic formats.  Refactor cpustr string prep into cpustr(int
cpu), use it everywhere, and change fn-sigs accordingly.

Also includes 1-line fixup for overlooked hack in earlier patch:
  -       if (scaled == -1 && !csv_output) {
  +       if (scaled == -1) {

