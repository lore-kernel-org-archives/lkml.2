Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab1FAUyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:54:43 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:42214
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759267Ab1FAUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:54:41 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz1521M1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 1 Jun 2011 15:54:30 -0500
From: Scott Wood <scottwood@freescale.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Timur Tabi <timur@freescale.com>, <kumar.gala@freescale.com>,
        <linux-kernel@vger.kernel.org>, <akpm@kernel.org>,
        <linux-console@vger.kernel.org>, <greg@kroah.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
Message-ID: <20110601155430.4d5aa6de@schlenkerla.am.freescale.net>
In-Reply-To: <20110601204618.32190be9@lxorguk.ukuu.org.uk>
References: <1306953337-15698-1-git-send-email-timur@freescale.com>
	<20110601204618.32190be9@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 20:46:18 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > +static char *strdup_from_user(const char __user *ustr, size_t max)
> > +{
> > +	size_t len;
> > +	char *str;
> > +
> > +	len = strnlen_user(ustr, max);
> > +	if (len > max)
> > +		return ERR_PTR(-ENAMETOOLONG);

if (len >= max)

> > +	str = kmalloc(len, GFP_KERNEL);
> > +	if (!str)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	if (copy_from_user(str, ustr, len))
> > +		return ERR_PTR(-EFAULT);
> > +
> > +	return str;
> > +}

Memory leak on the EFAULT path

If strnlen_user gets an exception, it'll return zero, causing a
zero-length kmalloc.  Will kmalloc(0, ...) return NULL?  If so, a bad
user pointer would result in -ENOMEM rather than -EFAULT.

> > +	default:
> > +		pr_debug("fsl-hv: unknown ioctl %u\n", cmd);
> > +		ret = -ENOIOCTLCMD;
> 
> -ENOTTY
> 
> (-ENOIOCTLCMD is an internal indicator designed so driver layers can say
> 'dunno, try the next layer up')

There's a check for -ENOIOCTLCMD in vfs_ioctl() -- though it generates
-EINVAL rather than -ENOTTY (why?).

Using -ENOIOCTLCMD consistently would make it easier to refactor a
toplevel ioctl handler into a nested one, plus consistency is good in
general.

> > + * We use the same interrupt handler for all doorbells.  Whenever a doorbell
> > + * is rung, and we receive an interrupt, we just put the handle for that
> > + * doorbell (passed to us as *data) into all of the queues.
> 
> I wonder if these should be presented as IRQs or whether that makes no
> sense ?

They are presented as IRQs.  This driver registers the same handler for all
doorbell IRQs, and pipes the notifications up to userspace, but you could
also directly register a kernel handler for an individual doorbell IRQ.

> > +static irqreturn_t fsl_hv_shutdown_isr(int irq, void *data)
> > +{
> > +	schedule_work(&power_off);
> > +
> > +	/* We should never get here */
> 
> Probably worth printing something if you do (panic(...) ?)

I don't think the comment is accurate.  We've just scheduled the workqueue,
not waited for it to complete.

Timur, shouldn't this schedule orderly_poweroff rather than
kernel_power_off?

-Scott

