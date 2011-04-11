Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1DKWGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:06:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28449 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1DKWGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:06:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=m4fBblOHD7JGw+ZLxilTPUEEMn8N066ueK7NfqYSLPsxStNeR/Y47yBfRH1ghXdSs
	F9Y/T5Hxl3JfpoBYLnZcw==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v3 0/2] Make all it87 drivers SMP safe
Date: Mon, 11 Apr 2011 15:05:22 -0700
Message-Id: <1302559522-18899-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 different drivers that touch the it87 hardware registers.
The 3 drivers have been written independently and access the it87 hardware
registers assuming they are the only driver accessing it. This change
attempts to serialize access to the hardware by using
"request_muxed_region" macro defined by Alan Cox. Call to this macro
will hold off the requestor if the resource is currently busy.
The use of the above macro makes it possible to get rid of
spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
This also greatly simplifies the implementation of it87_wdt.c driver.

01 - Changes to it87 watchdog driver to use "request_muxed_region"
 drivers/watchdog/it8712f_wdt.c
 drivers/watchdog/it87_wdt.c

02 - Chages to hwmon it87 driver to use "request_muxed_region"
 drivers/hwmon/it87.c

 drivers/hwmon/it87.c           |    4 ++++
 drivers/watchdog/it8712f_wdt.c |    9 ++++-----
 drivers/watchdog/it87_wdt.c    |   39 ++++-----------------------------------
 3 files changed, 12 insertions(+), 40 deletions(-)

Signed-off-by: Nat Gurumoorthy <natg@google.com>

Patch History:
v3:
- Totally abandon the spinlock based approach and use "request_muxed_region" to
  hold off requestors if the resource is busy.

v2:
- More verbose patch headers. Add In-Reply-To: field.

