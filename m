Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1DAL3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:29:51 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:50549 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1DAL3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:29:50 -0400
X-IronPort-AV: E=Sophos;i="4.63,282,1299456000"; 
   d="scan'208";a="5094522"
Date: Fri, 1 Apr 2011 12:30:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ingo Molnar <mingo@elte.hu>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
In-Reply-To: <20110401062338.GA6434@elte.hu>
Message-ID: <alpine.DEB.2.00.1104011212070.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <20110401062338.GA6434@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, Ingo Molnar wrote:
> 
> * Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > Save cr4 to mmu_cr4_features at boot time
> > 
> > This patch fixes a freeze when resuming from hibernation, introduced by
> > "x86: Cleanup highmap after brk is concluded", commit id
> > e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e.
> > This patch should be backported to all the stable tree where the
> > offending commit is present.
> 
> No, the offending commit should be reverted from -stable. It's not at all clear 
> yet why this fix patch helps.

e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e removes cleanup_highmap_brk_end
because the initial mapping of the region between _brk_end and _end is
going to be cleared by cleanup_highmap instead.

However cleanup_highmap_brk_end was not only clearing mappings, it was
also setting mmu_cr4_features, and this bit was lost with the removal of
cleanup_highmap_brk_end.

So this fix patch restores things back to how they were before
e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e (apart from the fact that
mappings between _brk_end and _end are cleared in cleanup_highmap now).

Obviously settings mmu_cr4_features shouldn't have been done in
cleanup_highmap_brk_end, since it doesn't have anything to do with
mappings.



P.S.
I asked for a backport of e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e to
the stable trees because I forgot to add "CC stable@kernel.org" to the
commit message and this commit is needed to fix a critical crash on boot
on xen.
