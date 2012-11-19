Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2KSTVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:21:33 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:39865 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab2KSTVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:21:31 -0500
Date: Mon, 19 Nov 2012 20:21:49 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: vt: regression caused by "Fix line garbage in virtual.."
Message-ID: <20121119202149.46fc89c4@armhf>
In-Reply-To: <20121119113828.5a66f112@bob.linux.org.uk>
References: <20121118110523.GA12094@shrek.podlesie.net>
	<20121119113828.5a66f112@bob.linux.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 11:38:28 +0000
Alan Cox <alan@linux.intel.com> wrote:

> > There are some garbage after mousedev.c not present on older kernels.
> > 
> > Reverting commit 81732c in v3.7-rc6 fixes the issue.
> 
> Then we should drop this for 3.7 until a fixed one is provided IMHO.
> Its not relevant to most platforms.

Sorry, juggling with the byte offsets and the character indexes was not
so obvious.

Here is a patch towards the kernel 3.7.

Krzysztof, may you check it?

Thanks.

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -539,25 +539,25 @@
 {
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	scr_memmovew(p + nr, p, vc->vc_cols - vc->vc_x);
+	scr_memmovew(p + nr, p, (vc->vc_cols - vc->vc_x) * 2);
 	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc))
 		do_update_region(vc, (unsigned long) p,
-			(vc->vc_cols - vc->vc_x) / 2 + 1);
+			vc->vc_cols - vc->vc_x + 1);
 }
 
 static void delete_char(struct vc_data *vc, unsigned int nr)
 {
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	scr_memcpyw(p, p + nr, vc->vc_cols - vc->vc_x - nr);
+	scr_memcpyw(p, p + nr, (vc->vc_cols - vc->vc_x - nr) * 2);
 	scr_memsetw(p + vc->vc_cols - vc->vc_x - nr, vc->vc_video_erase_char,
 			nr * 2);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc))
 		do_update_region(vc, (unsigned long) p,
-			(vc->vc_cols - vc->vc_x) / 2);
+			vc->vc_cols - vc->vc_x);
 }
 
 static int softcursor_original;

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
