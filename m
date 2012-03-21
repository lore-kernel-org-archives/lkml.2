Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2CUA1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:27:08 -0400
Received: from soma.ebfe.org ([78.47.47.242]:34424 "EHLO soma.ebfe.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab2CUA1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:27:06 -0400
Date: Wed, 21 Mar 2012 01:26:45 +0100
From: Michael Gehring <mg@ebfe.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Michael Gehring <mg@ebfe.org>
Subject: [PATCH] tty/vt: handle bad user buffer in {G,P}IO_CMAP ioctl
Message-ID: <20120321002645.GA1764@s755>
Mail-Followup-To: Michael Gehring <mg@ebfe.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <1332200041-31052-1-git-send-email-mg@ebfe.org>
 <20120319234839.GA26931@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120319234839.GA26931@kroah.com>
User-Agent: Mutt/ (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_get_cmap() ignored the result of {get,put}_user(), causing ioctl(vt,
{G,P}IO_CMAP, 0xdeadbeef) to silently fail.

Another side effect of this: calling the PIO_CMAP ioctl with an invalid
buffer would zero the default colormap and the palette for all vts (all
colors set to black).

Leave the default colormap intact and return -EFAULT when
reading/writing to the userspace buffer fails.

Signed-off-by: Michael Gehring <mg@ebfe.org>
---
 drivers/tty/vt/vt.c |   68 ++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e716839..49c2dec 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3891,36 +3891,6 @@ static void set_palette(struct vc_data *vc)
 		vc->vc_sw->con_set_palette(vc, color_table);
 }
 
-static int set_get_cmap(unsigned char __user *arg, int set)
-{
-    int i, j, k;
-
-    WARN_CONSOLE_UNLOCKED();
-
-    for (i = 0; i < 16; i++)
-	if (set) {
-	    get_user(default_red[i], arg++);
-	    get_user(default_grn[i], arg++);
-	    get_user(default_blu[i], arg++);
-	} else {
-	    put_user(default_red[i], arg++);
-	    put_user(default_grn[i], arg++);
-	    put_user(default_blu[i], arg++);
-	}
-    if (set) {
-	for (i = 0; i < MAX_NR_CONSOLES; i++)
-	    if (vc_cons_allocated(i)) {
-		for (j = k = 0; j < 16; j++) {
-		    vc_cons[i].d->vc_palette[k++] = default_red[j];
-		    vc_cons[i].d->vc_palette[k++] = default_grn[j];
-		    vc_cons[i].d->vc_palette[k++] = default_blu[j];
-		}
-		set_palette(vc_cons[i].d);
-	    }
-    }
-    return 0;
-}
-
 /*
  * Load palette into the DAC registers. arg points to a colour
  * map, 3 bytes per colour, 16 colours, range from 0 to 255.
@@ -3928,24 +3898,50 @@ static int set_get_cmap(unsigned char __user *arg, int set)
 
 int con_set_cmap(unsigned char __user *arg)
 {
-	int rc;
+	int i, j, k;
+	unsigned char colormap[3*16];
+
+	if (copy_from_user(colormap, arg, sizeof(colormap)))
+		return -EFAULT;
 
 	console_lock();
-	rc = set_get_cmap (arg,1);
+	for (i = k = 0; i < 16; i++) {
+		default_red[i] = colormap[k++];
+		default_grn[i] = colormap[k++];
+		default_blu[i] = colormap[k++];
+	}
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
+		if (!vc_cons_allocated(i))
+			continue;
+		for (j = k = 0; j < 16; j++) {
+			vc_cons[i].d->vc_palette[k++] = default_red[j];
+			vc_cons[i].d->vc_palette[k++] = default_grn[j];
+			vc_cons[i].d->vc_palette[k++] = default_blu[j];
+		}
+		set_palette(vc_cons[i].d);
+	}
 	console_unlock();
 
-	return rc;
+	return 0;
 }
 
 int con_get_cmap(unsigned char __user *arg)
 {
-	int rc;
+	int i, k;
+	unsigned char colormap[3*16];
 
 	console_lock();
-	rc = set_get_cmap (arg,0);
+	for (i = k = 0; i < 16; i++) {
+		colormap[k++] = default_red[i];
+		colormap[k++] = default_grn[i];
+		colormap[k++] = default_blu[i];
+	}
 	console_unlock();
 
-	return rc;
+	if (copy_to_user(arg, colormap, sizeof(colormap)))
+		return -EFAULT;
+
+	return 0;
 }
 
 void reset_palette(struct vc_data *vc)
-- 
1.7.9.4

