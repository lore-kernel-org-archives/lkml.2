Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2CXDCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 23:02:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab2CXDCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 23:02:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Sat, 24 Mar 2012 04:02:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com>
In-Reply-To: <4F6D2AF8.3070707@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203240402.38749.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2012 03:01:28 H. Peter Anvin wrote:
> On 03/23/2012 06:42 PM, Thomas Renninger wrote:
> > 
> > If there is any initrd change this could easily be adopted.
> > Would be great to see this one pushed into 3.4 before a possibly long
> > taking discussion about bigger initrd layout changes.
> > 
> 
> This should have been in linux-next before the merge window started, and
> certainly "pushing it upstream before a possibly long talking discussion
> about bigger initrd layout changes" is *definitely* putting the cart
> before the horse ... almost nothing matters as much as avoiding
> introducing a new protocol that we need to keep stable.
> 
> Sorry, it doesn't work that way.
I guess this would not be the first time a good feature has been added,
knowing that a more general API will be build around it later.
10 lines are really easy to adopt.

> I'm not too happy about the idea of using "naked" ACPI headers as the
> sole discriminator, because they lack a strong magic.  Furthermore, I
> really don't want to see all the potential early-initrd users invent
> different schemes for encapsulation, which has the potential of
> cross-infection (early microcode update, for example, would have to be
> invoked before ACPI, and needing that code to understand ACPI table
> format is a nonstarter.)
> 
> I see two realistic options:
> 
> 1. We use cpio encapsulation for everything, with a special namespace
>    for items used directly by the kernel, e.g. "kernel/".
> 
>    + Simple, existing tools can pick apart
>    - May lead people to believe that the early-initrd portion can be
>      compressed like the "normal" initrd portion, leading to strange
>      problems.
Can this be implemented without using dynamic memory allocations?
If not, it's not suitable for early APCI overriding.

> 
> 2. We create a new simple header (just a magic number, an identifier
>    for the type of data, and a length) for each of the early-initrd
>    objects:
> 
> 	struct early_initrd_header {
> 		u64 magic;	/* 0xa5a46ce422d8f5a1 */
> 		u32 type;	/* 1 = file data, 2 = ACPI, 3 = microcode... */
> 		u32 length;	/* Length of data object */
> 	};
> 
>    XXX: Should we make this a defined endianness (presumably
>    bigendian), or use host-endianness?  I would guess the former might
>    be better...
> 
> Either of these allow one piece of code to quickly bypass bits that
> doesn't belong to it.
> 
> Thoughts?
Whatabout Multiboot(2):
http://en.wikipedia.org/wiki/Multiboot_Specification
http://www.gnu.org/software/grub/manual/multiboot/multiboot.html

They do it similar to 2, but without specifying the data of the
files like you do with type.

It's a bigger thing, but I could imagine there are some guys who would
be willing to give it a try. I remember I googled a multiboot patch
which got submitted to lkml long time ago.

It has it pros and cons, but should show up in such a discussion.

  Thomas
