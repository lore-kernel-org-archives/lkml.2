Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1BBJiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:38:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1BBJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:38:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Wed, 2 Feb 2011 10:37:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Bernhard Walle <walle@corscience.de>, dbrownell@users.sourceforge.net,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
References: <1296550966-4015-1-git-send-email-walle@corscience.de> <20110202043944.GG29148@angua.secretlab.ca>
In-Reply-To: <20110202043944.GG29148@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102021037.14364.arnd@arndb.de>
X-Provags-ID: V02:K0:gQbxEFyRgBOVWN7TDObYaQz9v36KnfGdS37vqV58qQQ
 yYICLQYAM1IWRzR8z4xD7tLjBYWTkKITr1atBfmjtku+92mlOn
 Y4XyVFgpy037kVDnL48KHARC/Ml2EBjJNavfvPPafrwaCjBRxL
 8gB4z5DEbAZsJRDnjY2BgVvpuRFlSxgEihMGpyHYWBV1WMQmoq
 /g9CibRyapLayInXKmFKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 February 2011, Grant Likely wrote:
> On Tue, Feb 01, 2011 at 10:02:46AM +0100, Bernhard Walle wrote:
> > Add the compat_ioctl for operations on /dev/spi* so that 32 bit
> > userspace applications can access SPI. As far as I can see all data
> > structure are already prepared for that, so no additional conversion has
> > to be done.
> > 
> > My use case is MIPS with N32 userspace ABI and toolchain, and that was
> > also the platform where I tested it successfully (Cavium Octeon).
> > 
> > Signed-off-by: Bernhard Walle <walle@corscience.de>
> 
> Arnd, can you please give your opinion on this one?  I haven't fully
> got my head around the subtleties of 32/64 bit file_operations.

The patch is correct on everything except s390, which does not have SPI.
The only thing that is missing for s390 is a pointer conversion of the ioctl
argument, like:

static long     
compat_spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	return spidev_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
}

Some years ago, I proposed adding a common

#ifdef CONFIG_COMPAT
long generic_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	if (!file->unlocked_ioctl)
		return -ENOTTY;
	return filp->f_ops->unlocked_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
}
#else
#define generic_compat_ioctl NULL
#endif

for this purpose, but it never made it in. Maybe I should try again.

	Arnd
