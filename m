Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab2CTBH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:07:58 -0400
Received: from soma.ebfe.org ([78.47.47.242]:34394 "EHLO soma.ebfe.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759149Ab2CTBHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:07:55 -0400
Date: Tue, 20 Mar 2012 02:07:39 +0100
From: Michael Gehring <mg@ebfe.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/vt: set_get_cmap() check user buffer
Message-ID: <20120320010544.GB22927@s755>
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

On Mon, Mar 19, 2012 at 04:48:39PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Mar 20, 2012 at 12:34:01AM +0100, Michael Gehring wrote:
> > set_get_cmap() ignores the result of {get,put}_user(), causing ioctl(vt,
> > {G,P}IO_CMAP, 0xdeadbeef) to silently fail.
> 
> Why not just check each return value, failing only if/when a specific
> write fails?

For the 'set' case, that would result in a partially updated default
colormap.

> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> > index e716839..176b2a1 100644
> > --- a/drivers/tty/vt/vt.c
> > +++ b/drivers/tty/vt/vt.c
> > @@ -3897,15 +3897,18 @@ static int set_get_cmap(unsigned char __user *arg, int set)
... 
> What's to keep this userspace buffer from becoming invalid after the
> check?  For some reason I thought we couldn't check beforehand like
> this, but I can't recall why at this specific moment.
> 
> And ugh, why do we have a function that does two things, like this?  The
> only thing we are "saving" is a single for loop by doing things this
> way, splitting it out into a set/get function, would make more sense in
> the end.


How about something like this (untested):


diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e716839..f0a881d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3928,24 +3928,53 @@ static int set_get_cmap(unsigned char __user *arg, int set)
 
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
+
+	for (i = k = 0; i < 16; i++) {
+		default_red[i] = colormap[k++];
+		default_grn[i] = colormap[k++];
+		default_blu[i] = colormap[k++];
+	}
+
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
+		if (!vc_cons_allocated(i))
+			continue;
+		for (j = k = 0; j < 16; j++) {
+		    vc_cons[i].d->vc_palette[k++] = default_red[j];
+		    vc_cons[i].d->vc_palette[k++] = default_grn[j];
+		    vc_cons[i].d->vc_palette[k++] = default_blu[j];
+		}
+		set_palette(vc_cons[i].d);
+	}
+
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
