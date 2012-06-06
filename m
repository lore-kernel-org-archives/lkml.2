Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2FFQ1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:27:22 -0400
Received: from www84.your-server.de ([213.133.104.84]:36668 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab2FFQ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:19 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] fix usb skeleton driver
Date: Wed,  6 Jun 2012 18:27:01 +0200
Message-Id: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This is a fix for the USB skeleton driver to bring it in shape.

- The usb_interface structure pointer will be no longer stored 
- Every access to the USB will be handled trought the usb_interface pointer
- Add a new bool 'connected' for signaling a disconnect (== false)
- Handle a non blocking read without blocking
- Code cleanup
- Synchronize disconnect() handler with open() and release(), to fix races
- Introduced fsync
- Single user mode
- Eliminated dead code
- Save some bytes in the dev structure

Some word about the open()/release() races with disconnect() of an USB device
(which can happen any time):
- The return interface pointer from usb_find_interface() could be already owned
  by an other driver and no more longer handle by the skeleton driver.
- Or the dev pointer return by usb_get_intfdata() could point to an already
  release memory.

This races can not handled by a per device mutex. Only a driver global mutex
could do this job, since the kref_put() in the skel_disconnect() must be
protected, otherwise skel_open() could access an already released memory.

I know that this races are very small, but on heavy load or misdesigned or buggy
hardware this could lead in a OOPS or unpredictable behavior.

The patch is against linux 3.5.0 commit eea5b5510fc5545d15b69da8e485a7424ae388cf

Hope this helps

Signed-off-by: Stefani Seibold <stefani@seibold.net>
