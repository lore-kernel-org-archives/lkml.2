Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab1DRS7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:59:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49781 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1DRS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:59:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=GWwgPcwqVc1QdcQ3/Ac0pDxI3v2WMBmoZARj3lhInQ7wNz9hM42/y6ozdNqs6LGwe
	pLjVfxLu6i8dNa1h2LXtQ==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v7 0/2] Make all it87 drivers SMP safe
Date: Mon, 18 Apr 2011 11:58:47 -0700
Message-Id: <1303153127-11717-1-git-send-email-natg@google.com>
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

 drivers/hwmon/it87.c           |   14 ++++-
 drivers/watchdog/it8712f_wdt.c |   53 ++++++++++++------
 drivers/watchdog/it87_wdt.c    |  119 ++++++++++++++++++++++------------------
 3 files changed, 113 insertions(+), 73 deletions(-)

Signed-off-by: Nat Gurumoorthy <natg@google.com>

Patch History:
v7:
- superio_enter return error if call to "request_muxed_region" fails. Rest
  of the changes deal with error returns from superio_enter. Changes to
  it87_wdt.c are untested.

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

