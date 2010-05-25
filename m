Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0EYQ0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:26:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab0EYQ0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:26:48 -0400
Date: Tue, 25 May 2010 12:26:35 -0400
From: John Villalovos <jvillalo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] serial: Fix missing bit coverage of ASYNC_FLAGS
Message-ID: <20100525162634.GA20573@linuxjohn.usersys.redhat.com>
Reply-To: John Villalovos <jvillalo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that currently ASYNC_FLAGS is one bit short of covering all the bits
of the ASYNC user flags.  In particular it does not cover the ASYNC_AUTOPROBE
bit.

ASYNCB_LAST_USER and ASYNCB_AUTOPROBE are both equal to 15.

Therefore:
ASYNC_AUTOPROBE = 1000 0000 0000 0000
ASYNC_FLAGS     = 0111 1111 1111 1111

So ASYNC_FLAGS is not covering the ASYNC_AUTOPROBE bit.

This patch fixes the issue and with the patch the values will be:
ASYNC_AUTOPROBE = 1000 0000 0000 0000
ASYNC_FLAGS     = 1111 1111 1111 1111

As a side note, doing a "git grep" I didn't find any use of
ASYNC_AUTOPROBE or ASYNCB_AUTOPROBE in the kernel, besides this include
file.

Signed-off-by: John Villalovos <john.l.villalovos@intel.com>

diff --git a/include/linux/serial.h b/include/linux/serial.h
index c8613c3..c3b45ad 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -151,7 +151,7 @@ struct serial_uart_config {
 #define ASYNC_BUGGY_UART	(1U << ASYNCB_BUGGY_UART)
 #define ASYNC_AUTOPROBE		(1U << ASYNCB_AUTOPROBE)
 
-#define ASYNC_FLAGS		((1U << ASYNCB_LAST_USER) - 1)
+#define ASYNC_FLAGS		((1U << (ASYNCB_LAST_USER + 1)) - 1)
 #define ASYNC_USR_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI| \
 		ASYNC_CALLOUT_NOHUP|ASYNC_SPD_SHI|ASYNC_LOW_LATENCY)
 #define ASYNC_SPD_CUST		(ASYNC_SPD_HI|ASYNC_SPD_VHI)
