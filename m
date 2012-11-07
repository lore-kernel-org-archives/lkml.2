Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2KGQVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:21:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40576 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2KGQVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:21:17 -0500
Date: Wed, 7 Nov 2012 11:07:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
Cc: "key@linux.vnet.ibm.com" <key@linux.vnet.ibm.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend driver
Message-ID: <20121107160659.GH18615@phenom.dumpdata.com>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
 <20121106193921.GC28473@phenom.dumpdata.com>
 <509A6AA6.2000208@jhuapl.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509A6AA6.2000208@jhuapl.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 09:05:26AM -0500, Matthew Fioravante wrote:
> On 11/06/2012 02:39 PM, Konrad Rzeszutek Wilk wrote:
> >On Mon, Nov 05, 2012 at 10:09:57AM -0500, Matthew Fioravante wrote:
> >>This patch ports the xen vtpm frontend driver for linux
> >>from the linux-2.6.18-xen.hg tree to linux-stable.
> >So how does on test it ? Set it up? Use it? Is there some documentation
> >about it - if so it should be in the patch description.
> Thats actually a question I had. To use this driver now you have to
> use my vtpm mini-os domains which are currently being evaluated in
> the xen-devel mailing list. Once they are accepted I will submit a
> documentation update to the Xen tree.
> 
> Whats the best practice for documentation in this case? All in xen?
> Some linux/some xen? If the latter, how much goes in linux and
> where?

As much as possible. I would say stick both of them in Xen and in Linux.
And you can designate one of them as primary (say the Xen one) and
say in the Linux:

"For up-to-date information, please refer to XXYYZZ"

> >
> >I did a very very cursory look at it, see some of the comments.
> >
> >>
> >>+
> >>+
> >>+static inline struct transmission *transmission_alloc(void)
> >>+{
> >>+     return kzalloc(sizeof(struct transmission), GFP_ATOMIC);
> >>+}
> >>+
> >>+     static unsigned char *
> >
> >That is very weird tabbing? Did you run this patch through
> >scripts/checkpatch.pl ?
> Wow thats ugly. I ran the check script and it looks like it didn't
> pick this up. For some reason my editor wants to autoindent like
> that.
> Fixed.
> >
> >>+
> >>+static const struct file_operations vtpm_ops = {
> >>+     .owner = THIS_MODULE,
> >>+     .llseek = no_llseek,
> >>+     .open = tpm_open,
> >>+     .read = tpm_read,
> >>+     .write = tpm_write,
> >>+     .release = tpm_release,
> >>+};
> >>+
> >>+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
> >>+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
> >>+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
> >>+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
> >>+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
> >>+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
> >>+             NULL);
> >>+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
> >>+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> >>+
> >>+static struct attribute *vtpm_attrs[] = {
> >>+     &dev_attr_pubek.attr,
> >>+     &dev_attr_pcrs.attr,
> >>+     &dev_attr_enabled.attr,
> >>+     &dev_attr_active.attr,
> >>+     &dev_attr_owned.attr,
> >>+     &dev_attr_temp_deactivated.attr,
> >>+     &dev_attr_caps.attr,
> >>+     &dev_attr_cancel.attr,
> >>+     NULL,
> >So are these going to show up in SysFS? If so, there should also be
> >a corresponding file in Documentation/.../sysfs/something.
> These are similar to the entries made by the other tpm drivers. I
> don't see any documentation about those either. TPM maintainers, any
> guidance there?
> >
> >>+#include "tpm.h"
> >>+#include "tpm_vtpm.h"
> >>+
> >>+#undef DEBUG
> >>+
> >>+#define GRANT_INVALID_REF 0
> >Interesting. The 0 grant value is actually a valid one. I think you
> >want (-1ULL).
> Is it?
> drivers/block/xen-blkfront.c and
> drivers/net/xen-netfront.c
> 
> do the exact same thing

You are right. Just leave it as that then.

> >>+
> >>+     init_tpm_xenbus();
> >>+     return 0;
> >>+}
> >>+
> >>+
> >>+module_init(tpmif_init);
> >no module_exit?
> Will fix
> 
> 


