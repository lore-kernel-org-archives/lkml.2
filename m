Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2FNS2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:28:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22153 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2FNS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:28:07 -0400
Date: Thu, 14 Jun 2012 21:27:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: manish.rangankar@qlogic.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: re: [SCSI] qla4xxx: support iscsiadm session mgmt
Message-ID: <20120614182745.GA6383@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

The patch b3a271a94d00: "[SCSI] qla4xxx: support iscsiadm session 
mgmt" from Jul 25, 2011, leads to the following warning:
drivers/scsi/qla4xxx/ql4_os.c:4479 qla4xxx_get_ep_fwdb()
	 warn: casting from 16 to 28 bytes

(Sort of).

drivers/scsi/qla4xxx/ql4_os.c qla4xxx_ep_connect()
   705          qla_ep = ep->dd_data;
   706          memset(qla_ep, 0, sizeof(struct qla_endpoint));
   707          if (dst_addr->sa_family == AF_INET) {
   708                  memcpy(&qla_ep->dst_addr, dst_addr, sizeof(struct sockaddr_in));
   709                  addr = (struct sockaddr_in *)&qla_ep->dst_addr;
   710                  DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI4\n", __func__,
   711                                    (char *)&addr->sin_addr));
   712          } else if (dst_addr->sa_family == AF_INET6) {
   713                  memcpy(&qla_ep->dst_addr, dst_addr,
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   714                         sizeof(struct sockaddr_in6));
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Both qla_ep->dst_addr and dst_addr are type struct sockaddr.  We are
copying sizeof(struct sockaddr_in6) bytes which is 12 bytes larger.  I
don't know the actual size of qla_ep->dst_addr but dst_addr is allocated
in qla4xxx_get_ep_fwdb() as a struct sockaddr.  So we are copying past
the end of the struct here and it's possibly an information leak or even
a memory corruption issue depending on how much space ep->dd_data has.

   715                  addr6 = (struct sockaddr_in6 *)&qla_ep->dst_addr;
   716                  DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI6\n", __func__,
   717                                    (char *)&addr6->sin6_addr));
   718          }

regards,
dan carpenter

