Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2B0JTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:19:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:46249 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab2B0JTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:19:40 -0500
Message-ID: <1330334360.11728.3.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the final tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 27 Feb 2012 20:19:20 +1100
In-Reply-To: <20120227173747.853e7fbe3ce3afab8939720b@canb.auug.org.au>
References: <20120227173747.853e7fbe3ce3afab8939720b@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 17:37 +1100, Stephen Rothwell wrote:
>         pci_add_resource_offset(resources, res,
> -                       (resource_size_t) hose->io_base_virt - _IO_BASE);
> +                       (resource_size_t)(unsigned long)hose->io_base_virt - _IO_BASE);

We have to be careful here as we do want sign extension to happen (yeah
it's odd, but it's the way we do IOs on ppc32 :-) Maybe I should change
it one day).

So we probably want to do:

	 (resource_size_t)(long long)(hose->io_base_virt - _IO_BASE)

Basically, IO resources are relative to _IO_BASE which on ppc32 is
basically the virtual address where we map the first PHB IO space.

Subsequent PHB mappings can end up below _IO_BASE, leading to negative
resource values for IO BARs on those busses. It all works fine because
even an unsigned addition will do the right thing as long as the value
is fully sign extended.

Cheers,
Ben.

