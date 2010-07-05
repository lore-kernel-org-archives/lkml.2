Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0GEGac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 02:30:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:46484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab0GEGab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 02:30:31 -0400
Message-ID: <4C317C04.20500@kernel.org>
Date: Mon, 05 Jul 2010 08:30:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F61AB.9030806@kernel.org> <AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
In-Reply-To: <AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010204010104060901070006"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Jul 2010 06:30:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010204010104060901070006
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/03/2010 06:42 PM, Mark Knecht wrote:
> On Sat, Jul 3, 2010 at 9:13 AM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> On 07/03/2010 06:06 PM, Mark Knecht wrote:
>>>> Can you please *attach* full logs of a successful boot and several
>>>> failing boots?
>>>
>>> Certainly? Which logs? dmesg or something else?
>>
>> dmesg output preferably with printk timestamp enabled.

Can you please apply the attached patch, reproduce the problem and
post the kernel log?

Thanks.

-- 
tejun

--------------010204010104060901070006
Content-Type: text/x-patch;
 name="resume-dbg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="resume-dbg.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2984e45..987ca80 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3739,6 +3739,14 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 			return rc;
 	} while ((scontrol & 0xf0f) != 0x300 && --tries);
 
+	/* check once more */
+	msleep(100);
+	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+			return rc;
+	ata_link_printk(link, KERN_ERR,
+			"XXX SControl after resume = %X, tries=%d\n",
+			scontrol, ATA_LINK_RESUME_TRIES - tries + 1);
+
 	if ((scontrol & 0xf0f) != 0x300) {
 		ata_link_printk(link, KERN_ERR,
 				"failed to resume link (SControl %X)\n",
@@ -6007,7 +6015,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 
 		ehi->probe_mask |= ATA_ALL_DEVICES;
 		ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
-		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+		ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 		ap->pflags |= ATA_PFLAG_LOADING;

--------------010204010104060901070006--
