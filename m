Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab0I3EDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:03:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:11196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab0I3EDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:03:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,257,1283756400"; 
   d="scan'208";a="662548207"
From: "Wu, Xia" <xia.wu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 30 Sep 2010 12:02:24 +0800
Subject: unnecessary timer interrupt of slab.c and bdi tasks when the system
 is in sleep state
Thread-Topic: unnecessary timer interrupt of slab.c and bdi tasks when the
 system is in sleep state
Thread-Index: ActgVEnT01fHIvVUTSu1KnDWt0lFCA==
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF221878E11F@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I found some unnecessary timer interrupts when the system enter sleep state.
(1) /mm/slab.c
   cache_reap() clean up on allocated memory every 2s. If the system is in sleep state, the system is waked-up when this timer expires. In fact,
   there isn't more slabs to been cleaned up in sleep state. 
   
(2) /mm/backing-dev.c and /fs/fs-writeback.c
   fs-writeback.c and backing-dev.c define a set of bdi tasks which write back dirty date to the file-system. These tasks typically runs 
   every 5 seconds even there isn't any dirty date in memory. These tasks call schedule_timeout () and schedule_timeout_interruptible().
   In fact, there isn't any dirty data in memory when the system is in sleep state. 

I think these timers should not wake-up the system when the system is in sleep state. In these cases, these timers only waste the CPU resource
and consume more power.

Regards
xia

