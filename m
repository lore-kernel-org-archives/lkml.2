Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2AHWXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 17:23:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42770 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2AHWXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 17:23:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120108221342.GA7058@ime.usp.br>
References: <bug-41722-5003@https.bugzilla.kernel.org/> <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
 <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com> <20120108221342.GA7058@ime.usp.br>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 14:23:29 -0800
X-Google-Sender-Auth: ycWnDDFRaWngD9A2hjtbaVVxZ8I
Message-ID: <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 2:13 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>
> It doesn't boot with a vanilla kernel. It only boots when I pass the options
> above *and* compile the kernel with the following patch applied:
>
> ,----[ do_not_size_subtractive_decoding_transparent_pci_to_pci_bridges.patch ]
> | diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> | index 86b69f85..84543f5 100644
> | --- a/drivers/pci/setup-bus.c
> | +++ b/drivers/pci/setup-bus.c
> | @@ -849,6 +849,10 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
> |               break;
> |
> |       case PCI_CLASS_BRIDGE_PCI:
> | +             /* don't size subtractive decoding (transparent)
> | +              * PCI-to-PCI bridges */
> | +             if (bus->self->transparent)
> | +                     break;
> |               pci_bridge_check_ranges(bus);
> |               if (bus->self->is_hotplug_bridge) {
> |                       additional_io_size  = pci_hotplug_io_size;
> `----

Ahh. I'd forgotten about that particular PCI patch.

That is definitely the right thing to do, and commit 8fa5913d54f3
("PCI: remove transparent bridge sizing") did exactly that, but then
we reverted it in commit 12c22d6ef299 because it caused some odd
problems for some people.

I think we should try to re-do that "avoid sizing transparent bridges"
commit, because it really should make it much easier to do PCI
allocations under some very common situations (there's a *lot* of
common intel transparent PCI bridges).

Jesse, Yinghai, Ram - should we try to just re-do that commit in this
merge window, and see how that goes? We can always revert it again if
it causes problems..

                         Linus
