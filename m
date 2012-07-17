Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2GQJEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:04:02 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34095 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2GQJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:04:00 -0400
Message-ID: <50052A78.6000407@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 17:03:52 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        paul@paulmenage.org
Subject: [PATCH 0/5] cpusets: dynamical scheduler domain flags
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071709-2000-0000-0000-0000084C2394
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch set provide a way for user to dynamically configure the scheduler
domain flags, which usually to be static.

We can do the configuration through cpuset cgroup, new file will be found
under each hierarchy:

sched_smt_domain_flag
	-- appear when CONFIG_SCHED_SMT enabled, stands for the domain flags
	   of cpuset on smt level
	
sched_mc_domain_flag
	-- appear when CONFIG_SCHED_MC enabled, stands for the domain flags
	   of cpuset on mc level

sched_book_domain_flag
	-- appear when CONFIG_SCHED_BOOK enabled, stands for the domain flags
	   of cpuset on book level

sched_cpu_domain_flag
	-- stands for the domain flags of cpuset on cpu level

sched_enable_domain_flag
	-- set to 1 if want to use the dynamical domain flags, domain will
	   be rebuild

Examples:

Currently the domain flags bit are:
#define SD_LOAD_BALANCE         0x0001  /* Do load balancing on this domain. */
#define SD_BALANCE_NEWIDLE      0x0002  /* Balance when about to become idle */
#define SD_BALANCE_EXEC         0x0004  /* Balance on exec */
#define SD_BALANCE_FORK         0x0008  /* Balance on fork, clone */
#define SD_BALANCE_WAKE         0x0010  /* Balance on wakeup */
#define SD_WAKE_AFFINE          0x0020  /* Wake task to waking CPU */
#define SD_PREFER_LOCAL         0x0040  /* Prefer to keep tasks local to this domain */
#define SD_SHARE_CPUPOWER       0x0080  /* Domain members share cpu power */
#define SD_SHARE_PKG_RESOURCES  0x0200  /* Domain members share cpu pkg resources */
#define SD_SERIALIZE            0x0400  /* Only a single load balancing instance */
#define SD_ASYM_PACKING         0x0800  /* Place busy groups earlier in the domain */
#define SD_PREFER_SIBLING       0x1000  /* Prefer to place tasks in a sibling domain */
#define SD_OVERLAP              0x2000  /* sched_domains of this level overlap */
#define SD_NUMA                 0x4000  /* cross-node balancing */

If we want to set SMT domain to be:
	'SD_LOAD_BALANCE | SD_BALANCE_WAKE | SD_OVERLAP'
and other level domain only has SD_LOAD_BALANCE, then we can use:
	echo 0x1011 > /sys/fs/cgroup/cpuset/cpuset.sched_smt_domain_flag
	echo 0x1 > /sys/fs/cgroup/cpuset/cpuset.sched_mc_domain_flag
	echo 0x1 > /sys/fs/cgroup/cpuset/cpuset.sched_book_domain_flag
	echo 0x1 > /sys/fs/cgroup/cpuset/cpuset.sched_cpu_domain_flag
	echo 1 > /sys/fs/cgroup/cpuset/cpuset.sched_enable_domain_flag

including:
	cpusets: add basic variables
	cpusets: add functions and code for initialization
	cpusets: enable the dynamical domain flags
	cpusets: add fundamental functions for recording
	cpusets: add the configuration facility
		
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 b/include/linux/sched.h |   22 ++++++++
 b/kernel/cpuset.c       |    7 ++
 b/kernel/sched/core.c   |    2 
 include/linux/sched.h   |   10 ++-
 kernel/cpuset.c         |  131 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c     |   10 +++
 6 files changed, 176 insertions(+), 6 deletions(-)

