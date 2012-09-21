Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2IUSce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:32:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36613 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab2IUSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:26 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/10] sched: Task placement for heterogeneous MP systems
Date: Fri, 21 Sep 2012 19:32:15 +0100
Message-Id: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 21 Sep 2012 18:32:22.0991 (UTC) FILETIME=[70F5B5F0:01CD9827]
X-MC-Unique: 112092119322400901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIWiKI011328

From: Morten Rasmussen <morten.rasmussen@arm.com>

Hi Paul, Paul, Peter, Suresh, linaro-sched-sig, and LKML,

As a follow-up on my Linux Plumbers Conference talk about my experiments with
scheduling on heterogeneous systems I'm posting a proof-of-concept patch set
with my modifications. The intention behind the modifications is to tweak
scheduling behaviour to only use fast (and power hungry) cores when it is
necessary and also improve performance consistency. Without the modifications
it is more or less random where tasks are scheduled and so is the execution
time.

I'm seeing good improvements on performance consistency for web browsing on
Android using Bbench <http://www.gem5.org/Bbench> on the ARM big.LITTLE TC2
chip, which has two fast cores (Cortex-A15) and three power-efficient cores
(Cortex-A7). The total execution time numbers below are for Androids
SurfaceFlinger process is key for page rendering performance. The average
execution time is lower with the patches enabled and the standard deviation is
much smaller. Similar improvements can be seen for the Android.Browser and
WebViewCoreThread processes.

Total execution time statistics based on 50 runs.

SurfaceFlinger  SMP kernel [s]  HMP modifications [s]
------------------------------------------------------
Average         14.617          11.012
St. Dev.         4.577           0.902
10% Pctl.        9.343          10.783
90% Pctl.       18.743          11.695

Unfortunately, I cannot share power-efficiency numbers at this stage.

This patch set introduces proof-of-concept scheduler modifications which
attempt to improve scheduling decisions on heterogeneous multi-processor
systems (HMP) such as ARM big.LITTLE systems. The patch set relies on the
entity load-tracking re-work patch set by Paul Turner:

<https://lkml.org/lkml/2012/8/23/267>

The modifications attempt to migrate tasks between cores with different
compute capacity depending on the tracked load and priority. The aim is
to only use fast cores for tasks which really need the extra performance
and thereby improve power consumption by running everything else on the
slow cores.

The patch introduces hmp_domains to represent the different types of cores
that are available on the given platform. Multiple (>2) hmp_domains is
supported but not tested. hmp_domains must be set up by platform code and
the patch set includes patches for ARM platforms using device-tree.

The patches intentionally try to avoid modifying the existing code paths
as much as possible. The aim is to experiment with HMP scheduling and get
the overall policy right before integrating it properly with the existing
load-balancer.

Morten

Morten Rasmussen (10):
  sched: entity load-tracking load_avg_ratio
  sched: Task placement for heterogeneous systems based on task
    load-tracking
  sched: Forced task migration on heterogeneous systems
  sched: Introduce priority-based task migration filter
  ARM: Add HMP scheduling support for ARM architecture
  ARM: sched: Use device-tree to provide fast/slow CPU list for HMP
  ARM: sched: Setup SCHED_HMP domains
  sched: Add ftrace events for entity load-tracking
  sched: Add HMP task migration ftrace event
  sched: SCHED_HMP multi-domain task migration control

 arch/arm/Kconfig                |   46 +++++
 arch/arm/include/asm/topology.h |   32 +++
 arch/arm/kernel/topology.c      |   91 ++++++++
 include/linux/sched.h           |   11 +
 include/trace/events/sched.h    |  153 ++++++++++++++
 kernel/sched/core.c             |    4 +
 kernel/sched/fair.c             |  434 ++++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h            |    9 +
 8 files changed, 779 insertions(+), 1 deletion(-)

-- 
1.7.9.5


