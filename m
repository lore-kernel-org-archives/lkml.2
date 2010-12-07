Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0LGUFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:05:09 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45133 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab0LGUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:05:08 -0500
Message-ID: <4CFE934D.4040309@euromail.se>
Date: Tue, 07 Dec 2010 21:04:29 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] input: mt: Move tracking and pointer emulation to
 input-mt
References: <1291722357-22820-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1012071553100.14806@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1012071553100.14806@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQ3mE-0000KM-8P.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PQ3mE-0000KM-8P ea1549e59111c552f9417295ed485278
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 03:53 PM, Jiri Kosina wrote:

> On Tue, 7 Dec 2010, Henrik Rydberg wrote:
> 
>> The drivers using the type B protocol all report tracking information
>> the same way. The contact id is semantically equivalent to
>> ABS_MT_SLOT, and the handling of ABS_MT_TRACKING_ID only complicates
>> the driver. The situation can be improved upon by providing a common
>> pointer emulation code, thereby removing the need for the tracking id
>> in the driver.  This patch moves all tracking event handling over to
>> the input core, simplifying both the existing drivers and the ones
>> currently in preparation.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>> This is revision three of the patch, with changes to incorporate the
>> active use of ABS_MT_TOOL_TYPE. Example usages are found in pen and
>> touch tablets and simple dual touch devices. The report_slot_state()
>> function now takes the tool type as argument, since a change in either
>> tool type of touch state should trigger a new tracking id.
>>
>> Thanks,
>> Henrik
>>
>>  drivers/hid/hid-3m-pct.c                |   30 +---------
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> 


Thanks Jiri. Ping, you acked a previous version, but I did not want to presume
this version was ok as well. And, as it turned out, I managed to introduce an
error (pressure is zero or one). Corrected and properly tested on a Bamboo
Touch. With the patch below folded in, do I have your ack?

Thanks,
Henrik
---
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 4e59b93..0104e1a 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -866,17 +866,18 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
        int i;

        for (i = 0; i < 2; i++) {
-               int p = data[9 * i + 2] && !wacom->shared->stylus_in_proximity;
+               int p = data[9 * i + 2];
+               bool touch = p && !wacom->shared->stylus_in_proximity;

                input_mt_slot(input, i);
-               input_mt_report_slot_state(input, MT_TOOL_FINGER, p);
+               input_mt_report_slot_state(input, MT_TOOL_FINGER, touch);
                /*
                 * Touch events need to be disabled while stylus is
                 * in proximity because user's hand is resting on touchpad
                 * and sending unwanted events.  User expects tablet buttons
                 * to continue working though.
                 */
-               if (p) {
+               if (touch) {
                        int x = get_unaligned_be16(&data[9 * i + 3]) & 0x7ff;
                        int y = get_unaligned_be16(&data[9 * i + 5]) & 0x7ff;
                        if (features->quirks & WACOM_QUIRK_BBTOUCH_LOWRES) {
