Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2HPNRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:17:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57859 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2HPNRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:17:22 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Joel Becker'" <jlbec@evilplan.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
 <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
 <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
In-reply-to: <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
Subject: RE: [RFC 0/2] USB gadget - configfs
Date: Thu, 16 Aug 2012 15:17:12 +0200
Message-id: <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac16veOhtEySPd/STfK7xUPv+ruBFQA8MCpQ
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joel,

Thank you for your reply. Please find comments inline.

On Wednesday, August 15, 2012 10:14 AM Joel Becker wrote:

<snip>

> > So, the config item corresponding to the lun becomes depended on during
> > the write file operation, the same with undepend. Can this be expressed
> > with configfs_depend/undepend_item()? Your code in fs/configfs/dir.c
> > contains a warning not to call the configfs_depend_item()
> > from a configfs callback.
> > In this case, is store_attribute a configfs callback?
> 

<snip>

> 	Yes, attribute store is a callback.  So what should you do?
> This is where my understanding of your setup logic fails me.  At first I
> thought fsg_bind_function() was the right place, because it is where you
> expect the LUNs to already be configured.  But it is, in turn, called
> underneath another configfs callback (ufg_gadget_grp_store_connect()).
> 	Can you help me understand the userspace steps that are used to
> set up a gadget?  The way I read the code, there is some software in the
> gadget that sets up the LUN mappings; that is, the host has no idea
> "lun01" is backed by a file named "foo".  So, if you had a gadget that
> just exposed a single LUN, it would have some userspace software at
> startup that sets fua=1, removable=0, ro=0, file="foo".  At some future
> point, the host connects to the gadget.  At this point, lun01 is
> connected to the host, and it had better not disappear.  What part of
> the code reacts to the host connect?  This is the "open" of the LUN
> where I think you should be locking out.

>From userspace the procedure to set up a gadget looks like this:

(please note that for testing I use _very_ short names like
G1, C1, F1; these are not mandatory and, as already pointed out
by some, more descriptive names should be used)

$ insmod g_usb_functions.ko
$ mount -t configfs none /cfg
$ mkdir -p /cfg/usb-function-gadget/G1/C1/F1
$ echo -n <some id> > /cfg/usb-function-gadget/G1/idVendor
$ echo -n <some id> > /cfg/usb-function-gadget/G1/idProduct
$ echo -n 0xff > /cfg/usb-function-gadget/G1/bcdDevice
$ echo Manufacturer > /cfg/usb-function-gadget/G1/iManufacturer
$ echo 123abc > /cfg/usb-function-gadget/G1/iSerialNumber
$ echo Gadget > /cfg/usb-function-gadget/G1/iProduct

$ echo -n f_mass_storage > /cfg/usb-function-gadget/G1/C1/F1/name
$ mkdir /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage
$ echo -n 1 > /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/luns
$ mkdir /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0
$ echo -n /root/file.img >
/cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0/file

$ echo -n 1 > /cfg/usb-function-gadget/G1/connect

The mapping between luns and their backing files is maintained in
alloc_fsg_lun,
f_mass_storage.c; the function needs improvement. The intended logic is not
to
allow more than 1 lun of the same name at the same time.

A lun is "opened" on storing the "file" attribute of the lun, it is in
fsg_lun_store_file, storage_common.c. So, again, this is a configfs
callback.

On storing the connect attribute, the following happens: a composite driver
is probed, then all the configurations are iterated over, their functions
being bound in turn. After the gadget is set up this way, the host notices
connecting a new mass storage device.

So it seems the only chance to call config_item_depend is in a configfs
callback. Or is it?

Thanks,

Andrzej




