Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0KZRTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:19:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:34877 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab0KZRTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:19:23 -0500
Message-ID: <4CEFEC17.6060503@kernel.org>
Date: Fri, 26 Nov 2010 18:19:19 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tobias Karnat <tobias.karnat@googlemail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata_sil24: external raid storage mistaken as port multiplier
References: <1290461073.12443.21.camel@Tobias-Karnat>	 <1290514125.28293.2.camel@Tobias-Karnat> <1290572588.24847.20.camel@Tobias-Karnat>
In-Reply-To: <1290572588.24847.20.camel@Tobias-Karnat>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 17:19:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 05:23 AM, Tobias Karnat wrote:
> Hi,
> 
> I got it fixed by removing ATA_FLAG_PMP from the SIL24_COMMON_FLAGS.
> 
> Could someone turn this into a module option?
> 
> The external raid case might in fact has a built-in port multiplier,
> but the case can only be configured as raid0 and raid1.
> 
> I suspect that Linux tries to to access the drives separately, which fails.

Hmmm... well, libata is just sending SRST w/ the port number set to 15
and the device is reporting that it is a port multipler to that.
Depending on configuration these devices don't work too well when
commanded as a PMP device.  If you put it into JBOD mode, it will
probably work fine.  I have no idea why it still reports as a PMP
device when configured as a virtual device.

That said, yeah, it probably would be a good idea to add a
libata.force param.

Can you please apply the following patch and verify that the device
doesn't work without any parameter but it does with
"libata.force=nopmp"?

Thanks.

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7f77c67..7423265 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6325,6 +6325,7 @@ static int __init ata_parse_force_one(char **cur,
 		{ "nohrst",	.lflags		= ATA_LFLAG_NO_HRST },
 		{ "nosrst",	.lflags		= ATA_LFLAG_NO_SRST },
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
+		{ "nopmp",	.lflags		= ATA_LFLAG_NO_PMP },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d947b12..6102ba2 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -174,6 +174,7 @@ enum {
 	ATA_LFLAG_DISABLED	= (1 << 6), /* link is disabled */
 	ATA_LFLAG_SW_ACTIVITY	= (1 << 7), /* keep activity stats */
 	ATA_LFLAG_NO_LPM	= (1 << 8), /* disable LPM on this link */
+	ATA_LFLAG_NO_PMP	= (1 << 9), /* disable PMP support */

 	/* struct ata_port flags */
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
@@ -1210,7 +1211,8 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 #ifdef CONFIG_SATA_PMP
 static inline bool sata_pmp_supported(struct ata_port *ap)
 {
-	return ap->flags & ATA_FLAG_PMP;
+	return (ap->flags & ATA_FLAG_PMP) &&
+		!(ap->link.flags & ATA_LFLAG_NO_PMP);
 }

 static inline bool sata_pmp_attached(struct ata_port *ap)
