Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0FWR2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:28:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:45589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0FWR2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:28:18 -0400
Message-ID: <4C224429.6010705@kernel.org>
Date: Wed, 23 Jun 2010 19:28:09 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch>
In-Reply-To: <4C223F8A.9030306@odi.ch>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Jun 2010 17:28:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/23/2010 07:08 PM, Ortwin Glück wrote:
>>From time to time this nVidia SATA controller chokes on a FLUSH CACHE.
> 
> 1. why does the kernel not try to HARD reset the link?

Because hardreset sometimes brings the link completely offline on
sata_nv's.  Hardreset on sata_nv controllers is quite fragile.

> 2. it would be nice to have the possibility to manually force a
> (hard) reset or to re-initialize the device. Other than rebooting I
> mean :-)

Maybe we can use hardreset as the last resort before ditching the
device.  Something like the following.  Can you please try it and post
the kernel log?  Thanks.

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 2116113..5105951 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1587,7 +1587,7 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
         * comment above port ops for details.
         */
        if (!(link->ap->pflags & ATA_PFLAG_LOADING) &&
-           !ata_dev_enabled(link->device))
+           (!ata_dev_enabled(link->device) || ehc->tries[0] == 1))
                sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
                                    NULL, NULL);
        else {

-- 
tejun
