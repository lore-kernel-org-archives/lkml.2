Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0FINQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 09:16:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64524 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab0FINQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 09:16:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Topcliff PHUB: Add The Packet Hub driver [1/2]
Date: Wed, 9 Jun 2010 15:16:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       andrew.chih.howe.khor@intel.com, "LKML" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <000501cae2eb$de97e950$66f8800a@maildom.okisemi.com> <201004231657.57466.arnd@arndb.de> <000901cb07ad$234e6cf0$66f8800a@maildom.okisemi.com>
In-Reply-To: <000901cb07ad$234e6cf0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006091516.13246.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+JGRCk43V0VruB1+anFDx3iM+KTThl1Nmh4bC
 TXgw5CkCE8Oj9SPBkJthyN5BmZPpjJbAOX81jnivIzt5q0Uex/
 lNv5oUqVXJ8ecyzYB6gLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 June 2010, Masayuki Ohtake wrote:

> We have added our comment for your email in line.

ok, thanks for the update

> If you have any question, let me know.

One small comment from me, plus more background on the ioctl:

> > The definition of struct pch_phub_reqt is problematic because
> > it contains members of type 'unsigned long'. This means that
> > a 32 bit user process uses a different data structure than a
> > 64 bit kernel.
> >
> > Ideally, you only pass a single integer as an ioctl argument.
> > There are cases where it needs to be a data structure, but
> > if that happens, you should only use members types like __u32
> > or __u64, not long or pointer.
> We have defined as u32 type.

Note that public data headers should use '__u32' instead of 'u32',
because the 'u32' type is not available in the exported version
of linux/types.h.

> > My feeling is that this ioctl interface is too
> > low-level in general. You only export access to specific
> > registers, not to functionality exposed by them.
> > The best kernel interfaces are defined in a way that
> > is independent of the underlying hardware and
> > convert generic commands into device specific commands.
> >
> > If you really want to allow direct register access,
> > a simpler way would be to map the memory into the user
> > address space using the mmap() operation and not
> > provide any ioctl commands.
> Packet Hub has function accessing many resisters.
> Thus, we think current spec is better.

Getting the interface right is by far the most important
part in a driver submission, and often the hardest part.

Giving register-level hardware access to random user space
applications for the PHUB essentially means that you
are forcing the hardware design to become stable for all
eternity because all tools that use this interface (whether
written by you or by other people) need to keep working on
future generations of the hardware as well.

This is generally considered a very bad idea, so I think
you should drop the IOCTL_PHUB_{READ,WRITE,MODIFY}_REG
ioctl commands for now if you want to get your driver
merged quickly, and then we can find a way to do what
it's meant for in a better way.

Regarding the other ioctl commands, I still have a few
comments that I did not mention at first:

>+int pch_phub_ioctl(struct inode *inode, struct file *file,
>+			unsigned int cmd, unsigned long arg)
>+{
>+	int ret_value = 0;
>+	struct pch_phub_reqt *p_pch_phub_reqt;
>+	unsigned long addr_offset;
>+	unsigned long data;
>+	unsigned long mask;
>+
>+	if (pch_phub_suspended == true) {
>+		dev_dbg(dev_dbg, "pch_phub_ioctl : "
>+			"suspend initiated returning =%d\n", -EPERM);
>+		ret_value = -EPERM;
>+		goto return_ioctrl;
>+	}
>+
>+	p_pch_phub_reqt = (struct pch_phub_reqt *)arg;
>+	ret_value = copy_from_user((void *)&addr_offset,
>+				(void *)&p_pch_phub_reqt->addr_offset,
>+				sizeof(addr_offset));
>+	if (ret_value) {
>+		dev_dbg(dev_dbg, "pch_phub_ioctl : "
>+			"copy_from_user fail returning =%d\n", -EFAULT);
>+		ret_value = -EFAULT;
>+		goto return_ioctrl;
>+	}

The pch_phub_reqt data structure does not really make sense for
commands other than IOCTL_PHUB_READ_MODIFY_WRITE_REG and causes
more problems, see below.

Moreover, the type casts are incorrect because they are
missing the __user address space modifier. The casts can
simply be removed, and the variable declared as
e.g. 'struct pch_phub_reqt __user *p_pch_phub_reqt;'.

I'd recommend using the 'sparse' tool to check your
source code to find problems like this. Simply install
sparse and run

make C=1 drivers/char/pch_phub/

>+	dev_dbg(dev_dbg, "pch_phub_ioctl : "
>+		"copy_from_user returns =%d\n", ret_value);

The 'dev_dbg' variable does not seem to get initialized anywhere
in the code. In a clean driver, it should not be a global variable
anyway but refer to the object that you are operating on, e.g.
the pci device that has been opened.

>+	switch (cmd) {
>+	case IOCTL_PHUB_READ_REG:

>+	case IOCTL_PHUB_WRITE_REG:

>+	case IOCTL_PHUB_READ_MODIFY_WRITE_REG:


As mentioned, I'd just remove these commands for now. When a specific
functionality is needed, you can always add another ioctl command
or find another way to do it.

>+	case IOCTL_PHUB_READ_OROM:
>+		ret_value = pch_phub_read_serial_rom(addr_offset,
>+							(unsigned char *)&data);
>+		if (ret_value) {
>+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
>+				"pch_phub_read_serial_rom =%d\n", -EFAULT);
>+			ret_value = -EFAULT;
>+			break;
>+		} else {
>+			dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
>+				"pch_phub_read_serial_rom successfully\n");
>+		}
>+		ret_value = copy_to_user((void *)&p_pch_phub_reqt->data,
>+						(void *)&data, sizeof(data));
>+		if (ret_value) {
>+			dev_dbg(dev_dbg, "pch_phub_ioctl : "
>+				"copy_to_user fail returning =%d\n", -EFAULT);
>+			ret_value = -EFAULT;
>+			break;
>+		}
>+		break;

This is a very indirect way to access a rom. I'd recommend doing
read and write file operations for this instead of going through the
ioctl. When you do that, you can simply do 'cat /dev/topcliff-phub > romdump'
to read the entire contents, or have other code access the contents
bytewise. If teh OROM contents are specific to the ethernet function,
you may also just implement the ethtool operations for it, as shown below.

>+	case IOCTL_PHUB_READ_MAC_ADDR:
>+		pch_phub_read_gbe_mac_addr(addr_offset, (unsigned char *)&data);
>+		dev_dbg(dev_dbg, "pch_phub_ioctl : Invoked "
>+				"pch_phub_read_gbe_mac_addr successfully\n");
>+
>+		ret_value = copy_to_user((void *)&p_pch_phub_reqt->data,
>+						 (void *)&data, sizeof(data));
>+		if (ret_value) {
>+			dev_dbg(dev_dbg, "pch_phub_ioctl : copy_to_user fail "
>+					"returning =%d\n", -EFAULT);
>+			ret_value = -EFAULT;
>+			break;
>+		}
>+		break;

I believe this really belongs into the ethernet driver, using the
ethtool_ops->get_eeprom operation as other ethernet drivers do the
same thing.

	Arnd
