Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0ILUcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:32:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39395 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab0ILUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:31:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=w2F9dc4tMmPaObVabuLmMdSY6/ix105y078m/GYKLcpXry5AwHnAmGa+T8V0sswhQ
	UvWLpLGn014viQ6Eu9dQw==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com,
        kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 0/5] writeback: kernel visibility
Date: Sun, 12 Sep 2010 13:30:35 -0700
Message-Id: <1284323440-23205-1-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch #1 sets up some helper functions for account_page_dirty and fixes
a bug in ceph

Patch #2 sets up some helper functions for account_page_writeback

Patch #3 adds writeback visibility in /proc/vmstat

To help developers and applications gain visibility into writeback
behaviour this patch adds two counters to /proc/vmstat.

  # grep nr_dirtied /proc/vmstat
  nr_dirtied 3747
  # grep nr_written /proc/vmstat
  nr_written 3618

These entries allow user apps to understand writeback behaviour over
time and learn how it is impacting their performance. Currently there
is no way to inspect dirty and writeback speed over time. It's not
possible for nr_dirty/nr_writeback.

These entries are necessary to give visibility into writeback
behaviour. We have /proc/diskstats which lets us understand the io in
the block layer. We have blktrace for more in depth understanding. We have
e2fsprogs and debugsfs to give insight into the file systems behaviour,
but we don't offer our users the ability understand what writeback is
doing. There is no way to know how active it is over the whole system,
if it's falling behind or to quantify it's efforts. With these values
exported users can easily see how much data applications are sending
through writeback and also at what rates writeback is processing this
data. Comparing the rates of change between the two allow developers
to see when writeback is not able to keep up with incoming traffic and
the rate of dirty memory being sent to the IO back end. This allows
folks to understand their io workloads and track kernel issues. Non
kernel engineers at Google often use these counters to solve puzzling
performance problems.

Patch #4 adds a pernode vmstat file with nr_dirtied and nr_written

Patch #5 add writeback thresholds to /proc/vmstat

Currently these values are in debugfs. But they should be promoted to
/proc since they are useful for developers who are writing databases
and file servers and are not debugging the kernel.

The output is as below:

 # grep threshold /proc/vmstat
 nr_pages_dirty_threshold 409111
 nr_pages_dirty_background_threshold 818223

Michael Rubin (5):
  mm: exporting account_page_dirty
  mm: account_page_writeback added
  writeback: nr_dirtied and nr_written in /proc/vmstat
  writeback: Adding /sys/devices/system/node/<node>/vmstat
  writeback: Reporting dirty thresholds in /proc/vmstat

 drivers/base/node.c    |   14 ++++++++++++++
 fs/ceph/addr.c         |    8 +-------
 fs/nilfs2/segment.c    |    2 +-
 include/linux/mm.h     |    1 +
 include/linux/mmzone.h |    4 ++++
 mm/page-writeback.c    |   16 +++++++++++++++-
 mm/vmstat.c            |    7 +++++++
 7 files changed, 43 insertions(+), 9 deletions(-)

