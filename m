Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2B0Xam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:30:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:33684 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab2B0Xal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:30:41 -0500
Message-ID: <1330385424.11728.7.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the final tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 28 Feb 2012 10:30:24 +1100
In-Reply-To: <1330334360.11728.3.camel@pasglop>
References: <20120227173747.853e7fbe3ce3afab8939720b@canb.auug.org.au>
	 <1330334360.11728.3.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 20:19 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2012-02-27 at 17:37 +1100, Stephen Rothwell wrote:
> >         pci_add_resource_offset(resources, res,
> > -                       (resource_size_t) hose->io_base_virt - _IO_BASE);
> > +                       (resource_size_t)(unsigned long)hose->io_base_virt - _IO_BASE);
> 
> We have to be careful here as we do want sign extension to happen (yeah
> it's odd, but it's the way we do IOs on ppc32 :-) Maybe I should change
> it one day).
> 
> So we probably want to do:
> 
> 	 (resource_size_t)(long long)(hose->io_base_virt - _IO_BASE)

Oops ... that was meant to read (long) not (long long)... Any ways, I
more or less convinced myself that even without the sign extension it
would still work, since the IO port number is eventually cast to an
unsigned int by the accessors, so as long as the low 32-bits are correct
(and they'll be with or without the sign extension), we should be fine.
It's just that something trying to print the resource might end up
displaying garbage in the top bits.

Cheers,
Ben.


> Basically, IO resources are relative to _IO_BASE which on ppc32 is
> basically the virtual address where we map the first PHB IO space.
> 
> Subsequent PHB mappings can end up below _IO_BASE, leading to negative
> resource values for IO BARs on those busses. It all works fine because
> even an unsigned addition will do the right thing as long as the value
> is fully sign extended.
> 
> Cheers,
> Ben.


