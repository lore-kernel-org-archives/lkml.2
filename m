Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3ADPkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:40:10 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63800 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3ADPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:40:05 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 4 Jan 2013 16:40:03 +0100
Message-ID: <CA+icZUUCB3K1=DuM6Nonu+Qc+qg3cM_ODk9TDZ-uYCfLVOhrdw@mail.gmail.com>
Subject: [3.8-{rc1,rc2}] ata1.00: failed to get Identify Device Data, Emask 0x1
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Shane Huang <shane.huang@amd.com>, Aaron Lu <aaron.lu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed messages like the following in my syslogs with Linux
v3.8-rc1 and v3.8-rc2:

ata1.00: failed to get Identify Device Data, Emask 0x1

In this Samsung ultrabook there exists a small SSD and a 500GiB HDD.
I had no look which of the two is "ata1" or "ata2".
NOTE: With ata2 I do not see the messages.
I haven't checked older Linux-kernel versions.

I followed the thread in [1] a bit and Aaron Lu pointed to the commit
which causes these messages.
Shane wanted to submit a patch [3] which I first didn't found.
But I guess it's the one from [4], building right now...

Hope this helps a bit to narrow down the problem.

Regards,
- Sedat -

[1] https://lkml.org/lkml/2012/10/16/557
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=65fe1f0f66a57380229a4ced844188103135f37b
[3] https://lkml.org/lkml/2012/11/16/369
[4] http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=patch;h=de90cd71f68e947d3bd6c3f2ef5731ead010a768

P.S.: Excerpts from the quoted commit:

[ drivers/ata/libata-core.c ]
...
+               /* check and mark DevSlp capability */
+               if (ata_id_has_devslp(dev->id))
+                       dev->flags |= ATA_DFLAG_DEVSLP;
+
+
+               /* Obtain SATA Settings page from Identify Device Data Log,
+                * which contains DevSlp timing variables etc.
+                * Exclude old devices with ata_id_has_ncq()
+                */
+               if (ata_id_has_ncq(dev->id)) {
+                       err_mask = ata_read_log_page(dev,
+                                                    ATA_LOG_SATA_ID_DEV_DATA,
+                                                    ATA_LOG_SATA_SETTINGS,
+                                                    dev->sata_settings,
+                                                    1);
+                       if (err_mask)
+                               ata_dev_dbg(dev,
+                                           "failed to get Identify
Device Data, Emask 0x%x\n",
+                                           err_mask);
+               }
+
- EOT -
