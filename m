Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab2C2Tiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:38:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55974 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2C2Tik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:38:40 -0400
Date: Thu, 29 Mar 2012 12:38:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-ID: <20120329193835.GA11820@kroah.com>
References: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
 <1332748641.2836.8.camel@dabdike>
 <20120326140721.GA19827@kroah.com>
 <20120327221721.GA3233@p183.telecom.by>
 <20120327222216.GB469@kroah.com>
 <20120327223510.GB3233@p183.telecom.by>
 <20120327223939.GC3233@p183.telecom.by>
MIME-Version: 1.0
In-Reply-To: <20120327223939.GC3233@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 01:39:39AM +0300, Alexey Dobriyan wrote:
> On Wed, Mar 28, 2012 at 01:35:10AM +0300, Alexey Dobriyan wrote:
> > On Tue, Mar 27, 2012 at 03:22:16PM -0700, Greg KH wrote:
> 
> > > > The amount of code once removed from staging prevented me from doing
> > > > any work on them.
> > > > 
> > > > Looking at staging ->read_proc users this is going to be a problem for
> > > > its removal. :-(
> > > 
> > > Why?
> > 
> > Because if staging does count, I can't remove the interface
> > without breaking allmodconfig and it would take forever to convert
> > staging stuff. I don't have energy to do it anymore.
> > Mainline still have several _hard_ ->read_proc conversions.
> > I've tried several times and failed.
> > 
> > If staging doesn't count, I will break allmodconfig and all those nasty
> > emails will show up anyway implying that staging does count.
> 
> It's comparable to what mainline has besides staging.
> I'm talking about this.
> 
> $ grep -e read_proc -w -n -r drivers/staging/
> drivers/staging/comedi/proc.c:92:               comedi_proc->read_proc = comedi_read;
> drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:298:      e->read_proc = show_debug_level;
> drivers/staging/serial/68360serial.c:2428:      /* .read_proc = rs_360_read_proc, */
> drivers/staging/rtl8192e/rtllib_module.c:262:   e->read_proc = show_debug_level;

No you are not at all.  That's not the function to grep for, I have no
idea what you are trying to prove with this grep, but it is flat out
wrong.

Thanks to Gerard, I've looked at your patches, and it's obvious that you
didn't look to see what would needed to be done to convert the
drivers/staging/ drivers to your new interface.

In short, it's trivial, and it looks like you could take one of your
existing patches, rename the file, and it would apply cleanly to two of
the drivers, so you are already 2/3 done.

The other one is even simpler than that, I've included it below for your
perusal.

If you need me to, I can write these patches, but I can't build or test
them, as I do not see the proc_ops field in the scsi_host_template in
Linus's tree.

It's just part of changing apis, if you want to break them, then fix up
the existing users.  If you need help with existing users, just ask.

So feel free to take my patch below for your patch series, and if you
want me to fix up the other two, just ask.

thanks,

greg k-h
----------------------------

Subject: staging: rts_pstor: convert to scsi proc_ops

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index a7feb3e..114971c 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -24,6 +24,8 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include "rtsx.h"
 #include "rtsx_chip.h"
@@ -128,16 +130,11 @@ static int slave_configure(struct scsi_device *sdev)
 /* we use this macro to help us write into the buffer */
 #undef SPRINTF
 #define SPRINTF(args...) \
-	do { if (pos < buffer+length) pos += sprintf(pos, ## args); } while (0)
+	seq_printf(m, ## args)
 
-static int proc_info(struct Scsi_Host *host, char *buffer,
-		char **start, off_t offset, int length, int inout)
+static int proc_show(struct seq_file *m, void *v)
 {
-	char *pos = buffer;
-
-	/* if someone is sending us data, just throw it away */
-	if (inout)
-		return length;
+	struct Scsi_Host *host = m->private;
 
 	/* print the controller name */
 	SPRINTF("   Host scsi%d: %s\n", host->host_no, CR_DRIVER_NAME);
@@ -146,20 +143,21 @@ static int proc_info(struct Scsi_Host *host, char *buffer,
 	SPRINTF("       Vendor: Realtek Corp.\n");
 	SPRINTF("      Product: PCIE Card Reader\n");
 	SPRINTF("      Version: %s\n", DRIVER_VERSION);
+	return 0;
+}
 
-	/*
-	 * Calculate start of next buffer, and return value.
-	 */
-	*start = buffer + offset;
-
-	if ((pos - buffer) < offset)
-		return 0;
-	else if ((pos - buffer - offset) < length)
-		return pos - buffer - offset;
-	else
-		return length;
+static int proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations proc_ops = {
+	.open		= proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* queue a command */
 /* This is always called with scsi_lock(host) held */
 static int queuecommand_lck(struct scsi_cmnd *srb,
@@ -255,7 +253,7 @@ static struct scsi_host_template rtsx_host_template = {
 	/* basic userland interface stuff */
 	.name =				CR_DRIVER_NAME,
 	.proc_name =			CR_DRIVER_NAME,
-	.proc_info =			proc_info,
+	.proc_ops = 			&proc_ops,
 	.info =				host_info,
 
 	/* command interface -- queued only */
