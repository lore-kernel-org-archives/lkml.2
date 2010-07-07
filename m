Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0GGPsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:48:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:51064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab0GGPsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:48:40 -0400
Message-ID: <4C34A1D5.1090202@kernel.org>
Date: Wed, 07 Jul 2010 17:48:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F61AB.9030806@kernel.org>	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>	<4C317C04.20500@kernel.org>	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>	<4C32CE50.6010501@kernel.org>	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>	<4C341598.6040004@kernel.org> <AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
In-Reply-To: <AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/mixed;
 boundary="------------030400040608040801030907"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 07 Jul 2010 15:48:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030400040608040801030907
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 07/07/2010 05:34 PM, Mark Knecht wrote:
> OK - I don't know if this was you intention but since adding this
> patch I've not had a single drive missing failure. I've cold booted
> about 8 times and warm booted at least 20 times. Every one has come up
> fine. I've even gone so far as to turn off the UPS and sit for 5
> minutes before cold booting. Still nothing fails right now.
> 
> I've had this sort of statistical thing happen before where it hasn't
> failed for days, maybe even weeks, but then it starts failing and
> fails every time for awhile. Over the past few days working with you
> I've never had to reboot more than twice to get you a file. Now I've
> tried 30 times this morning and I've come up with nothing.
> 
> I will continue to watch the machine and send you the failing dmesg
> file whenever I finally get it. For now I can only attach the passing
> file showing the patch is now included.

It seems like SIDPR is a bit more unreliable than the current code can
handle and the added delay and read could have affected the result.
Eh... weird.  Can you please apply the attached patch instead?  The
only difference is it will print out two SControl values instead of
one.  ie. "XXX SControl after resume = AAA BBB, tries=T".  Can you
please try to boot multiple times and see if AAA and BBB differ
anytime?  If that happens, please attach the boot log.  Also, if you
see one with T > 1, please attach that one too.

Thanks.

-- 
tejun

--------------030400040608040801030907
Content-Type: text/x-patch;
 name="resume-dbg-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="resume-dbg-1.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2984e45..ce87bfe 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3712,7 +3712,7 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 		     unsigned long deadline)
 {
 	int tries = ATA_LINK_RESUME_TRIES;
-	u32 scontrol, serror;
+	u32 scontrol, scontrol1, serror;
 	int rc;
 
 	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
@@ -3739,6 +3739,14 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 			return rc;
 	} while ((scontrol & 0xf0f) != 0x300 && --tries);
 
+	/* check once more */
+	msleep(100);
+	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol1)))
+			return rc;
+	ata_link_printk(link, KERN_ERR,
+			"XXX SControl after resume = %X %X, tries=%d\n",
+			scontrol, scontrol1, ATA_LINK_RESUME_TRIES - tries + 1);
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

--------------030400040608040801030907--
