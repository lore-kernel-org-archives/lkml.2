Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1DUPKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:10:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:39151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab1DUPKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:10:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,251,1301900400"; 
   d="scan'208";a="632092662"
Date: Thu, 21 Apr 2011 23:12:50 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de, hpa@zytor.com,
        hpa@linux.intel.com, suresh.b.siddha@intel.com,
        yong.y.wang@linux.intel.com, joe@perches.com, jbaron@redhat.com,
        trenn@suse.de, kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v4 1/2] apic: Fix error interrupt report at all APs
Message-ID: <20110422031250.GA30016@linux-youquan.bj.intel.com>
References: <1302762968-24380-1-git-send-email-youquan.song@intel.com> <20110419170121.GA6640@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419170121.GA6640@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't disagree with this change, but unfortunately the changelog is in 
> absolutely unreadable English. Please fix it or find someone who can fix it for 
> you.
> 
> I decoded and fixed the changelog of the 2/2 patch of your series so no need to 
> do it for that patch.

Thanks a lot Ingo!

Here is the fixed changelog for 1/2 patch :Fix error interrupt report at all APs

This patch fixes a bug reported from customer, who found many unreasonable error
 interrupts reported on all APs during the system boot stage. 

According to Chapter 10 of Intel Software Developer Manual Volume 3A, Local APIC
 may signal an illegal vector error when an LVT entry is set as an illegal 
vector value (0~15) under FIXED delivery mode (bits 8-11 is 0), regardless of 
whether the mask bit is set or an interrupt actually happen. These errors are 
seen as error interrupts. 

The initial value of thermal LVT entries on all APs always reads 0x10000 because
 APs are woken up by BSP issuing INIT-SIPI-SIPI sequence to them and LVT 
registers are reset to 0s except for the mask bits which are set to 1s when APs 
receive INIT IPI.  When BIOS take over the thermal throttling interrupt, LVT 
thermal deliver mode should be SMI and it is required to restore AP's LVT 
thermal monitor register. 

This issue happens when BIOS do not take over thermal throttling interrupt, 
AP's LVT thermal monitor register will be restored to 0x10000 which means vector
 0 and fixed deliver mode, so all APs will signal illegal vector error 
interrupt.  This patch check if interrupt delivery mode is not fixed mode before
 restore AP's LVT thermal monitor register. 

-Youquan
 
