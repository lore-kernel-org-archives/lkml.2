Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2HNO7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:59:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31200 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2HNO7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:59:39 -0400
Date: Tue, 14 Aug 2012 17:59:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jyli@marvell.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [bug report] [SCSI] mvumi: GFP_KERNEL under spin lock
Message-ID: <20120814145926.GA29090@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jianyun Li,

The patch f0c568a478f0: "[SCSI] mvumi: Add Marvell UMI driver" from 
May 11, 2011, leads to the following warning:
drivers/scsi/mvumi.c:121 mvumi_alloc_mem_resource()
	 error: scheduling with locks held: 'spin_lock:host_lock'

The problem is that we do a couple GPF_KERNEL allocations in
mvumi_alloc_mem_resource() and this static analysis program sees a path
where that function is called with spin_locks held.

mvumi_isr_handler() <- takes a spin lock
-> mvumi_handshake()
   -> mvumi_init_data()
      -> mvumi_alloc_mem_resource() <- GFP_KERNEL

The IRQ handler does print a warning before calling mvumi_handshake()
so it seems like this path doesn't get exercised very much.

regards,
dan carpenter

