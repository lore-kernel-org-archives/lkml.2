Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2FIJAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:00:22 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48411 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2FIJAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:00:18 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: [PATCH -V8 00/16] hugetlb: Add HugeTLB controller to control HugeTLB allocation
Date: Sat,  9 Jun 2012 14:29:45 +0530
Message-Id: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
x-cbid: 12060909-2000-0000-0000-000007DBE087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements a cgroup resource controller for HugeTLB
pages. The controller allows to limit the HugeTLB usage per control
group and enforces the controller limit during page fault. Since
HugeTLB doesn't support page reclaim, enforcing the limit at page
fault time implies that, the application will get SIGBUS signal if
it tries to access HugeTLB pages beyond its limit. This requires
the application to know beforehand how much HugeTLB pages it would
require for its use.

The goal is to control how many HugeTLB pages a group of task can
allocate. It can be looked at as an extension of the existing quota
interface which limits the number of HugeTLB pages per hugetlbfs
superblock. HPC job scheduler requires jobs to specify their resource
requirements in the job file. Once their requirements can be met,
job schedulers like (SLURM) will schedule the job. We need to make sure
that the jobs won't consume more resources than requested. If they do
we should either error out or kill the application.

Changes from V7:
  * Remove dependency on page cgroup.
  * Use page[2].lru.next to store HugeTLB cgroup information.

Changes from V6:
 * Implement the controller as a seperate HugeTLB cgroup.
 * Folded fixup patches in -mm to the original patches

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


