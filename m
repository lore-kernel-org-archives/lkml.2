Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1F0PpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:45:24 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37162 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751462Ab1F0PpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:45:22 -0400
Message-Id: <2ecba7369d1ac0d7b1ab08ccce65f240719f99c8.1309182743.git.ralf@linux-mips.org>
In-Reply-To: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
References: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
From: Ralf Baechle <ralf@linux-mips.org>
To: Brent Casavant <bcasavan@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Date: Mon, 27 Jun 2011 14:35:01 +0100
Subject: [PATCH 11/12] MISC: IOC4: Fix section mismatch / race condition.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/misc/ioc4.o(.data+0x144): Section mismatch in reference from the variable ioc4_load_modules_work to the function .devinit.text:ioc4_load_modules()
The variable ioc4_load_modules_work references
the function __devinit ioc4_load_modules()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

This one is potencially fatal; by the time ioc4_load_modules is invoked
it may already have been freed.  For that reason ioc4_load_modules_work
can't be turned to __devinitdata but also because it's referenced in
ioc4_exit.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: Brent Casavant <bcasavan@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
---
 drivers/misc/ioc4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 668d41e..df03dd3 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -270,7 +270,7 @@ ioc4_variant(struct ioc4_driver_data *idd)
 	return IOC4_VARIANT_PCI_RT;
 }
 
-static void __devinit
+static void
 ioc4_load_modules(struct work_struct *work)
 {
 	request_module("sgiioc4");
-- 
1.7.4.4

