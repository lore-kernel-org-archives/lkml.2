Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1EFVmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:42:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:15391 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906Ab1EFVlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:41:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="743486011"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Mason <chris.mason@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: RFC: Lower broadcast timer idle path lock contention
Date: Fri,  6 May 2011 14:40:52 -0700
Message-Id: <1304718056-20206-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit implements some ideas discussed in the earlier thread
to lower the lock contention of the broadcast state idle path:

- Do check for good C3 timer outside the lock
[Already in tip, but I'm including it to have a full patchkit]
- Change the global bitmask to avoid false sharing
- Exploit that thread siblings keep the timer alive
[This patch is unfortunately quite hairy and needs very indepth review]
This uses a lock, but only a local one for a core.
- Only take the global lock when the timeout of the broadcast device
is set earlier.

Longer term the global lock likely still needs to be eliminated, but 
this at least makes it less pressing.

Comments/testing welcome. I didn't do a lot of scalability testing so far,
just ran a stress tester to make sure I didn't miss some case.

-Andi

