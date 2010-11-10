Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0KJSod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:44:33 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:44916 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753195Ab0KJSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:44:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OJYnTBw+WzKxG/zF/mNOElM6DGHTc0ABo/OO4/9sfGUV1D5gT3X1gDG6ADAZyJlLIf0t/+RvyTLCfA9T3VnT3mZqQOZiDFv31YhHsPNJGFaJKBg5mhM6P+oM+n8J7I6I;
Date: Wed, 10 Nov 2010 10:44:34 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: gerhard.wichert@ts.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] fix size checks for mmap() on /proc/bus/pci files
 (updated)
Message-ID: <20101110104434.6ed20d33@jbarnes-x201>
In-Reply-To: <1289383401-1357-1-git-send-email-martin.wilck@ts.fujitsu.com>
References: <20101109084206.1b6ac66a@jbarnes-desktop>
	<1289383401-1357-1-git-send-email-martin.wilck@ts.fujitsu.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 69.89.22.128 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 11:03:21 +0100
Martin Wilck <martin.wilck@ts.fujitsu.com> wrote:

> The checks for valid mmaps of PCI resources made
> through /proc/bus/pci files that were introduced in
> 9eff02e2042f96fb2aedd02e032eca1c5333d767 have several problems:
> 
> 1. mmap() calls on /proc/bus/pci files are made with real file
> offsets > 0, whereas under /sys/bus/pci/devices, the start of the
> resource corresponds to offset 0. This may lead to false negatives in
> pci_mmap_fits(), which implicitly assumes the /sys/bus/pci/devices
> layout.
> 
> 2. The loop in proc_bus_pci_mmap doesn't skip empty resouces. This
> leads to false positives, because pci_mmap_fits() doesn't treat empty
> resources correctly (the calculated size is 1 <<
> (8*sizeof(resource_size_t)-PAGE_SHIFT) in this case!).
> 
> 3. If a user maps resources with BAR > 0, pci_mmap_fits will emit
> bogus WARNINGS for the first resources that don't fit until the
> correct one is found.
> 
> On many controllers the first 2-4 BARs are used, and the others are
> empty. In this case, an mmap attempt will first fail on the non-empty
> BARs (including the "right" BAR because of 1.) and emit bogus
> WARNINGS because of 3., and finally succeed on the first empty BAR
> because of 2. This is certainly not the intended behaviour.
> 
> This patch addresses all 3 issues.
> Updated with an enum type for the additional parameter for
> pci_mmap_fits().
> 
> Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>

Thanks Martin, I'll push this into my for-linus branch for 2.6.37; may
as well cc: stable as well, since this is a long standing bug.

-- 
Jesse Barnes, Intel Open Source Technology Center
