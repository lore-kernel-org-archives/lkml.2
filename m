Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1BNBfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 20:35:37 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49985 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325Ab1BNBfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 20:35:31 -0500
Subject: cx23885-input.c does in fact use a workqueue....
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stoth@kernellabs.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 20:35:22 -0500
Message-ID: <1297647322.19186.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-02-14_01:2011-02-13,2011-02-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1102130132
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

I just noticed this commit:

commit 8c71778cbf2c8beaefaa2dee5478aa0622d96682
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Dec 24 16:14:20 2010 +0100

    media/video: don't use flush_scheduled_work()
    
    This patch converts the remaining users of flush_scheduled_work() in
    media/video.
    
    * bttv-input.c and cx23885-input.c don't use workqueue at all.  No
      need to flush.
[...]


The cx23885 driver does in fact schedule work for IR input handling:

Here's where it is scheduled for CX23888 chips:

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-ir.c;h=7125247dd25558678c823ee3262675570c9aa630;hb=HEAD#l76

Here's where it is scheduled for CX23885 chips:

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-core.c;h=359882419b7f588b7c698dbcfb6a39ddb1603301;hb=HEAD#l1861


The two different chips are handled slightly differently because

a. the CX23888 IR unit is accessable via a PCI register block.  The IR
IRQ can be acknowledged with direct PCI register accesses in an
interrupt context, and the IR pulse FIFO serviced later in a workqueue
context.

b. the CX23885 IR unit is accessed over an I2C bus.  The CX23885 A/V IRQ
has to be masked in an interrupt context (with PCI registers accesses).
Then the CX23885 A/V unit's IR IRQ is ack'ed over I2C in a workqueue
context and the IR pulse FIFO is also serviced over I2C in a workqueue
context.


So what should be done about the flush_scheduled_work()?  I think it
belongs there.

Regards,
Andy

