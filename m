Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1EGFUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 01:20:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1EGFUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 01:20:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=u/tGkqRmDrZBp+DhZa3Lh5XaitloS56iTqNCNLD4usEnZzUXMrMwYVFDa63inETbs
	l3g5Kr6mWboiIJnz+1pqg==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Cc: mikew@google.com, Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v9 0/2] Make all it87 drivers SMP safe
Date: Fri,  6 May 2011 22:19:24 -0700
Message-Id: <1304745564-13003-1-git-send-email-natg@google.com>
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

 drivers/hwmon/it87.c           |   31 +++++---
 drivers/watchdog/it8712f_wdt.c |   62 +++++++++++----
 drivers/watchdog/it87_wdt.c    |  165 +++++++++++++++++++++++----------------
 3 files changed, 161 insertions(+), 97 deletions(-)

Signed-off-by: Nat Gurumoorthy <natg@google.com>

Patch History:
v9:
- More clean up in drivers/hwmon/it87.c. More fixes that of
  the type in V8 that got missed in drivers/watchdog/it8712f_wdt.c.

v8:
- Return the error actually returned by superio_enter and not -EBUSY.
  Notifier routines return NOTIFY_DONE even if underlying calls from
  notifier to routines that invoke superio_enter return with error.
  Make sure release routines returns do proper clean up even if calls to
  superio_enter fail.

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

