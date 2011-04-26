Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1DZPBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:01:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55422 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab1DZPBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=eAXk7oLUIUKwUtRCb3yDOzNcFJVoCMOCKyYwKbSpo+l5OvMMWUBoXmIaqk3sYekltm
         mxBYOP4gqYpkskpK9LN1dJevGhy+Km6ajQ6wnvkYD20r0P4deMJYQdkkkynPUv0DErMa
         leYFOEcsRhiVheBSpm1b47CChPF+T1zNM6vqI=
MIME-Version: 1.0
In-Reply-To: <201102021700.20683.arnd@arndb.de>
References: <201102021700.20683.arnd@arndb.de>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 26 Apr 2011 20:30:51 +0530
X-Google-Sender-Auth: BUSRMwtlsHnayI91Ikvwuk-6ock
Message-ID: <BANLkTi=-DFfdiBKZzRBxF-yMJFtWnzuk1g@mail.gmail.com>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 21:30, Arnd Bergmann <arnd@arndb.de> wrote:
> As noticed by Peter Maydell, the EHCI device driver in Linux gets
> miscompiled by some versions of arm-gcc (still need to find out which)
> due to a combination of problems:
>
> 1. In include/linux/usb/ehci_def.h, struct ehci_caps is defined
> with __attribute__((packed)), for no good reason. This is clearly
> a bug and needs to get fixed, but other drivers have the same bug

Was a patch submitted for this?  I couldn't find it in the archives.
U-Boot seems to be fixing this by adding an "aligned(4)" instead
of removing the packed:

http://www.mail-archive.com/u-boot@lists.denx.de/msg51418.html

> and it used to work. The attribute forces byte access on all members
> accessed through pointer dereference, which is not allowed on
> MMIO accesses in general. The specific code triggering the problem
> in Peter's case is in ehci-omap.c:
>        omap->ehci->regs = hcd->regs
>                + HC_LENGTH(readl(&omap->ehci->caps->hc_capbase));

In my case it's this writel() in ehci-hub.c that gets chopped into
strbs:

	/* force reset to complete */
	ehci_writel(ehci, temp & ~(PORT_RWC_BITS | PORT_RESET),
				status_reg);
