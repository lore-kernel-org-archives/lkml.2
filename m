Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab2KWJme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:42:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43250 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab2KWJmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:42:32 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [RFC PATCH 0/2] staging: usbip: refine the spinlock
Date: Fri, 23 Nov 2012 17:46:34 +0800
Message-Id: <1353663996-11455-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset refine some spinlocks which I think not used properly. Maybe my 'refine' make the code  broken, so any comments will be appreciated. 

patch1: The function 'usbip_event_add()' may be called in interrupt context on the stub side: 
'stub_complete'->'stub_enqueue_ret_unlink'->'usbip_event_add'.
In this function it tries to get the lock 'ud->lock', so we shoud disable irq when we get this lock in process context.

patch2: On the client side, we have a virtual hcd driver so there actually no hardware interrupts. Maybe to achieve a good performance there is no need to use the interrupt safe spinlock. Just replace them with a non interrupt safe version.


Harvey Yang (2):
  staging: usbip: use interrupt safe spinlock to avoid potential
    deadlock.
  staging: usbip: replace the interrupt safe spinlock because no
    hardware interrupt exists.

 drivers/staging/usbip/stub_dev.c    |   34 ++++++++--------
 drivers/staging/usbip/stub_rx.c     |    4 +-
 drivers/staging/usbip/usbip_event.c |    6 ++-
 drivers/staging/usbip/vhci_hcd.c    |   75 +++++++++++++++--------------------
 drivers/staging/usbip/vhci_rx.c     |   10 ++---
 drivers/staging/usbip/vhci_tx.c     |   14 +++----
 6 files changed, 65 insertions(+), 78 deletions(-)

