Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2BWOlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:41:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41269 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2BWOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:41:16 -0500
Message-ID: <4F465007.30304@gmail.com>
Date: Thu, 23 Feb 2012 23:41:11 +0900
From: Akio Idehara <zbe64533@gmail.com>
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com, dtor@mail.ru
CC: seth.forshee@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, rdunlap@xenotime.net,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] Input: ALPS - Fix ALPS touchpad detection
References: <4F3D009B.8080506@gmail.com> <20120216143210.GA30486@ubuntu-macmini>
In-Reply-To: <20120216143210.GA30486@ubuntu-macmini>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is definitely a bug which isn't fixed for nine years.
Why this patch isn't applied to the input sub-system (or mainline)?

Seth Forshee wrote:
> On Thu, Feb 16, 2012 at 10:11:55PM +0900, Akio Idehara wrote:
>> ALPS touchpad detection fails if some buttons of ALPS are pressed.
>> The reason is that the "E6" query response byte is different from
>> what is expected.
>> This was tested on a Toshiba Portege R500.
>>
>> Cc: stable<stable@vger.kernel.org>
>> Signed-off-by: Akio Idehara<zbe64533@gmail.com>
>
> This version is working fine for me. Thanks!
>
> Tested-by: Seth Forshee<seth.forshee@canonical.com>

  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ALPS touchpad detection fails if some buttons of ALPS are pressed.
The reason is that the "E6" query response byte is different from
what is expected.
This was tested on a Toshiba Portege R500.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Akio Idehara <zbe64533@gmail.com>
Tested-by: Seth Forshee<seth.forshee@canonical.com>
---
     Documentation/input/alps.txt |    3 ++-
     drivers/input/mouse/alps.c   |    7 +++++--
     2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/input/alps.txt b/Documentation/input/alps.txt
index f274c28..2f95308 100644
--- a/Documentation/input/alps.txt
+++ b/Documentation/input/alps.txt
@@ -13,7 +13,8 @@ Detection

     All ALPS touchpads should respond to the "E6 report" command sequence:
     E8-E6-E6-E6-E9. An ALPS touchpad should respond with either 00-00-0A or
-00-00-64.
+00-00-64 if no buttons are pressed. The bits 0-2 of the first byte will be 1s
+if some buttons are pressed.

     If the E6 report is successful, the touchpad model is identified using the "E7
     report" sequence: E8-E7-E7-E7-E9. The response is the model signature and is
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index bd87380..4c6a72d 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -952,7 +952,9 @@ static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int

     	/*
     	 * First try "E6 report".
-	 * ALPS should return 0,0,10 or 0,0,100
+	 * ALPS should return 0,0,10 or 0,0,100 if no buttons are pressed.
+	 * The bits 0-2 of the first byte will be 1s if some buttons are
+	 * pressed.
     	 */
     	param[0] = 0;
     	if (ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES) ||
@@ -968,7 +970,8 @@ static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int
     	psmouse_dbg(psmouse, "E6 report: %2.2x %2.2x %2.2x",
     		    param[0], param[1], param[2]);

-	if (param[0] != 0 || param[1] != 0 || (param[2] != 10 && param[2] != 100))
+	if ((param[0] & 0xf8) != 0 || param[1] != 0 ||
+	    (param[2] != 10 && param[2] != 100))
     		return NULL;

     	/*
-- 1.7.9
