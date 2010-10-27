Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0J0SCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:02:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9135 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0J0SCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:02:15 -0400
X-IronPort-AV: E=Sophos;i="4.58,247,1286164800"; 
   d="scan'208";a="119956956"
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <4CC866B0.8000802@goop.org>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
	 <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org>
	 <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org>
	 <4CC8649F.5060408@linux.intel.com>  <4CC866B0.8000802@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 27 Oct 2010 19:02:08 +0100
Message-ID: <1288202528.10179.106.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 18:51 +0100, Jeremy Fitzhardinge wrote:
> On 10/27/2010 10:42 AM, H. Peter Anvin wrote:

> > Ian's message just mentioned "a failure" and never described in any way what
> > kind of "failure" it was.
> 
> It would be a pagefault from Xen preventing a direct write to the pgd
> level of an active pagetable.  At the point in setup_arch() where it
> does the first clone_pgd_range() we're already running on swapper_pg_dir
> and the copy from initial_page_table is outright wrong.

I'd missed that aspect, yes the contents of initial_page_table are
wrong. I'm not sure now how my patch to clone_pgd_range even made a
difference...

> As Ian suggests, we could switch Xen to use initial_page_table at boot
> then move to swapper_pg_dir in the same way native does.

Accidentally did that in private mail, for everyone else the gory
details are:

> xen_setup_kernel_pagetable operates on initial_page_table instead of
> swapper_pg_dir. We do not pin initial_page_table apart from the
> implicit
> one from writing it to cr3 (it is necessarily r/o though).
> 
> So we enter setup_arch running on initial_page_table and with
> swapper_pg_dir mapped r/w, which is how it looks on native too. So at
> this point the:
>         clone_pgd_range(swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
>                         initial_page_table + KERNEL_PGD_BOUNDARY,
>                         KERNEL_PGD_PTRS);
> works just fine and we reach:
>       load_cr3(swapper_pg_dir);
> 
> Then in __xen_write_cr3 we notice the first attempt to switch to
> swapper_pg_dir and only at that point do we make it r/o and pin it.
> When
> we then actually do the switch to swapper_pg_dir that releases the
> implicit pin on initial_page_table so we can make it r/o again.
> 
> The later on we reach the:
>        clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
>                         swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
>                         KERNEL_PGD_PTRS);
> which will succeed because initial_page_table is r/w again.
> 
> We don't care about the pin on initial_page_table because we should
> never need it again.

Ian.

