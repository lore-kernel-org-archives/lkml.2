Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab0FRAA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 20:00:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:25883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760909Ab0FRAAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 20:00:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,434,1272870000"; 
   d="scan'208";a="527954621"
Subject: [PATCH v3 0/2] tmpfs: Improve tmpfs scalability
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>, yanmin.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 16:56:28 -0700
Message-ID: <1276818988.9661.80.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series helps to resolve scalability problem
for tmpfs.  With these patches, Aim7 fserver throughput for tmpfs
improved by 270% on a 4 socket, 32 cores NHM-EX system.

In current implementation of tmpfs, whenever we
get a new page, stat_lock in shmem_sb_info needs to be acquired.  
This causes a lot of lock contentions when multiple
threads are using tmpfs simultaneously, which makes
system with large number of cpus scale poorly.
Almost 75% of cpu time was spent contending on
stat_lock when we ran Aim7 fserver load with 128 threads
on a 4 socket, 32 cores NHM-EX system.

We made use of the percpu_counter library for used blocks accounting to
speed up the getting and returning of blocks to local per cpu counter
without lock acquisition.

The first patch in the series add a function to provide
fast but accurate comparison for the percpu_counter library. 

The second patch update the shmem code of tmpfs to use percpu_counter 
library to improve tmpfs performance.

Version 3 Changes:
1. Use percpu_counter instead of adding a new qtoken library for fast
block accounting.
2. Change accounting from free_blocks to used_blocks so we do not need
to reset percpu_counter when we remount tmpfs.


Regards,
Tim Chen




