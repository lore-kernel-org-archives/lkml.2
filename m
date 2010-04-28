Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0D1Rff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:35:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64387 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0D1Rfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:35:33 -0400
Date: Wed, 28 Apr 2010 10:33:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] infiniband: fix cxgb4 printk format warnings
Message-Id: <20100428103356.931ba48c.randy.dunlap@oracle.com>
In-Reply-To: <20100428164341.cee2911a.sfr@canb.auug.org.au>
References: <20100428164341.cee2911a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BD871C8.0178:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in infiniband/hw/cxgb4:

drivers/infiniband/hw/cxgb4/cq.c:844: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'size_t'
drivers/infiniband/hw/cxgb4/qp.c:109: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'phys_addr_t'
drivers/infiniband/hw/cxgb4/qp.c:109: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'phys_addr_t'
drivers/infiniband/hw/cxgb4/qp.c:1407: warning: format '%lu' expects type 'long unsigned int', but argument 4 ha s type 'size_t'
drivers/infiniband/hw/cxgb4/qp.c:1407: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
Wouldn't it be Good if virt_to_phys() returned the same typed value
on all arches?

Note: cxgb4 needs MAINTAINER info.

 drivers/infiniband/hw/cxgb4/cq.c |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

--- linux-next-20100428.orig/drivers/infiniband/hw/cxgb4/cq.c
+++ linux-next-20100428/drivers/infiniband/hw/cxgb4/cq.c
@@ -841,7 +841,7 @@ struct ib_cq *c4iw_create_cq(struct ib_d
 		mm2->len = PAGE_SIZE;
 		insert_mmap(ucontext, mm2);
 	}
-	PDBG("%s cqid 0x%0x chp %p size %u memsize %lu, dma_addr 0x%0llx\n",
+	PDBG("%s cqid 0x%0x chp %p size %u memsize %zu, dma_addr 0x%0llx\n",
 	     __func__, chp->cq.cqid, chp, chp->cq.size,
 	     chp->cq.memsize,
 	     (unsigned long long) chp->cq.dma_addr);
--- linux-next-20100428.orig/drivers/infiniband/hw/cxgb4/qp.c
+++ linux-next-20100428/drivers/infiniband/hw/cxgb4/qp.c
@@ -107,8 +107,10 @@ static int create_qp(struct c4iw_rdev *r
 	if (!wq->rq.queue)
 		goto err6;
 	PDBG("%s sq base va 0x%p pa 0x%llx rq base va 0x%p pa 0x%llx\n",
-		__func__, wq->sq.queue, virt_to_phys(wq->sq.queue),
-		wq->rq.queue, virt_to_phys(wq->rq.queue));
+		__func__, wq->sq.queue,
+		(unsigned long long)virt_to_phys(wq->sq.queue),
+		wq->rq.queue,
+		(unsigned long long)virt_to_phys(wq->rq.queue));
 	memset(wq->rq.queue, 0, wq->rq.memsize);
 	pci_unmap_addr_set(&wq->rq, mapping, wq->rq.dma_addr);
 
@@ -1404,7 +1406,7 @@ struct ib_qp *c4iw_create_qp(struct ib_p
 		qhp->wq.rq.memsize = roundup(qhp->wq.rq.memsize, PAGE_SIZE);
 	}
 
-	PDBG("%s sqsize %u sqmemsize %lu rqsize %u rqmemsize %lu\n",
+	PDBG("%s sqsize %u sqmemsize %zu rqsize %u rqmemsize %zu\n",
 	     __func__, sqsize, qhp->wq.sq.memsize, rqsize, qhp->wq.rq.memsize);
 
 	ret = create_qp(&rhp->rdev, &qhp->wq, &schp->cq, &rchp->cq,
