Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab0ITNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:25:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:44096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab0ITNZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:25:56 -0400
Date: Mon, 20 Sep 2010 15:25:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Phil Turmel <philip@turmel.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Mat <jackdachef@gmail.com>, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
In-Reply-To: <4C975F79.9060609@turmel.org>
Message-ID: <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz> <4C975F79.9060609@turmel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Phil Turmel wrote:

> >>> The USB mouse I use with my laptop is causing a BUG when inserted.  It works at that
> >>> point, but if removed and re-inserted, it is ignored.  Also, after the 2nd insert,
> >>> other USB devices (like my thumb drive) are also ignored.
> >>>
> >>> [   37.450777] BUG: unable to handle kernel NULL pointer dereference at (null)
> >>> [   37.451148] IP: [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> >>> [   37.452036] PGD 1131a0067 PUD 113036067 PMD 0
> >>> [   37.452924] Oops: 0000 [#1] PREEMPT SMP
> >>> [   37.453336] last sysfs file: /sys/devices/platform/toshiba_acpi/backlight/toshiba/max_brightness
> >>> [   37.453336] CPU 1
> >>> [   37.453336] Modules linked in: tpm_infineon iwlagn iwlcore tifm_7xx1 tpm_tis toshiba_bluetooth toshiba_acpi tifm_core pcmcia sdhci_pci yenta_socket sdhci [last unloaded: scsi_wait_scan]
> >>> [   37.453336]
> >>> [   37.453336] Pid: 3117, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00166-g151b6a5 #28 Portable PC/TECRA A9
> >>> [   37.453336] RIP: 0010:[<ffffffff817d0991>]  [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> > 
> > Could please those of you who are able to reproduce the problem (from a 
> > quick test seems that I am not) use 'addr2line' utility to convert the RIP 
> > value (ffffffff817d0991 in this case) to the line number inside of 
> > hiddev_open(), so that we can see whether it's something behind 
> > usbhid_find_interface() causing NULL pointer dereference, or whether it is 
> > intfdata being NULL and thus going to hid->hiddev faults?
> 
> I couldn't quickly figure out how to recover the uncompressed kernel 
> from the vmlinuz (lzma) short of recompiling.  Here's the relevant 
> section of System.map if that's of any use....

vmlinux should be there in the directory after each build iteration.

> If there's a tool to expand vmlinuz => vmlinux, I love to hear about it.  
> If you need me to recompile to get what you need, I can do that.
> 
> > (sticking two printk()s in there should do the same as well).
> 
> If you give me a patch with exactly the debug stuff you want, I can 
> compile that instead.
> 
> Unfortunately, I have some work to do later today that I have to boot 
> this box into Windows for (CADD), so my compiling and testing window is 
> narrow (until tomorrow).

The patch below should at least tell us the same what addr2line would tell 
us. The dmesg lines preceeding the OOPS will be interesting. Thanks.



diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 681e620..3a5f097 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -270,17 +270,26 @@ static int hiddev_open(struct inode *inode, struct file *file)
 	struct hiddev *hiddev;
 	int res;
 
+	printk("A\n");
 	intf = usbhid_find_interface(iminor(inode));
+	printk("B\n");
 	if (!intf)
 		return -ENODEV;
+	printk("C\n");
 	hid = usb_get_intfdata(intf);
+	printk("D\n");
 	hiddev = hid->hiddev;
+	printk("E\n");
 
 	if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
 		return -ENOMEM;
+	printk("F\n");
 	mutex_init(&list->thread_lock);
+	printk("G\n");
 	list->hiddev = hiddev;
+	printk("H\n");
 	file->private_data = list;
+	printk("I\n");
 
 	/*
 	 * no need for locking because the USB major number
@@ -298,11 +307,14 @@ static int hiddev_open(struct inode *inode, struct file *file)
 		res = -ENODEV;
 		goto bail;
 	}
+	printk("J\n");
 
 	spin_lock_irq(&list->hiddev->list_lock);
 	list_add_tail(&list->node, &hiddev->list);
 	spin_unlock_irq(&list->hiddev->list_lock);
 
+	printk("K\n");
+
 	if (!list->hiddev->open++)
 		if (list->hiddev->exist) {
 			struct hid_device *hid = hiddev->hid;
@@ -313,10 +325,13 @@ static int hiddev_open(struct inode *inode, struct file *file)
 			}
 			usbhid_open(hid);
 		}
+	printk("L\n");
 	return 0;
 bail:
+	printk("M\n");
 	file->private_data = NULL;
 	kfree(list);
+	printk("N\n");
 	return res;
 }
 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
