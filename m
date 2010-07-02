Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab0GBMdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:33:06 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:40048 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab0GBMdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:33:04 -0400
X-Greylist: delayed 1602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jul 2010 08:33:04 EDT
Message-ID: <4C2DD625.2030903@grupopie.com>
Date: Fri, 02 Jul 2010 13:05:57 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: werner@guyane.yi.org
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
References: <1278041650.12788@guyane.yi.org>
In-Reply-To: <1278041650.12788@guyane.yi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

werner@guyane.yi.org wrote:
> 2.6.35-rc2,3,3-git1 -- Problem with PS2 keyboard and mouse driver
> 
> That problem continues at -git6 .
> 
> Since 2.6.35-rc2 the USB keyboard driver don't work longer, on
> different mainboards and keyboards.
> 
> On 2.6.35-rc1 things still were (more or less) normal.
> 
> THIS IS AN ERROR WHICH ENTERED BETWEEN 2.6.35 -rc1 and -rc2 !!

The address 07200720 looks like a couple of gray spaces in a vga console
and I've seen that before not long ago.

After a bit of searching, I've found it: it's in the thread that started
with "Linux 2.6.35-rc2", and most importantly in the thread:

BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)

where there is a patch that is supposed to fix this. I thought this was
already applied upstream, though...

For your convenience, the patch in that thread is this one (might be
white space mangled, as I just copy+pasted it, so you might need to
apply it by hand):

---
 drivers/char/vt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1296c42..e123958 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -304,8 +304,8 @@ static void scrup(struct vc_data *vc, unsigned int
t, unsigned int b, int nr)
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_size_row, vc->vc_video_erase_char,
-		    vc->vc_size_row * nr);
+	scr_memsetw((void *)d + (b - t - nr) * vc->vc_size_row,
+			vc->vc_video_erase_char, vc->vc_size_row * nr);
 }

 static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b,
int nr)


