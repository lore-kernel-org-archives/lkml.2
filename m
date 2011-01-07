Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1AGQjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:39:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:40007 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1AGQjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:39:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,289,1291622400"; 
   d="scan'208";a="644537596"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        suresh.b.siddha@intel.com
Cc: yong.y.wang@linux.intel.com, joe@perches.com, jbaron@redhat.com,
        arjan@linux.intel.com, trenn@suse.de, kent.liu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH v2 0/2] apic: Fix error interrupt report at all APs when boot 
Date: Sat,  8 Jan 2011 00:36:42 +0800
Message-Id: <1294418204-15587-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, customer report that once machine boot, there are many error interrupt
reported with exact number of all APs. 

The root cause is Local APIC will generate error interrupt when it detect
the illegal vector (one in 0 ~ 15) in an interrupt message received or
interrupt generate from local vector table or self IPI. SDM3A.chapter 10.

AP LAPIC thermal sensor register will be reset to 0x10000, if thermal throttling
interrupt take over by BIOS, it need restore AP with the thermal sensor register
value of geting from BSP, otherwise cause system issue. If BIOS does not take
over the thermal interrupt, The restore value will be CPU rest value of 0x10000,
which means the interrupt vector is zero. After writing 0x10000 to thermal
sensor LVT, the processor will recieve the error interrupt report if the APIC
error interrupt is also set.

This patch add check the BIOS whether take over the thermal interrupt by look
at interrupt delivery mode not fixed mode(BIOS handle will be SMI mode) before
restore AP's thermal LVT. So the agony noise of error interrupt will dismiss
when boot on machine that BIOS does not handle thermal interrupt..  

Also add print out error interrupt reason debug information.

