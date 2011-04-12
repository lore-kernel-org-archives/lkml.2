Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1DLUtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:49:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1DLUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:49:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=LfRKc/tCzIRyH5eye6A8WPHBPVbEaAIvmilLolMey5S1FwVltxQVEWaMLOe07Z+Ix
	Jst3ebqg27tC93rcsdB0w==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v5 0/2] Make all it87 drivers SMP safe
Date: Tue, 12 Apr 2011 13:48:10 -0700
Message-Id: <1302641290-30212-1-git-send-email-natg@google.com>
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

 drivers/hwmon/it87.c           |    6 +++++
 drivers/watchdog/it8712f_wdt.c |   11 +++++----
 drivers/watchdog/it87_wdt.c    |   41 +++++----------------------------------
 3 files changed, 18 insertions(+), 40 deletions(-)

Signed-off-by: Nat Gurumoorthy <natg@google.com>

Patch History:
v5:
- Remove unnecessary while from superio_enter.

v4:
- Remove extra braces in superio_enter routines.

v3:
- Totally abandon the spinlock based approach and use "request_muxed_region" to
  hold off requestors if the resource is busy.

v2:
- More verbose patch headers. Add In-Reply-To: field.

