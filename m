Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2JSRMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:12:34 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:32642 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434Ab2JSRMc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:12:32 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zcb8kz9371I1432Izz1202h1d1ah1d2ahzz8275bhz2fh2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1155h)
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: Joe Jin <joe.jin@oracle.com>, Ron Mercer <ron.mercer@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>
CC: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Marsden <greg.marsden@oracle.com>
Date: Fri, 19 Oct 2012 10:12:25 -0700
Subject: RE: [PATCH] qla3xxx: Ensure request/response queue addr writes to
 the registers
Thread-Topic: [PATCH] qla3xxx: Ensure request/response queue addr writes to
 the registers
Thread-Index: Ac2tmIjRiUBG8TkRQ3m3G00LQHR1cgAgpT2w
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87744A9406C@AVEXMB1.qlogic.org>
References: <5080ABD7.90006@oracle.com>
In-Reply-To: <5080ABD7.90006@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From: Joe Jin [mailto:joe.jin@oracle.com] 
>Sent: Thursday, October 18, 2012 6:25 PM
>To: Ron Mercer; Dept-Eng Linux Driver; Jitendra Kalsaria; Joe Jin
>Cc: netdev; linux-kernel; Greg Marsden
>Subject: [PATCH] qla3xxx: Ensure request/response queue addr writes to the registers
>
>Before use the request and response queue addr, make sure it has wrote
>to the registers.
>
>Signed-off-by: Joe Jin <joe.jin@oracle.com>
>Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
>Cc: Ron Mercer <ron.mercer@qlogic.com>
>---
> drivers/net/ethernet/qlogic/qla3xxx.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
>index df09b1c..f745ade 100644
>--- a/drivers/net/ethernet/qlogic/qla3xxx.c
>+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
>@@ -2525,6 +2525,12 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
> 	qdev->req_q_size =
> 	    (u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));
> 
>+	/*
>+	 * The barrier is required to ensure request and response queue
>+	 * addr writes to the registers.
>+	 */
>+	wmb();
>+
> 	qdev->req_q_virt_addr =
> 	    pci_alloc_consistent(qdev->pdev,
> 				 (size_t) qdev->req_q_size,

Joe,

You need to move below line above the write memory barrier to get response queue address write to register
	qdev->rsp_q_size = NUM_RSP_Q_ENTRIES * sizeof(struct net_rsp_iocb);

Your patch will be like below:
<snip>
	qdev->req_q_size =
		(u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));

+	qdev->rsp_q_size = NUM_RSP_Q_ENTRIES * sizeof(struct net_rsp_iocb);
+
+	/*
+	 * The barrier is required to ensure request and response queue
+	 * addr writes to the registers.
+	 */
+	wmb();
+

<\snip>


thanks,
	Jiten
-- 
1.7.11.7



