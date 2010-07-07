Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0GGSoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:44:09 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:45521 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753013Ab0GGSoG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:44:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fuawOSDN9sMQFrHuKd+ui7g7j4x2O3QcpQbBESdDNVsZjfmoJ3kxs5xFBLejhl9l6uHeZLzUef6zd9DVmdB5WI6jHdYYLbCqslP3J2R5RQ/dBCkWWwll8kdTXWF/2ze/;
Date: Wed, 7 Jul 2010 11:35:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, clemens@ladisch.de,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port 
 resources
Message-ID: <20100707113523.09c2d0e4@virtuousgeek.org>
In-Reply-To: <AANLkTiksRIyTSBWPThUqhG-5-JXpZLlJ87fyxrXuXpbO@mail.gmail.com>
References: <20100630211516.GA25991@us.ibm.com>
	<AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
	<20100630235949.GA5120@us.ibm.com>
	<20100702143515.2896d728@virtuousgeek.org>
	<4C33B883.6010206@kernel.org>
	<AANLkTiknAtUipCr64qwJXakD9VgqhHNp35KPq5x9_x8V@mail.gmail.com>
	<4C33CF1C.7020803@kernel.org>
	<AANLkTiksRIyTSBWPThUqhG-5-JXpZLlJ87fyxrXuXpbO@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a different issue, I think the PAT code tracks memtypes
like this.

Suresh, any changes in this area that might explain this?

Jesse

On Wed, 7 Jul 2010 14:28:47 +1000
Andrew Hendry <andrew.hendry@gmail.com> wrote:

> Is this the same or related issue?
> 
> http://lkml.org/lkml/2010/7/6/108
> New messages since -rc4, X and graphics really slow after.
> 
> [    1.387013] swapper:1 freeing invalid memtype bf788000-bf789000
> [    1.387409] swapper:1 freeing invalid memtype bf789000-bf78a000
> [    5.999675] modprobe:548 freeing invalid memtype d0000000-d0040000
> [    6.068347] modprobe:548 freeing invalid memtype d0140000-d0150000
> [    6.068647] modprobe:548 freeing invalid memtype d0150000-d0160000
> [    6.069661] modprobe:548 freeing invalid memtype d0170000-d01f0000
> [    6.085969] modprobe:548 freeing invalid memtype d01f0000-d0200000
> [    6.087673] modprobe:548 freeing invalid memtype d0210000-d0220000
> [    6.087900] modprobe:548 freeing invalid memtype d0220000-d0230000
> [    6.088092] modprobe:548 freeing invalid memtype d0230000-d0240000
> [    6.088317] modprobe:548 freeing invalid memtype d0240000-d0250000
> 
> 
> On Wed, Jul 7, 2010 at 10:49 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On 07/06/2010 04:58 PM, Linus Torvalds wrote:
> >> On Tue, Jul 6, 2010 at 4:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>>
> >>> So you want to use pci=override_bios to reallocate all bios assigned resource include
> >>> peer root buses resources and pci bridge resource and pci devices BAR?
> >>
> >> In a perfect world, we'd never need this at all, but sicne that's not
> >> an option, the second-best alternative might be something like the
> >> following:
> >>
> >>   pci=override=off # default
> >>   pci=override=conflict # override only on conflicts
> >>   pci=override=<device> # clear BIOS allocations for <device> (and any
> >> children, if it's a bus)
> >
> > current:
> > if there is conflict, like pci bridge resources or pci devices resources is not in the scope of peer root bus resource range.
> > or pci devices is not in pci bridge resources range.
> > kernel would reject the resource and try to get new range in parent resource for the children.
> >
> > so current default is overriding the conflicts already.
> >
> > Maybe your conflicts have other meaning? like pci bridge resource size is not big enough?
> >
> > or we can have use
> >
> > pci=override=small_bridge
> >
> > or
> >
> > pci=override=bridges
> >
> > instead?
> >
> > Thanks
> >
> > Yinghai
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
