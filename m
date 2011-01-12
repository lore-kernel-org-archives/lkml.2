Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1ALQcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:32:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58632 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1ALQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:32:29 -0500
Date: Wed, 12 Jan 2011 16:32:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@canonical.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to
	setup.c
Message-ID: <20110112163221.GD11039@n2100.arm.linux.org.uk>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6> <20110111104051.GA11039@n2100.arm.linux.org.uk> <20110111153630.GB2707@angua.secretlab.ca> <20110111154833.GF11039@n2100.arm.linux.org.uk> <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com> <20110112155215.GB11039@n2100.arm.linux.org.uk> <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 09:24:34AM -0700, Grant Likely wrote:
> Actually it looks like the real problem is that the mmu has been
> turned on, but the virtual mappings for devices have not yet been
> established, and so the debug macros aren't using a valid address.

They should be, as they're valid for use from assembly prior to MMU
turn-on, assembly after MMU turn-on and C code.

If CONFIG_DEBUG_LL is enabled, create_page_tables() should be setting
up the necessary initial mappings for printascii() to work.

Maybe the efforts to unify that stuff ended up breaking the printascii
debugging mechanism, and we now require a new debugging mechanism to
debug the printascii debugging mechanism... :-P

I've used it on Versatile Express during the last week and it did work
right from before setup_arch() was called.

> It looks like I'd need to get past paging_init() in order to get
> ll_debug working between turning on the mmu and paging_init(), but
> paging_init() needs the mdesc pointer, and the whole point of the
> error message is that the mdesc pointer is unknown!  I don't see any
> code that sets up a debug mapping of the uart before paging_init time.

See the #ifdef CONFIG_DEBUG_LL section in create_page_tables in head.S
