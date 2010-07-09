Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0GIPZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:25:35 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:47714 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757340Ab0GIPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:25:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uG5rZq3QTmtWI211QJwG9NPxLLh/d4F7+0vYX/6vhvTvkm7/AXF6Y9la0g8DEurnqIoYB3iml7IMjNf2AvFWzEVTrnZZjs90/rLtCt9WxklkgCQU0iU2rCUL7MYEXiso;
Date: Fri, 9 Jul 2010 08:25:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, clemens@ladisch.de
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port 
 resources
Message-ID: <20100709082506.514f64ab@virtuousgeek.org>
In-Reply-To: <4C33CF1C.7020803@kernel.org>
References: <20100630211516.GA25991@us.ibm.com>
	<AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
	<20100630235949.GA5120@us.ibm.com>
	<20100702143515.2896d728@virtuousgeek.org>
	<4C33B883.6010206@kernel.org>
	<AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com>
	<4C33CF1C.7020803@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jul 2010 17:49:32 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On 07/06/2010 04:58 PM, Linus Torvalds wrote:
> > On Tue, Jul 6, 2010 at 4:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >> So you want to use pci=override_bios to reallocate all bios assigned resource include
> >> peer root buses resources and pci bridge resource and pci devices BAR?
> > 
> > In a perfect world, we'd never need this at all, but sicne that's not
> > an option, the second-best alternative might be something like the
> > following:
> > 
> >   pci=override=off # default
> >   pci=override=conflict # override only on conflicts
> >   pci=override=<device> # clear BIOS allocations for <device> (and any
> > children, if it's a bus)
> 
> current:
> if there is conflict, like pci bridge resources or pci devices resources is not in the scope of peer root bus resource range.
> or pci devices is not in pci bridge resources range.
> kernel would reject the resource and try to get new range in parent resource for the children.
> 
> so current default is overriding the conflicts already.
> 
> Maybe your conflicts have other meaning? like pci bridge resource size is not big enough?
> 
> or we can have use
> 
> pci=override=small_bridge
> 
> or 
> 
> pci=override=bridges
> 
> instead?

Changing the default (and fairly old) behavior at this point will
probably cause a lot of trouble; we have machines where reallocating
conflicting or apparently mis-programmed resources is needed.

But we can still add the pci=override= option.  Your patch will need
some changes though; a user needing a specific bus/bridge reallocated
can just pass the bridge id.  And rather than walking its way up,
freeing and trying to re-allocate, it could just free everything below
the given device and let the normal paths allocate it.

-- 
Jesse Barnes, Intel Open Source Technology Center
