Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005Ab2KIFcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:32:13 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47680 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2KIFcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:32:10 -0500
MIME-Version: 1.0
In-Reply-To: <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
	<02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
Date: Fri, 9 Nov 2012 00:32:09 -0500
Message-ID: <CAD=GYpbeKtW37Cj9cXr8F7F83d9Fgs-moqu9p6cOaPE1VxwbSg@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
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

Hi Pantelis,

I hope I'm not too late to reply as I'm traveling.

On Nov 6, 2012, at 5:30 AM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:

>
>>
>> Joanne has purchased one of Jane's capes and packaged it into a rugged
>> case for data logging. As far as Joanne is concerned, the BeagleBone and
>> cape together are a single unit and she'd prefer a single monolithic FDT
>> instead of using an FDT overlay.
>> Option A: Using dtc, she uses the BeagleBone and cape .dts source files
>>        to generate a single .dtb for the entire system which is
>>        loaded by U-Boot. -or-
>
> Unlikely.
>> Option B: Joanne uses a tool to merge the BeagleBone and cape .dtb files
>>        (instead of .dts files), -or-
> Possible but low probability.
>
>> Option C: U-Boot loads both the base and overlay FDT files, merges them,
>>        and passes the resolved tree to the kernel.
>>
>
> Could be made to work. Only really required if Joanne wants the
> cape interface to work for u-boot too. For example if the cape has some
> kind of network interface that u-boot will use to boot from.
>

I love Grant's hashing idea a lot keeping the phandle problem for
compile time and not requiring fixups.

IMO it is still a cleaner approach if u-boot does the simple tree merging for
all cases, and not the kernel reasons mentioned below.

(1)
>From a development standpoint, very little or nothing will
have to be changed in kernel (except for scripts/dtc) considering we
are moving forward with hashing.

(2)
Also this discussed a while back but at some point is going to brought
up again-  loading of dt fragment directly from EEPROM and merging at
run time. If we were to implement this in kernel, we would have to add
cape specific EEPROM reading code, merge the tree before it is
unflattened and parse. I think doing tree merging in kernel is messy
and we should do it in uboot considering we might have to read EEPROM for
this use case. Ideally reading the fragment from the EEPROM for all capes
and merging without worrying about version detection, Doing the merge and
passing the merged blob to the kernel which (kernel) works the same way
it does today.

>> It may be sufficient to solve it by making the phandle values less
>> volatile. Right now dtc generates phandles linearly. Generated phandles
>> could be overridden with explicit phandle properties, but it isn't a
>> fantastic solution. Perhaps generating the phandle from a hash of the
>> node name would be sufficient.
>>
>
> I doubt the hash method will work reliably. We only have 32 bits to work with,
> nothing like the SHA hashes of git.
>

I was wondering I have worked with kernel's crypto code in the past to
generate 32 bit md5sums of 1000s of dataitems, from what I've seen,
collisions are rare and since we are talking about just a few nodes
that are being referenced in the base dt. I think the probability is
even less (ofcourse such an analysis strongly depends on dataset).
this method also takes away a lot of complexity with having it to do
runtime fixups and will help us get off the ground quickly.

We can also put in a collision handling mechanism if needed.
I think it is worthy doing a sample hash of all nodes in all dts we
have in a script and see for once if we have collisions and what it
looks like.

Alternatively to hashing, reading David Gibson's paper I followed,
phandle is supposed to 'uniquely' identity node. I wonder why the node
name itself is not sufficient to uniquely identify. The code that does
the tree walking can then just strcmp the node name while it walks the
tree instead of having to find a node with a phandle number. I guess
the reason is phandles are small to store as data values. Another
approach can be to arrange the string block in alphabetical order
(unless it already is), and store phandle as index of the node name
referenced relative to the starting of the strong block. This will not
affect nodes in dtb being moved around since they will still have the
same index value. the problem being adding or removing nodes Changes
the index of all other nodes in the string block as well.. Hmm.

Regards,
Joel
