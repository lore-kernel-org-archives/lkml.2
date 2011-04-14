Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1DNVh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:37:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62819 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1DNVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:37:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=nLYOZcxT5Y+feZlRzyEZyIZIbhOmzk1NH9tkQVKgUwAogEMfQ/hw9aYS54td+MNkG
	ZY9zBJCdlTT8qA2F/nQ4g==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v6 0/2] Make all it87 drivers SMP safe
Date: Thu, 14 Apr 2011 14:36:36 -0700
Message-Id: <1302816996-6345-1-git-send-email-natg@google.com>
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

 drivers/hwmon/it87.c           |   30 +++++++++++++-
 drivers/watchdog/it8712f_wdt.c |   50 +++++++++++++++++++++---
 drivers/watchdog/it87_wdt.c    |   80 +++++++++++++++++++++------------------
 3 files changed, 113 insertions(+), 47 deletions(-)

Signed-off-by: Nat Gurumoorthy <natg@google.com>

Patch History:
v6:
- Pay attention to value returned by request_muxed_region. The first call to
  request_muxed_region will attempt 10 times to reserve the region before it
  gives up. This will typically get called from the driver init routines. If this
  succeeds then subsequent calls wait forever for the resource to be available.

v5:
- Remove unnecessary while from superio_enter.

v4:
- Remove extra braces in superio_enter routines.

v3:
- Totally abandon the spinlock based approach and use "request_muxed_region" to
  hold off requestors if the resource is busy.

v2:
- More verbose patch headers. Add In-Reply-To: field.

