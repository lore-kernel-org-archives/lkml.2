Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2KIVW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:22:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39680 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2KIVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:22:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=GYpbeKtW37Cj9cXr8F7F83d9Fgs-moqu9p6cOaPE1VxwbSg@mail.gmail.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CAD=GYpbeKtW37Cj9cXr8F7F83d9Fgs-moqu9p6cOaPE1VxwbSg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 21:22:34 +0000
X-Google-Sender-Auth: O0ddabyz81QbuYWPtUjXmFOr_3c
Message-ID: <CACxGe6vL9gbAKyDWcZWWAQ4WO=nTgdAioXS-h2e1jtJK9pmZUg@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Joel A Fernandes <agnel.joel@gmail.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 5:32 AM, Joel A Fernandes <agnel.joel@gmail.com> wrote:
> Hi Pantelis,
>
> I hope I'm not too late to reply as I'm traveling.
>
> On Nov 6, 2012, at 5:30 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>
>>
>>>
>>> Joanne has purchased one of Jane's capes and packaged it into a rugged
>>> case for data logging. As far as Joanne is concerned, the BeagleBone and
>>> cape together are a single unit and she'd prefer a single monolithic FDT
>>> instead of using an FDT overlay.
>>> Option A: Using dtc, she uses the BeagleBone and cape .dts source files
>>>        to generate a single .dtb for the entire system which is
>>>        loaded by U-Boot. -or-
>>
>> Unlikely.
>>> Option B: Joanne uses a tool to merge the BeagleBone and cape .dtb files
>>>        (instead of .dts files), -or-
>> Possible but low probability.
>>
>>> Option C: U-Boot loads both the base and overlay FDT files, merges them,
>>>        and passes the resolved tree to the kernel.
>>>
>>
>> Could be made to work. Only really required if Joanne wants the
>> cape interface to work for u-boot too. For example if the cape has some
>> kind of network interface that u-boot will use to boot from.
>>
>
> I love Grant's hashing idea a lot keeping the phandle problem for
> compile time and not requiring fixups.
>
> IMO it is still a cleaner approach if u-boot does the simple tree merging for
> all cases, and not the kernel reasons mentioned below.

I'm more than sufficiently convinced that making changes at runtime
from userspace is pretty much required.

Also consider: it is order of magnitudes easier to modify the kernel
than it is to change the firmware for end users.

> (1)
> From a development standpoint, very little or nothing will
> have to be changed in kernel (except for scripts/dtc) considering we
> are moving forward with hashing.
>
> (2)
> Also this discussed a while back but at some point is going to brought
> up again-  loading of dt fragment directly from EEPROM and merging at
> run time. If we were to implement this in kernel, we would have to add
> cape specific EEPROM reading code, merge the tree before it is
> unflattened and parse.

Unless it is required for boot to userspace I'm not considering
merging before userspace starts. That's well after the tree is
unflattened into the live form. If it is require to boot then I agree
that is should be done in firmware. I see zero problem with having a
beaglebone specific cape driver that knows to read the eeprom and
request a specific configuration file. Heck, the kernel doesn't even
need to parse the eeprom data. It can be read from userspace and
userspace decides which overlay to provide. There's nothing stopping
userspace from reading the eeprom, looking up the correct dts for the
board, downloading the file from the Internet, compiling it with dtc
and installing it.... and yes that is getting a little extreme.

> I think doing tree merging in kernel is messy
> and we should do it in uboot considering we might have to read EEPROM for
> this use case. Ideally reading the fragment from the EEPROM for all capes
> and merging without worrying about version detection, Doing the merge and
> passing the merged blob to the kernel which (kernel) works the same way
> it does today.
>
>>> It may be sufficient to solve it by making the phandle values less
>>> volatile. Right now dtc generates phandles linearly. Generated phandles
>>> could be overridden with explicit phandle properties, but it isn't a
>>> fantastic solution. Perhaps generating the phandle from a hash of the
>>> node name would be sufficient.
>>>
>>
>> I doubt the hash method will work reliably. We only have 32 bits to work with,
>> nothing like the SHA hashes of git.
>>
>
> I was wondering I have worked with kernel's crypto code in the past to
> generate 32 bit md5sums of 1000s of dataitems, from what I've seen,
> collisions are rare and since we are talking about just a few nodes
> that are being referenced in the base dt. I think the probability is
> even less (ofcourse such an analysis strongly depends on dataset).
> this method also takes away a lot of complexity with having it to do
> runtime fixups and will help us get off the ground quickly.

It wouldn't be hard to put together a test and run it on all the .dts
files in the kernel; generating md5 sums for all the full_name paths
and seeing if we've got any collisions yet.

> We can also put in a collision handling mechanism if needed.
> I think it is worthy doing a sample hash of all nodes in all dts we
> have in a script and see for once if we have collisions and what it
> looks like.

Collision handling is a must, but again this is all internal to dtc. I
don't foresee any problems with it.

> Alternatively to hashing, reading David Gibson's paper I followed,
> phandle is supposed to 'uniquely' identity node. I wonder why the node
> name itself is not sufficient to uniquely identify.

Simply because the FDT draws upon the existing OFW bindings which use
a 32bit value to reference other nodes.

> The code that does
> the tree walking can then just strcmp the node name while it walks the
> tree instead of having to find a node with a phandle number. I guess
> the reason is phandles are small to store as data values. Another
> approach can be to arrange the string block in alphabetical order
> (unless it already is), and store phandle as index of the node name
> referenced relative to the starting of the strong block. This will not
> affect nodes in dtb being moved around since they will still have the
> same index value. the problem being adding or removing nodes Changes
> the index of all other nodes in the string block as well.. Hmm.

And that still doesn't help find all the phandle locations in the tree
for doing fixups. It would need to be a table of
nodes+properties+offsets that contain phandles for fixup to work, but
I shy away from that approach because I think it will be fragile.

g.
