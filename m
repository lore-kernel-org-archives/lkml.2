Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0EZTfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:35:10 -0400
Received: from mga06.intel.com ([134.134.136.21]:51829 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755454Ab0EZTfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:35:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,305,1272870000"; 
   d="scan'208";a="521503603"
Subject: [PATCH v2 0/2] tmpfs: Improve tmpfs scalability
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:32:46 -0700
Message-ID: <1274902366.31973.9391.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We created a token jar library implementing
per cpu cache of tokens to avoid lock contentions whenever
we retrieve or return a token to a token jar.  Using this library
with tmpfs, we find Aim7 fserver throughput improved 270% 
on a 4 socket, 32 cores NHM-EX system.

In current implementation of tmpfs, whenever we
get a new page, stat_lock in shmem_sb_info needs to be acquired.  
This causes a lot of lock contentions when multiple
threads are using tmpfs simultaneously, which makes
system with large number of cpus scale poorly.
Almost 75% of cpu time was spent contending on
stat_lock when we ran Aim7 fserver load with 128 threads
on a 4 socket, 32 cores NHM-EX system.

The first patch in the series implements the quick token jar. 
The second patch update the shmem code of tmpfs to use this
library to improve tmpfs performance.

Version 2 Changes:
1. Make qtoken library callable from interrupt context
2. Change token counters to unsigned long
2. Added detailed comments of the qtoken library and interface functions
3. Fixed various styles issues in version 1
4. Update code to be cpu-hotplug-aware
5. Change return error code of interface functions to non-zero value

Regards,
Tim Chen



