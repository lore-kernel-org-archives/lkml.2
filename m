Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1JYROs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1JYROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:14:46 -0400
Subject: Re: linux-next: build failure after merge of the pci tree
From: Myron Stowe <mstowe@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
In-Reply-To: <20111026004430.6725033af543cb336a786a3e@canb.auug.org.au>
References: <20111026004430.6725033af543cb336a786a3e@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 11:14:38 -0600
Message-ID: <1319562878.2417.18.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 00:44 +1100, Stephen Rothwell wrote:
> Hi Jesse,
> 
> After merging the pci tree, today's linux-next build (powerpc
> pseries_defconfig) failed like this:
> 
> drivers/pci/pci.c:2605: error: redefinition of 'pcibios_set_master'
> arch/powerpc/include/asm/pci.h:49: note: previous definition of
> 'pcibios_set_master' was here
> 
> Presumably caused by commit 481da3e3d53e ("PCI: Pull PCI 'latency
> timer'
> setup up into the core").
> 
Yes, commit 481da3e3d53e is the culprit here.  I was trying to not
modify architectures that had inline nop functions but it's now obvious
that the compiler sees the architecture specific include files before it
sees the __weak def I added in drivers/pci/pci.c

I think the best approach here is to remove the inline versions of
pcibios_set_master() for the architectures with inline nops.  This will
effectively add the new generic code to those architectures; which will
be a slight change in behavior for them.  This has the benefit of ending
up with most architectures utilizing the new generic code and only those
that absolutely must having specific versions of pcibios_set_master()
that over-rides the generic __weak code.  If we encounter issues going
forward with this approach for a specific architecture then we can add a
non-weak empty version back in for it.

If anyone has issues with such an approach please let me know.  In the
mean time -

I'll work on modifying the patch series accordingly.

Jesse: can you drop the series from pci-2.6/linux-next and I'll re-post
with v2?

Stephen: do you need me to do anything here or can you also drop the
series from linux-next?

Myron

