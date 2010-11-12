Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab0KLRTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:19:07 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45714 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755953Ab0KLRTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:19:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hNbJnTX2Qkh0BfoUfHxZOrM/WxM0t3IrOtLUEKOxKjlfQKD/RxQR4MloCtSykWiTRAShY0BRHL9EnOLmgYK+rafyhK6H8wcq7FBrVJ4BlSfwuWA0u5Dqoe3P5xhTNvLc;
Date: Fri, 12 Nov 2010 09:18:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@amd64.org>, Stefan Becker <chemobejk@gmail.com>,
        Chuck Ebbert <cebbert@redhat.com>,
        Fabrice Bellet <fabrice@bellet.info>, Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] PCI: fix pci_bus_alloc_resource() hang, prefer
 positive decode
Message-ID: <20101112091858.3db4787a@jbarnes-desktop>
In-Reply-To: <20101110172607.2537.10985.stgit@bob.kio>
References: <20101110172607.2537.10985.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 10:26:07 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> When a PCI bus has two resources with the same start/end, e.g.,
> 
>     pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd7ffffff pref]
>     pci_bus 0000:04: resource 7 [mem 0xd0000000-0xd7ffffff]
> 
> the previous pci_bus_find_resource_prev() implementation would alternate
> between them forever:
> 
>     pci_bus_find_resource_prev(... [mem 0xd0000000-0xd7ffffff pref])
>         returns [mem 0xd0000000-0xd7ffffff]
>     pci_bus_find_resource_prev(... [mem 0xd0000000-0xd7ffffff])
>         returns [mem 0xd0000000-0xd7ffffff pref]
>     pci_bus_find_resource_prev(... [mem 0xd0000000-0xd7ffffff pref])
>         returns [mem 0xd0000000-0xd7ffffff]
>     ...
> 
> This happened because there was no ordering between two resources with the
> same start and end.  A resource that had the same start and end as the
> cursor, but was not itself the cursor, was considered to be before the
> cursor.
> 
> This patch fixes the hang by making a fixed ordering between any two
> resources.
> 
> In addition, it tries to allocate from positively decoded regions before
> using any subtractively decoded resources.  This means we will use a
> positive decode region before a subtractive decode one, even if it means
> using a smaller address.
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=22062
> Reported-by: Borislav Petkov <bp@amd64.org>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
