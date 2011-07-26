Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1GZHSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:18:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:29858 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1GZHSd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:14:1>);
	Tue, 26 Jul 2011 03:18:33 -0400
Message-Id: <4E2E8663020000780004FAA4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 26 Jul 2011 08:18:27 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andrew Lutomirski" <luto@mit.edu>
Cc: <jj@chaosbits.net>, <mingo@elte.hu>,
        "Ian Campbell" <Ian.Campbell@eu.citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <pageexec@freemail.hu>, <brgerst@gmail.com>,
        <richard.weinberger@gmail.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>, <arjan@infradead.org>,
        <mikpe@it.uu.se>, <Louis.Rilling@kerlabs.com>,
        <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <Valdis.Kletnieks@vt.edu>
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7
	 (x86-64: Give vvars their own page) breaks Xen PV guests
	 (64-bit).
References: <20110725155442.GA21759@dumpdata.com>
 <20110725161009.GA9193@dumpdata.com>
 <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com>
In-Reply-To: <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.07.11 at 20:10, Andrew Lutomirski <luto@mit.edu> wrote:
> On Mon, Jul 25, 2011 at 12:10 PM, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> However, this is what I get later on, any ideas?
> 
>> [    0.585880] init[1] illegal int 0xcc from 32-bit mode ip:ffffffffff600400 
> cs:e033 sp:7fff230ca088 ax:ffffffffff600400 si:7faee3e822bf di:7fff230ca158
> 
> That will, indeed, crash your system.
> 
> 0xe033 is FLAT_RING3_CS64
> 
> Jeremy / other Xen people:  I'm trying to implement a lightweight
> check to distinguish a trap from a sane (i.e. allowable for syscalls)
> 64-bit user context from anything else.  There seems to be precedent
> for using ->cs == __USER_CS to detect 64-bitness; for example, step.c
> contains:
> 
> #ifdef CONFIG_X86_64
>                 case 0x40 ... 0x4f:
>                         if (regs->cs != __USER_CS)
>                                 /* 32-bit mode: register increment */
>                                 return 0;
>                         /* 64-bit mode: REX prefix */
>                         continue;
> #endif
> 
> The prefetch opcode checker in mm/fault.c does something similar.

That (namely the latter) has been in place basically forever (also in
the original http://xenbits.xen.org/hg/linux-2.6.18-xen.hg/ tree),
but indeed would seem to need addition of a check against Xen's
ring-3 64-bit CS. It's just that in the pre-existing cases the
consequences are at worst moderate...

Jan

