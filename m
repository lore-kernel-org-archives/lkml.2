Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903Ab2CMXWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:22:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43975 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab2CMXWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:22:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        JBeulich@suse.com
Subject: [PATCH] mechanism to disable built in cpu frequency drivers/governors. (v1)
Date: Tue, 13 Mar 2012 19:18:38 -0400
Message-Id: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020B.4F5FD6C2.000E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of these patches is two-fold:
 1) Remove weird performance issues encountered in the field where the
    Linux kernel cpufreq scaling drivers would change the P-states while the
    Xen hypervisor would do the same.
 2) Provide a runtime knob from within the kernel to disable the cpu frequency
    API (akin to the behavior of "#CONFIG_CPU_CPUFREQ is not set").

The patches are based on the mechanism that Len Brown came up for the cpuidle
drivers - where there is a disable_cpuidle() call. His patches also provided
a module parameter - but I wasn't sure whether that is something you would want.
(for reference, Len's patch is d91ee5863b71e8c90eaf6035bff3078a85e2e7b5)

The other way of disabling the cpufreq scaling drivers from being invoked
is by thwarting the cpufreq drivers from loading by influencing their startup
checks.  For powernow-k8 that is easy - disallow the RDMSR (and that is currently
happening). For acpi-cpufreq I am not sure what could be done - the calls it
makes are to the ACPI libraries which we need for other uses.

Another solution I thought off was to provide a cpufreq governor that would
be a nop, and hence end up not calling the cpufreq scaling drivers. But that
just seems heavy-handed and I am not sure how the decision of when to load it
(and set it) would be done.

 arch/x86/xen/setup.c      |    1 +
 drivers/cpufreq/cpufreq.c |   24 ++++++++++++++++++++++++
 include/linux/cpufreq.h   |    2 ++
 3 files changed, 27 insertions(+), 0 deletions(-)
