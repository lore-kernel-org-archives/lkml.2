Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab0CVUng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:43:36 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:49754 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0CVUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:43:34 -0400
Message-ID: <4BA7D666.5030608@seas.upenn.edu>
Date: Mon, 22 Mar 2010 16:43:18 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100316 Thunderbird/3.0.3
MIME-Version: 1.0
To: Micki Balanga <micki@n-trig.com>
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to driver
References: <1269260173-2543-1-git-send-email-micki@n-trig.com> <20100322172920.GA18658@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEE8@Exchange-IL.n-trig.com> <20100322181722.GA24483@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEEB@Exchange-IL.n-trig.com>
In-Reply-To: <48A28051AC6D7A48B64F28272458190326DEEB@Exchange-IL.n-trig.com>
Content-Type: multipart/mixed;
 boundary="------------030605050506000909020204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030605050506000909020204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/22/2010 03:58 PM, Micki Balanga wrote:
>
> Hi
> I would like to add more information about the Fake button.
> I will explain using this scenario:
> You touch the sensor with one finger and then remove the finger,
> Firmware will report six frames with fake fingers,(Indicate end of session)
> The driver will report this as fake fingers (Will send 3 events) and
> input_sync
> to inform user space application that the user removed finger from sensor.
> this information is needed in order to analyze the data received from
> N-trig firmware.
> Micki

Thank you for taking this to a discussion format.

It seems you have raised an issue that is an active discussion for multi 
touch handling in general and an issue that I have considered for n-trig 
support in specific.


The current published version of the driver does send one more sequence 
of events after it decides all fingers are off the screen.  That final 
sequence is necessary to tell single touch drivers that the tools are 
released (BTN_TOUCH is set to zero, etc).  This also resets the active 
contact count to zero for multi touch handlers, which look to see how 
many MT events come from each frame.

I had observed that sometimes the tablet looses contacts semi 
arbitrarily, and we get a zero contact group as a mistake.  In the 
patches I sent in early in February you will notice a solution that I 
was considering at the time.  I was also playing with correcting for 
events that looked like real contacts but were also just noise.  After 
rethinking my patches and reading the multi touch doc in the Documents 
tree, I chose to leave out these corrections.

That being said, I do have a specific patch to handle the set of end of 
stream events.  All that's needed is to count the empty groups and send 
the terminal events only when a counter hits the specified value 
(attached is a tiny patch I wrote when I needed that feature back really 
quickly when my screen started misbehaving during a meeting).

Note I have submitted that as a patch for 2 reasons.  First I couldn't 
be completely sure that there was a specific number of empty groups to 
signal end of stream which would be expected to be maintained over time. 
  And secondly the erroneous termination of stream has not been much of 
a problem in general.

You will note, that this is something that is simple enough that it 
makes perfect sense to put into the kernel.  There's little point in 
wasting the cycles to push that decision to user space.

--------------030605050506000909020204
Content-Type: text/plain;
 name="commit-4c6fffa"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="commit-4c6fffa"

commit 4c6fffa347e529672dfb858b07168f49ba4bbe97
Author: Rafi Rubin <rafi@seas.upenn.edu>
Date:   Tue Feb 23 12:11:41 2010 -0500

    Quick and dirty avoidance of erroneous end of contact events.

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 3234c72..25ee5a4 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -35,6 +35,9 @@ struct ntrig_data {
 
 	__u8 mt_footer[4];
 	__u8 mt_foot_count;
+
+	__u8 deactivate_slack;
+	__u8 deactivate_state; 
 };
 
 /*
@@ -192,6 +195,7 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 			/* Pen activity signal, trigger end of touch. */
 			if (nd->mt_footer[2]) {
 				nd->confidence = 0;
+				nd->deactivate_state = 0;
 				break;
 			}
 
@@ -252,14 +256,16 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 							BTN_TOOL_QUADTAP, 1);
 				}
 				input_report_key(input, BTN_TOUCH, 1);
-			} else {
+				nd->deactivate_state = nd->deactivate_slack;
+			} else if (! nd->deactivate_state) {
 				input_report_key(input,
 						BTN_TOOL_DOUBLETAP, 0);
 				input_report_key(input,
 						BTN_TOOL_TRIPLETAP, 0);
 				input_report_key(input,
 						BTN_TOOL_QUADTAP, 0);
-			}
+			} else
+				nd->deactivate_state--;
 			break;
 
 		default:
@@ -292,6 +298,8 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	nd->reading_mt = 0;
+	nd->deactivate_slack = 4;
+	nd->deactivate_state = 0; 
 	hid_set_drvdata(hdev, nd);
 
 	ret = hid_parse(hdev);

--------------030605050506000909020204--
