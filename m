Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0LVIhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:37:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:29582 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0LVIhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:37:23 -0500
X-IronPort-AV: E=Sophos;i="4.60,212,1291611600"; 
   d="scan'208";a="127997534"
Subject: Re: [Xen-devel] [RFC PATCH v1] Consider void entries in the P2M as
 1-1 mapping.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Dec 2010 08:36:55 +0000
Message-ID: <1293007015.3998.25.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 21:37 +0000, Konrad Rzeszutek Wilk wrote:
> In the past we used to think of those regions as "missing" and under
> the ownership of the balloon code. But the balloon code only operates
> on a specific region. This region is in lastE820 RAM page (basically
> any region past nr_pages is considered balloon type page). 

That is true at start of day but once the system is up and running the
balloon driver can make a hole for anything which can be returned by
alloc_page.

The following descriptions seem to consider this correctly but I just
wanted to clarify.

I don't think it's necessarily the last E820 RAM page either, that's
just what the tools today happen to build. In principal the tools could
push down a holey e820 (e.g. with PCI holes prepunched etc) and boot the
domain ballooned down such that the N-2, N-3 e820 RAM regions are above
nr_pages too.

> This patchset considers the void entries as "identity" and for balloon
> pages you have to set the PFNs to be "missing". This means that the
> void entries are now considered 1-1, so for PFNs which exist in large
> gaps of the P2M space will return the same PFN.

I would naively have expected that a missing entry indicated an
invalid/missing entry rather than an identity region, it just seems like
the safer default since we are (maybe) more likely to catch an
INVALID_P2M_ENTRY before handing it to the hypervisor and getting
ourselves shot.

In that case the identity regions would need to be explicitly
registered, is that harder to do?

I guess we could register any hole or explicit non-RAM region in the
e820 as identity but do we sometimes see I/O memory above the top of the
e820 or is there some other problem I'm not thinking of?

> The xen/mmu.c code where it deals with _PAGE_IOMAP can be removed, but
> to guard against regressions or bugs lets take it one patchset at a
> time.

Could we have a WARN_ON(_PAGE_IOMAP && !PAGE_IDENTITY) (or whatever the
predicates really are) in some relevant places in mmu.c?

Ian.

