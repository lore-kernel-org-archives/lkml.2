Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0LFRrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:47:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:36365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab0LFRri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:47:38 -0500
Message-ID: <4CFD217F.5040901@kernel.org>
Date: Mon, 06 Dec 2010 18:46:39 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
References: <20101130210938.GF25668@bombadil.infradead.org> <4CF62EE0.7040607@kernel.org> <20101201124445.GG25668@bombadil.infradead.org> <4CF6595A.6010104@kernel.org> <20101201155026.GH25668@bombadil.infradead.org> <20101201200907.GI25668@bombadil.infradead.org> <4CF77225.3040904@kernel.org> <20101202212346.GK25668@bombadil.infradead.org> <4CF8C204.8010904@kernel.org> <20101203115902.GL25668@bombadil.infradead.org> <20101206160728.GP25668@bombadil.infradead.org>
In-Reply-To: <20101206160728.GP25668@bombadil.infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 17:46:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/06/2010 05:07 PM, Kyle McMartin wrote:
> On Fri, Dec 03, 2010 at 06:59:02AM -0500, Kyle McMartin wrote:
>> On Fri, Dec 03, 2010 at 11:10:12AM +0100, Tejun Heo wrote:
>>>> This gets triggered a bunch on boot-up:
>>>
>>> Yeah, that's expected.  Can you please do the usual testing routine
>>> and trigger the EH giving up message and then attach the full kernel
>>> log?
>>>
>>
> 
> OK, attached is a couple days worth of suspend/resume, hopefully that
> turns up what you're looking for.

Heh, yeah, actually it did.  Can you please apply the following patch
on top and see whether the problem goes away?

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7f77c67..f23d6d4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4807,9 +4807,6 @@ static void ata_verify_xfer(struct ata_queued_cmd *qc)
 {
 	struct ata_device *dev = qc->dev;

-	if (ata_tag_internal(qc->tag))
-		return;
-
 	if (ata_is_nodata(qc->tf.protocol))
 		return;

@@ -4858,14 +4855,23 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		if (unlikely(qc->err_mask))
 			qc->flags |= ATA_QCFLAG_FAILED;

-		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
-			/* always fill result TF for failed qc */
+		/*
+		 * Finish internal commands without any further processing
+		 * and always with the result TF filled.
+		 */
+		if (unlikely(ata_tag_internal(qc->tag))) {
 			fill_result_tf(qc);
+			__ata_qc_complete(qc);
+			return;
+		}

-			if (!ata_tag_internal(qc->tag))
-				ata_qc_schedule_eh(qc);
-			else
-				__ata_qc_complete(qc);
+		/*
+		 * Non-internal qc has failed.  Fill the result TF and
+		 * summon EH.
+		 */
+		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
+			fill_result_tf(qc);
+			ata_qc_schedule_eh(qc);
 			return;
 		}

