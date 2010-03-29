Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0C2SHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:07:43 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:49844 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753725Ab0C2SHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:07:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=c9LdyLjUcX1yYip75C428yRq+fHPD95z4HLB74UCPEREkt7PEUm5E8Fx/KqJ8qrDIlEfA4PkJ6ZvypLkv/gcvz+IJGJkPBa84IzTljmg5vVxUSpoy1igyKOjVqm7gwpQ;
Date: Mon, 29 Mar 2010 11:06:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Giel van Schijndel <me@mortis.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
Message-ID: <20100329110633.702e3874@jbarnes-piketon>
In-Reply-To: <4BB0E73F.2080104@zytor.com>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
	<1269523063-30346-1-git-send-email-me@mortis.eu>
	<20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
	<20100325180347.GA2761@salidar.me.mortis.eu>
	<20100325181633.0313b8a5@lxorguk.ukuu.org.uk>
	<20100329081834.GB27956@salidar.me.mortis.eu>
	<20100329090713.1317942b@jbarnes-piketon>
	<20100329173800.GA3583@salidar.me.mortis.eu>
	<4BB0E73F.2080104@zytor.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 10:45:35 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/29/2010 10:38 AM, Giel van Schijndel wrote:
> > 
> > Patch after this line:
> > ========================================================================
> > resource: shared I/O region support
> > 
> > SuperIO devices share regions and use lock/unlock operations to chip
> > select.  We therefore need to be able to request a resource and wait for
> > it to be freed by whichever other SuperIO device currently hogs it.
> > Right now you have to poll which is horrible.
> > 
> > Add a MUXED field to IO port resources. If the MUXED field is set on the
> > resource and on the request (via request_muxed_region) then we block
> > until the previous owner of the muxed resource releases their region.
> > 
> > This allows us to implement proper resource sharing and locking for
> > superio chips using code of the form
> > 
> > enable_my_superio_dev() {
> > 	request_muxed_region(0x44, 0x02, "superio:watchdog");
> > 	outb() ..sequence to enable chip
> > }
> > 
> > disable_my_superio_dev() {
> > 	outb() .. sequence of disable chip
> > 	release_region(0x44, 0x02);
> > }
> > 
> > Signed-off-by: Giel van Schijndel <me@mortis.eu>
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> I have to question this approach a bit.
> 
> I would much rather see this as a two-step process, where multiple
> devices request the same region with a "sharable" flag, and then have a
> mutex associated with the struct resource (perhaps we need an outer
> container called "struct muxed_resource" or some such.)
> 
> What I *really* object to with this patch is that it inherently assumes
> that there is only one multiplexed resource in the entire system... but
> of course nowhere enforces that.

Well that does keep it simple, and with just one user that's probably
best.

But why not use the common bus driver method?  Muxing at the resource
level only seems to solve part of the problem...  It doesn't guarantee
for example that driver A does something to a shared region that breaks
driver B; it just makes sure they don't access the same region at the
same time.

-- 
Jesse Barnes, Intel Open Source Technology Center
