Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab1IYIzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 04:55:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35380 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1IYIzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 04:55:43 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 0/5] Reduce cross CPU IPI interference
Date: Sun, 25 Sep 2011 11:54:45 +0300
Message-Id: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have lots of infrastructure in place to partition a multi-core system such 
that we have a group of CPUs that are dedicated to specific task: cgroups, 
scheduler and interrupt affinity and cpuisol boot parameter. Still, kernel 
code will some time interrupt all CPUs in the system via IPIs for various 
needs. These IPIs are useful and cannot be avoided altogether, but in certain 
cases it is possible to interrupt only specific CPUs that have useful work to 
do and not the entire system.

This patch set, inspired by discussions with Peter Zijlstra and Frederic 
Weisbecker when testing the nohz task patch set, is a first stab at trying to 
explore doing this by locating the places where such global IPI calls are 
being made and turning a global IPI into an IPI for a specific group of CPUs. 
The purpose of the patch set is to get  feedback if this is the right way to 
go for dealing with this issue and indeed, if the issue is even worth dealing 
with at all.

This first version creates an on_each_cpu_mask infrastructure API (derived from 
existing arch specific versions in Tile and Arm) and uses it to turn two global 
IPI invocation to per CPU group invocations.

The patch is against 3.1-rc4 and was compiled for x86 and arm in both UP and 
SMP mode (I could not get Tile to build, regardless of this patch) and was 
further tested by running hackbench on x86 in SMP mode in a 4 CPUs VM. No
obvious regression where noted, but I obviously did not test this quite enough.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-mm@kvack.org
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>

 Ben-Yossef (5):
  Introduce a generic on_each_cpu_mask function
  Move arm over to generic on_each_cpu_mask
  Move tile to use generic on_each_cpu_mask
  Only IPI CPUs to drain local pages if they exist
  slub: only IPI CPUs that have per cpu obj to flush

 arch/arm/kernel/smp_tlb.c   |   20 ++++------------
 arch/tile/include/asm/smp.h |    7 -----
 arch/tile/kernel/smp.c      |   19 ---------------
 include/linux/smp.h         |   14 +++++++++++
 kernel/smp.c                |   20 ++++++++++++++++
 mm/page_alloc.c             |   53 +++++++++++++++++++++++++++++++++++-------
 mm/slub.c                   |   15 +++++++++++-
 7 files changed, 97 insertions(+), 51 deletions(-)

