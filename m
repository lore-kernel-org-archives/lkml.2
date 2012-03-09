Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab2CIWac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:30:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44932 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844Ab2CIWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:30:30 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Fri, 9 Mar 2012 23:30:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc6-wl+; KDE/4.7.4; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <4F551E46.7000100@linux.vnet.ibm.com>
In-Reply-To: <4F551E46.7000100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203092330.24438.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a regression which was introduced by:
"PM: Print a warning if firmware is requested when tasks are frozen"

request_firmware_nowait does not stall in any system resume paths.
Therefore, I think it is perfectly save to use request_firmware_nowait
from at least the ->complete() callback.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/base/firmware_class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6c9387d..017e020 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -535,7 +535,7 @@ static int _request_firmware(const struct firmware **firmware_p,
 
 	read_lock_usermodehelper();
 
-	if (WARN_ON(usermodehelper_is_disabled())) {
+	if (WARN_ON(usermodehelper_is_disabled() && !(nowait && uevent))) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
 		goto out;
-- 
1.7.9.1

