Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1F2VXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:23:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7856 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1F2VXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:23:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 Jun 2011 14:23:12 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Date: Wed, 29 Jun 2011 14:23:12 -0700
Subject: RE: [PATCH 1/2] drivers: create a pinmux subsystem v3
Thread-Topic: [PATCH 1/2] drivers: create a pinmux subsystem v3
Thread-Index: Acw012Oi9tpuljpcQMqTMMtbvrXQVAByLpIA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049E21B833@HQMAIL01.nvidia.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
	<BANLkTinNmPVEM4Eu4efxkuwrCU_FVWFaAg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C049D@HQMAIL01.nvidia.com>
	<BANLkTikFLbU70uJO0yrf8HipcVEwbUHgsw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C07E1@HQMAIL01.nvidia.com>
 <BANLkTinXKgdcsGPxGUbS7sv71mQi8eL_bQ@mail.gmail.com>
In-Reply-To: <BANLkTinXKgdcsGPxGUbS7sv71mQi8eL_bQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, June 27, 2011 8:35 AM:
> On Thu, Jun 16, 2011 at 9:10 PM, Stephen Warren <swarren@nvidia.com> wrote:

...
> > Now, we can have multiple entries with the same .map_name:
> >
> > static struct pinmux_map pmx_mapping[] = {
> >       {
> >               .dev_name = "tegra-sdhci.0",
> >               .map_name = "4 bit", # Note this is 4 now
> >               .function = "mmc0-1:0",
> >       },
> >       {
> >               .dev_name = "tegra-sdhci.0",
> >               .map_name = "4 bit",
> >               .function = "mmc0-3:2",
> >       },
> >
> > This means that if a client request map name "4 bit", then both functions
> > "mmc0-1:0" and "mmc0-3:2" are part of that mapping.
> 
> (...)
> 
> > In terms of implementation, this is still pretty easy; all we do when
> > reserving or activating a given mapping is to walk the entire list, find
> > *all* entries that match the client's search terms, and operate on all of
> > them, instead of stopping at the first one.
> 
> So:
> pmx = pinmux_get(dev, "4 bit");
> 
> in this case would reserve pins for two functions on pinmux_get() and
> activate two different functions after one another when
> we pinmux_enable(pmx) on this, "mmc0-1:0" and "mmc0-3:2" in some
> undefined order (inferenced across namespace).
> 
> I don't think it's as simple as you say, this gets hairy pretty quickly:
> 
> Since my previous pinmux_get() would create a struct pinmux * cookie
> for each map entry, assuming a 1:1 relationship between map entries
> and pinmuxes, we now break this, and you need to introduce
> more complex logic to search through the pinmux_list and dynamically
> add more functions to each entry with a matching map_name.

In the patch you posted, pinmux_get looked up a single specific
pinmux_map* and stored it in the struct pinmux. You're right that
continuing to do something similar means needing to store an array of
pinmux_map* in the struct pinmux, and dynamically adding more and more
entries as you search through the mapping table. A bit painful.

However, if instead of that, you store the original parameters to
pinmux_get() in struct pinmux, there's nothing to dynamically store
there. Instead, the implementation of pinmux_get and pinmux_enable is
very roughly:

pinmux_get:

Allocate struct pinmux, fill it in:
list_for_each_entry(mapping table)
    if (matches search terms)
        check_not_already_in_use
        acquire_pins()
        // Note: no break here

pinmux_enable:

// Note we redo the whole search here based on the original terms
// rather than having pinmux_get pre-calculate the search result
list_for_each_entry(mapping table)
    if (matches search terms)
        ops->enable()

In fact, I'd imagine that the list_for_each_entry call above could be
placed into a utility function that implements the searching logic, to
keep the code in one place, with a function parameter:

pinmux_search(terms, callback):

list_for_each_entry(mapping table)
    if (matches search terms)
        callback()

pinmux_get_body():
    check_not_already_in_use
    acquire_pins()

pinmux_get(terms):

Allocate struct pinmux, fill it in:
pinmux_search(terms, pinmux_get_body)

pinmux_enable_body():
    ops->enable()

pinmux_enable():

pinmux_search(terms, pinmux_enable_body)

Alternatively, each map entry contains a list node that's set up.
The list is set up by pinmux_get, and contains all mapping entries
associated with the original search terms. Struct pinmux points at
the head of the list. pinmux_enable then just needs to iterate over
that list, not the whole mapping array, and doesn't need to implement
the search algorithm. That might actually be simpler. Since each
mapping entry would only be get'd once, there'd be no conflicts with
multiple things trying to use the one list node at once.

> Then you need to take care of the case where acquiring pins for
> one of the functions fail: then you need to go back and free the
> already acquired pins in the error path.

That's not that hard; just iterate over the whole list again, applying
a function that undoes what you did before. It's just like the error
handling code that already exists in acquire_pins for example. The only
hard part might be stopping when you get to the point you already got
to in the first loop, but actually that's just a matter of passing in
a "stop at this index" parameter to the pinmux_search() I mentioned
above.

> I tried quickly to see if I could code this up, and it got very complex
> real quick, sadly. Maybe if I can just get to iterate a v4 first, I
> could venture down this track.
> 
> But if you can code up the patch for this, I'm pretty much game for
> it!

Sure, I can add the extra looping to the code if you want. It'd be easiest
if you set up the data structures in the initial patch such that all the
fields exist in the mapping table (i.e. how I showed in the concept header
files I posted). That way, there'd be no type or semantic changes in my
patch, just support for acting on N instead of just 1 mapping entry at a
time.

...
> > * The same point, but think about a SW bit-banged bus consisting of 8
> > GPIOs for the bus and 100 pins on the device. Each permutation of 8 out
> > of 100 is scary... I'd love a board to be able to represent a single
> > mapping for a particular board's set of GPIOs in this case, but not for
> > the pinmux driver to expose all possibilities!
> 
> Is this a real world problem or a theoretical one? Seems like the
> latter, and as stated in the documentation this subsystem is not about
> solving discrete maths permutation spaces, but practical enumerations.

That's theoretical in terms of the boards/code I'm currently dealing with.
However, solving this seems pretty simple, and I can't imagine nobody will
ever want to do that.

-- 
nvpublic

