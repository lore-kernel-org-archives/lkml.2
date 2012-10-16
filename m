Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2JPOtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:49:36 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45186 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab2JPOtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:49:35 -0400
Date: Tue, 16 Oct 2012 16:49:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: ata4.00: failed to get Identify Device Data, Emask 0x1
Message-ID: <20121016144932.GA24044@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

a bunch of my boxes started showing this on 3.7-rc1 (and maybe earlier):

[    4.667077] ata4.00: failed to get Identify Device Data, Emask 0x1
[    4.675071] ata4.00: failed to get Identify Device Data, Emask 0x1

Another one:

[    3.325371] ata4.00: failed to get Identify Device Data, Emask 0x1
[    3.488602] ata4.00: failed to get Identify Device Data, Emask 0x1

This last one is a laptop which suspends/resumes so this message happens
each time the driver gets initialized.

[    1.389734] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.395031] ata1.00: failed to get Identify Device Data, Emask 0x1
[16825.339587] ata1.00: failed to get Identify Device Data, Emask 0x1
[16825.345835] ata1.00: failed to get Identify Device Data, Emask 0x1
[16842.294983] ata1.00: failed to get Identify Device Data, Emask 0x1
[16842.300513] ata1.00: failed to get Identify Device Data, Emask 0x1
[23628.820487] ata1.00: failed to get Identify Device Data, Emask 0x1
[23628.825556] ata1.00: failed to get Identify Device Data, Emask 0x1
[23661.555111] ata1.00: failed to get Identify Device Data, Emask 0x1
[23661.560745] ata1.00: failed to get Identify Device Data, Emask 0x1

Grepping points to:

		/* Obtain SATA Settings page from Identify Device Data Log,
		 * which contains DevSlp timing variables etc.
		 * Exclude old devices with ata_id_has_ncq()
		 */
		if (ata_id_has_ncq(dev->id)) {
			err_mask = ata_read_log_page(dev,
						     ATA_LOG_SATA_ID_DEV_DATA,
						     ATA_LOG_SATA_SETTINGS,
						     dev->sata_settings,
						     1);
			if (err_mask)
				ata_dev_dbg(dev,
					    "failed to get Identify Device Data, Emask 0x%x\n",
					    err_mask);
		}

in ata_dev_configure().

Judging by the logs, it must've came in during this merge window:

Oct  4 11:08:13 kepek kernel: [    4.670357] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 11:08:13 kepek kernel: [    4.678833] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 11:29:23 kepek kernel: [    4.690456] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 11:29:23 kepek kernel: [    4.698473] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 11:54:20 kepek kernel: [    4.706777] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 11:54:20 kepek kernel: [    4.715194] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 14:30:17 kepek kernel: [    4.666199] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 14:30:17 kepek kernel: [    4.674742] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 15:30:17 kepek kernel: [    4.686204] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct  4 15:30:17 kepek kernel: [    4.694194] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 10 13:09:40 kepek kernel: [    4.670245] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 10 13:09:40 kepek kernel: [    4.678429] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 10 15:28:56 kepek kernel: [    4.658456] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 10 15:28:56 kepek kernel: [    4.666485] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 12 10:38:17 kepek kernel: [    4.694542] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 12 10:38:17 kepek kernel: [    4.702561] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 16 14:30:26 kepek kernel: [    4.667077] ata4.00: failed to get Identify Device Data, Emask 0x1
Oct 16 14:30:26 kepek kernel: [    4.675071] ata4.00: failed to get Identify Device Data, Emask 0x1

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
