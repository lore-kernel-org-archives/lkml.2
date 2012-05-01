Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2EAG2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:28:02 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:40134 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2EAG16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo57pH81KtUbYZ3j6y4kC+ka33Lzr4rfcywVWf8OTmH_5Q@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<1332135781-13695-5-git-send-email-yinghai@kernel.org>
	<CAErSpo6Wbjh_pzDOkGRoog2WeJQET9UT0fiaanV0r15pq7hT6Q@mail.gmail.com>
	<CAE9FiQV0XTd_1Ujz=tb6BSuwJvJ9nbT_GbE2PREtgMGv=yG0+g@mail.gmail.com>
	<CAErSpo57pH81KtUbYZ3j6y4kC+ka33Lzr4rfcywVWf8OTmH_5Q@mail.gmail.com>
Date: Mon, 30 Apr 2012 23:27:58 -0700
X-Google-Sender-Auth: 7YYcFSUIlOROl4pBH23hQti3ZQA
Message-ID: <CAE9FiQUOsMOQgZXCuPHpc6ZSEGnY3nv+uy1o0xvrW8-LKwNZrg@mail.gmail.com>
Subject: Re: [PATCH -v11 04/30] PCI: Add busn_res into struct pci_bus.
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 9:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Apr 30, 2012 at 6:32 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Apr 30, 2012 at 4:25 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> --- a/include/linux/pci.h
>>>> +++ b/include/linux/pci.h
>>>> @@ -419,6 +419,7 @@ struct pci_bus {
>>>>        struct list_head slots;         /* list of slots on this bus */
>>>>        struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
>>>>        struct list_head resources;     /* address space routed to this bus */
>>>> +       struct resource busn_res;       /* track registered bus num range */
>>>>
>>>>        struct pci_ops  *ops;           /* configuration access functions */
>>>>        void            *sysdata;       /* hook for sys-specific extension */
>>>
>>> struct pci_bus already includes "secondary" and "subordinate".    This
>>> new "busn_res" looks like it will contain the same information.  Why
>>> do we need both?
>>
>> In some case the could be different.
>> for root bus from _CRS, busn_res could bigger than subordinate,
>> because scan_childbus will update subordinate.
>
> For a bus below a P2P bridge, I think it's always the case that the
> bridge's Subordinate Bus Number in config space == bus->subordinate ==
> bus->busn_res.end (correct me if I'm wrong).  I don't like the
> redundancy in this case.

there are about 70 bus->subordinate reference and 40 bus->secondary reference.

could try to update them in following patch set.

>
> For a root bus where you set bus->busn_res from _CRS and
> bus->subordinate = pci_scan_child_bus(), bus->busn_res.end will
> generally be different from bus->subordinate, but there's no point in
> keeping track of bus->subordinate.
>
> The reason we care about secondary and subordinate is so we can
> allocate bus numbers when enumerating devices behind a bridge.  The
> only thing we need for that is the aperture of the upstream bridge and
> the apertures of any peer bridges on the same bus.  Let's say we have
> this:
>
>        pci 00:00.0 bridge to [bus a-b]
>        pci a:01.0 bridge to [bus c-d]  (already enumerated)
>        pci a:02.0 bridge to [bus e-f]  (already enumerated)
>        pci a:03.0 bridge to [bus x-y]  (enumerating now)
>
> We know [c-d] is contained in [a-b]; [e-f] is contained in [a-b]; a <
> c; and a < e.  To enumerate behind a:03.0, we need to assign x & y
> such that a < x; [x-y] is contained in [a-b]; and [x-y] does not
> overlap [c-d] or [e-f].  The value from pci_scan_child_bus() is
> probably useful for setting y, but we don't have to save it in the
> struct pci_bus for that.

busn alloc will try to solve x-y may need big range than [a,b], it
will extend top of b and parents of bus a.
instead of just b+1 blindly.

and will have more strict checking to avoid overlapping.

>
>> and also we have one resource to insert it into the resource tree, so
>> later could probe/allocate bus num range.
>
> Sorry, I didn't understand this.

Using busn_res to track and allocate busn range, by put them in the
resource tree could reuse resource allocating code.

Yinghai
