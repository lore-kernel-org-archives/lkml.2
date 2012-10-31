Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2JaTge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:36:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42420 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759749Ab2JaTgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:36:33 -0400
Message-ID: <50917DB7.6040503@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 14:36:23 -0500
From: Trey Ramsay <tramsay@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: cjb@laptop.org
Subject: drivers/mmc/card/block.c infinite loop in mmc_blk_err_check waiting
 on R1_READY_FOR_DATA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103119-5112-0000-0000-00000E0D1349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the 3.7-rc3 kernel, there is an infinite loop in the 
mmc_blk_err_check() function in drivers/mmc/card/block.c that can be 
caused bad hardware. This loop has moved around a little, but appears to 
have been around in the kernel since v2.6.12.  The code will loop 
forever on write if the card isn't ready for data or if it's in program 
mode.  I did some searching and saw that it was reported to 
linux-mmc@vger.kernel.org 
http://permalink.gmane.org/gmane.linux.kernel.mmc/2021 back in May but 
didn't see a response.  Should there be a maximum retry count or a 
timeout to prevent an infinite loop?


1030         /*
1031          * Everything else is either success, or a data error of some
1032          * kind.  If it was a write, we may have transitioned to
1033          * program mode, which we have to wait for it to complete.
1034          */
1035         if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
1036                 u32 status;
1037                 do {
1038                         int err = get_card_status(card, &status, 5);
1039                         if (err) {
1040 
                                 pr_err("%s: error %d requesting status\n",
1041                                        req->rq_disk->disk_name, err);
1042                                 return MMC_BLK_CMD_ERR;
1043                         }
1044                         /*
1045                          * Some cards mishandle the status bits,
1046                          * so make sure to check both the busy
1047                          * indication and the card state.
1048                          */
1049                 } while (!(status & R1_READY_FOR_DATA) ||
1050                          (R1_CURRENT_STATE(status) == R1_STATE_PRG));
1051         }

