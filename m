Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2CXCCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 22:02:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab2CXCCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 22:02:14 -0400
Message-ID: <4F6D2AF8.3070707@zytor.com>
Date: Fri, 23 Mar 2012 19:01:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <4F6CD79A.8020805@zytor.com> <201203240242.07724.trenn@suse.de>
In-Reply-To: <201203240242.07724.trenn@suse.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 06:42 PM, Thomas Renninger wrote:
> 
> If there is any initrd change this could easily be adopted.
> Would be great to see this one pushed into 3.4 before a possibly long
> taking discussion about bigger initrd layout changes.
> 

This should have been in linux-next before the merge window started, and
certainly "pushing it upstream before a possibly long talking discussion
about bigger initrd layout changes" is *definitely* putting the cart
before the horse ... almost nothing matters as much as avoiding
introducing a new protocol that we need to keep stable.

Sorry, it doesn't work that way.

I'm not too happy about the idea of using "naked" ACPI headers as the
sole discriminator, because they lack a strong magic.  Furthermore, I
really don't want to see all the potential early-initrd users invent
different schemes for encapsulation, which has the potential of
cross-infection (early microcode update, for example, would have to be
invoked before ACPI, and needing that code to understand ACPI table
format is a nonstarter.)

I see two realistic options:

1. We use cpio encapsulation for everything, with a special namespace
   for items used directly by the kernel, e.g. "kernel/".

   + Simple, existing tools can pick apart
   - May lead people to believe that the early-initrd portion can be
     compressed like the "normal" initrd portion, leading to strange
     problems.

2. We create a new simple header (just a magic number, an identifier
   for the type of data, and a length) for each of the early-initrd
   objects:

	struct early_initrd_header {
		u64 magic;	/* 0xa5a46ce422d8f5a1 */
		u32 type;	/* 1 = file data, 2 = ACPI, 3 = microcode... */
		u32 length;	/* Length of data object */
	};

   XXX: Should we make this a defined endianness (presumably
   bigendian), or use host-endianness?  I would guess the former might
   be better...

Either of these allow one piece of code to quickly bypass bits that
doesn't belong to it.

Thoughts?

	-hpa
