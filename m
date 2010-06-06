Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0FFVdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 17:33:50 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:43104 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab0FFVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 17:33:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: frankpzh@gmail.com, Greg KH <gregkh@suse.de>,
       =?UTF-8?q?Ortwin=20Gl=C3=BCck?= <odi@odi.ch>,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)
Date: Sun,  6 Jun 2010 23:33:35 +0200
Message-Id: <1275860015-6643-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4C0C0DD8.5030106@gmail.com>
References: <4C0C0DD8.5030106@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 11:06 PM, Justin P. Mattock wrote:
> On 06/05/2010 11:27 PM, Jiri Slaby wrote:
>> On 06/06/2010 08:12 AM, Justin P. Mattock wrote:
>>> =============================================================================
>>>
>>>
>>> [    0.002046] BUG kmalloc-4096: Poison overwritten
>>> [    0.002051]
>>> -----------------------------------------------------------------------------
>>>
>>>
>>> [    0.002052]
>>> [    0.002063] INFO: 0xffff88003ec09e00-0xffff88003ec09e9f. First byte
>>> 0x20 instead of 0x6b
>>> [    0.002073] INFO: Slab 0xffffea0000dba1c0 objects=7 used=1
>>> fp=0xffff88003ec09048 flags=0x40000000000040c3
>>> [    0.002082] INFO: Object 0xffff88003ec09048 @offset=4168
>>> fp=0xffff88003ec0a090
>>> [    0.002083]
>>> [    0.002093] Bytes b4 0xffff88003ec09038:  00 00 00 00 00 00 00 00 5a
>>> 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
>>> [    0.002114]   Object 0xffff88003ec09048:  6b 6b 6b 6b 6b 6b 6b 6b 6b
>>> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> ...
>>> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>> [    0.002999]   Object 0xffff88003ec09df8:  6b 6b 6b 6b 6b 6b 6b 6b 20
>>> 07 20 07 20 07 20 07 kkkkkkkk........
>>> [    0.002999]   Object 0xffff88003ec09e08:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e18:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e28:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e38:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e48:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e58:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e68:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e78:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e88:  20 07 20 07 20 07 20 07 20
>>> 07 20 07 20 07 20 07 ................
>>> [    0.002999]   Object 0xffff88003ec09e98:  20 07 20 07 20 07 20 07 6b
>>> 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk
>>> [    0.002999]   Object 0xffff88003ec09ea8:  6b 6b 6b 6b 6b 6b 6b 6b 6b
>>
>> Just guessing, grey spaces which should go to video ram?
>>
> 
> 
> o.k. I bisected this down to this commit:
> 962400e8fd29
> reverting gets dmesg to not
> have a Poison overwritten..

This definitely makes sense.

> as for the screen blankness I think this
> did cause it..keep in mind the blankness(black)
> is not everytime(every so often)
> here's some images of it:
> http://www.flickr.com/photos/44066293@N08/4676350524/
> http://www.flickr.com/photos/44066293@N08/4676350016/

Yes, as I guessed, the "grey spaces" were written to some random space
instead of video ram where they should overwrite (clear) the characters
which you see on the pictures.

Does the patch below help?

---
 drivers/char/vt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1296c42..e123958 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -304,8 +304,8 @@ static void scrup(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_size_row, vc->vc_video_erase_char,
-		    vc->vc_size_row * nr);
+	scr_memsetw((void *)d + (b - t - nr) * vc->vc_size_row,
+			vc->vc_video_erase_char, vc->vc_size_row * nr);
 }
 
 static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
-- 
1.7.1


