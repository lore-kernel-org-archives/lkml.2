Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab3AHFoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:44:30 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48618 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3AHFo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:44:28 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 0/2] staging: usbip: refine the lock
Date: Tue,  8 Jan 2013 13:49:00 +0800
Message-Id: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset refines some spinlocks which maybe not used properly.  

[PATCH 1/2]: The function 'usbip_event_add()' may be called in interrupt context on the stub side: 
'stub_complete'->'stub_enqueue_ret_unlink'->'usbip_event_add'.
In this function it tries to get the lock 'ud->lock', so we should disable irq when we get this lock in process context.

[PATCH 2/2]: On the client side, we have a virtual hcd driver, there actually no hardware interrupts, so we do not need worry about race conditions caused by irq. To achieve a good performance there is no need to use the interrupt safe spinlock. Just replace them with a non interrupt safe version.


Harvey Yang (2):
  staging: usbip: use interrupt safe spinlock to avoid potential
    deadlock.
  staging: usbip: replace the interrupt safe spinlocks with common
    ones.

 drivers/staging/usbip/stub_dev.c    |   34 ++++++++--------
 drivers/staging/usbip/stub_rx.c     |    4 +-
 drivers/staging/usbip/usbip_event.c |    6 ++-
 drivers/staging/usbip/vhci_hcd.c    |   76 +++++++++++++++--------------------
 drivers/staging/usbip/vhci_rx.c     |   10 ++---
 drivers/staging/usbip/vhci_tx.c     |   14 +++----
 6 files changed, 65 insertions(+), 79 deletions(-)

