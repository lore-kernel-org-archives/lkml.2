Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2KMD7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:59:16 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34220 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2KMD7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:59:14 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6vL9gbAKyDWcZWWAQ4WO=nTgdAioXS-h2e1jtJK9pmZUg@mail.gmail.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
	<02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
	<CAD=GYpbeKtW37Cj9cXr8F7F83d9Fgs-moqu9p6cOaPE1VxwbSg@mail.gmail.com>
	<CACxGe6vL9gbAKyDWcZWWAQ4WO=nTgdAioXS-h2e1jtJK9pmZUg@mail.gmail.com>
Date: Mon, 12 Nov 2012 21:59:13 -0600
Message-ID: <CAD=GYpYHwXvcCzANOA90S0_PyAufnuF5MR-Wdk-9uygYbWDBYA@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, Nov 9, 2012 at 3:22 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> (2)
>> Also this discussed a while back but at some point is going to brought
>> up again-  loading of dt fragment directly from EEPROM and merging at
>> run time. If we were to implement this in kernel, we would have to add
>> cape specific EEPROM reading code, merge the tree before it is
>> unflattened and parse.
>
> Unless it is required for boot to userspace I'm not considering
> merging before userspace starts. That's well after the tree is
> unflattened into the live form. If it is require to boot then I agree
> that is should be done in firmware. I see zero problem with having a
> beaglebone specific cape driver that knows to read the eeprom and
> request a specific configuration file. Heck, the kernel doesn't even
> need to parse the eeprom data. It can be read from userspace and
> userspace decides which overlay to provide. There's nothing stopping
> userspace from reading the eeprom, looking up the correct dts for the
> board, downloading the file from the Internet, compiling it with dtc
> and installing it.... and yes that is getting a little extreme.

Actually, I was speaking of the case where today we read EEPROM anyway
for capes before userspace, so it would convenient do the overlay this
way. Further, userspace doesn't have to do any parsing as
kernel/u-boot could blindly load the dtb overlay directly from EEPROM
regardless of which cape. So we don't have do any revision detection
and dtb search, the dtb itself being in the EEPROM.
That way no matter what the userspace is, the cape hardware is already
configured and ready to use by userspace. This might be a corner-case
just for beaglebone though, and if requesting overlay from userspace
is a more general solution for all usecases, then probably we should
go with that approach. OTOH, I guess there's no harm in doing some
overlays from kernel for some cases, and userspace for others.

>> The code that does
>> the tree walking can then just strcmp the node name while it walks the
>> tree instead of having to find a node with a phandle number. I guess
>> the reason is phandles are small to store as data values. Another
>> approach can be to arrange the string block in alphabetical order
>> (unless it already is), and store phandle as index of the node name
>> referenced relative to the starting of the strong block. This will not
>> affect nodes in dtb being moved around since they will still have the
>> same index value. the problem being adding or removing nodes Changes
>> the index of all other nodes in the string block as well.. Hmm.
>
> And that still doesn't help find all the phandle locations in the tree
> for doing fixups. It would need to be a table of
> nodes+properties+offsets that contain phandles for fixup to work, but
> I shy away from that approach because I think it will be fragile.

I guess this approach (which wouldn't work for other reasons) was
intended to serve the same purpose as Hashing, having a phandle that
doesn't easily change hence not requiring overlay fixups.

Actually I'm a bit confused if how maintaining a list of
name/node-paths for fix up will even work, because node names are not
unique as we discussed. Also node paths can change, so what will the
overlay dtb store in its fixup table (say there is one)? A table of
node,properties etc as you mentioned might not be unique as there can
be 2 nodes with same name and properties. Also if we use node path,
instead of node name, in this table, then moving nodes around wont be
possible as the fixup table will be pointing to node path references
that have now changed- how will the kernel now what's the node's new
actual path, say, if there are 2 nodes with the same name? Only thing
possible is, to do a _mandatory_ recompile of overlay dtb if a node's
path changes.

Would be you be in agreement that- When a node's path changes in base
dtb, Overlays have to be recompiled and a new fixup table has to be
created, or a new hash has to be generated out of the new node path
regardless. So moving nodes around in base dtb can't be dynamically
accommodated without recompiling overlay.

Considering the above is ok, the only 2 approaches I can see for
phandle resolutions are:
(1) hashing of the full node path and avoiding runtime fixups.
(2) Using today's linear phandle increment approach, maintaining a
table in the overlay with the key as 'node path' and value as 'phandle
fixup offset', and then doing runtime fixups.

I believe (2) is considered fragile and it does the same thing as (1)
except that (2) can even handle collisions but at the cost of storing
the full node path in the overlay's fixup table. So (1) looks like our
only possible and meaningful approach. Do you agree with this
analysis? Or, maybe I am missing something.

Regards,
Joel
