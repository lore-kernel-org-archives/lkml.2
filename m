Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab2DPKpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:45:16 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58385 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2DPKpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:45:13 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: [PATCH -V6 00/14] memcg: Add memcg extension to control HugeTLB allocation
Date: Mon, 16 Apr 2012 16:14:37 +0530
Message-Id: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
x-cbid: 12041610-4790-0000-0000-00000233E277
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements a memory controller extension to control
HugeTLB allocations. The extension allows to limit the HugeTLB
usage per control group and enforces the controller limit during
page fault. Since HugeTLB doesn't support page reclaim, enforcing
the limit at page fault time implies that, the application will get
SIGBUS signal if it tries to access HugeTLB pages beyond its limit.
This requires the application to know beforehand how much HugeTLB
pages it would require for its use.

The goal is to control how many HugeTLB pages a group of task can
allocate. It can be looked at as an extension of the existing quota
interface which limits the number of HugeTLB pages per hugetlbfs
superblock. HPC job scheduler requires jobs to specify their resource
requirements in the job file. Once their requirements can be met,
job schedulers like (SLURM) will schedule the job. We need to make sure
that the jobs won't consume more resources than requested. If they do
we should either error out or kill the application.

Patches are on top of

git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5

Changes from V5:
 * Address review feedback.

Changes from V4:
 * Add support for charge/uncharge during page migration
 * Drop the usage of page->lru in unmap_hugepage_range.

Changes from v3:
 * Address review feedback.
 * Fix a bug in cgroup removal related parent charging with use_hierarchy set

Changes from V2:
* Changed the implementation to limit the HugeTLB usage during page
  fault time. This simplifies the extension and keep it closer to
  memcg design. This also allows to support cgroup removal with less
  complexity. Only caveat is the application should ensure its HugeTLB
  usage doesn't cross the cgroup limit.

Changes from V1:
* Changed the implementation as a memcg extension. We still use
  the same logic to track the cgroup and range.

Changes from RFC post:
* Added support for HugeTLB cgroup hierarchy
* Added support for task migration
* Added documentation patch
* Other bug fixes

-aneesh


