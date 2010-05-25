Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0EYFnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:43:52 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:39368 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0EYFnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:43:50 -0400
Date: Tue, 25 May 2010 01:43:26 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Philip Langdale <philipl@overt.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Jeff Garrett <jeff@jgarrett.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, luming.yu@intel.com, venki@google.com
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
In-reply-to: <d7f2dd35a4361e5156079278543769a0@localhost>
Message-id: <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
References: <20100126084740.GA5265@jgarrett.org>
 <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org>
 <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
 <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> I am hopeful that the "right thing to do" is to not look at bm-status
> >> and that perhaps there is a bug where we are looking at it
> >> "by mistake".
> > 
> > https://patchwork.kernel.org/patch/58962/ - it seems to be a win.
> 
> Indeed. This patch does solve the C6 problem. I'm not in a position to
> speak about whether there's any undesirable I/O latency, but it
> passes the basic sanity check.
> 
> I have filed https://bugzilla.kernel.org/show_bug.cgi?id=15886 with
> my acpi dump - assuming that's still useful.

Luming's patch above basically deletes acpi_idle_bm_check() --
the BM_STS check -- from the C3 path on all Intel SMP boxes.
This is effectively the same as my test patch
https://patchwork.kernel.org/patch/77370/
that made acpi_idle_bm_check() do nothing.

I'm told by the hardware guys that BM_STS is _not_ always
a NOP, and so we're not supposed to simply ignore it on C3 --
though it should be extremely rare that we see it set.
If it is ever set, it should go on and off depending on 
activity on some latency sensitive device, like out on the LPC.
It may be possible for the BIOS writer to configure the chipset
so that BM_STS is enabled always, presumably to accomodate
some latency sensitve device -- or maybe by mistake.

(is it observed to be set always on your systems, or does
 it ever change its value?)

The logic in Luming's patch doesn't make sense to me.
bm_check and bm_control are related to C3 need to flush
the cache or ability to invoke ARB_DIS.  They are not
directly related to BM_STS -- which is a bit that tells
us if there has recently been bus master activity of
a type that would break us out of C3.

-Len Brown, Intel Open Source Technology Center

