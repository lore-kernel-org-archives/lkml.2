Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2ASWmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:42:17 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63626 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756643Ab2ASWmO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:42:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWH0KqsC3Yin0TS+RVCvtjTi6j5wa6aUf19qU3xuQsmOA@mail.gmail.com>
References: <20120118003335.467.71863.stgit@bhelgaas.mtv.corp.google.com>
 <20120118003512.467.60770.stgit@bhelgaas.mtv.corp.google.com>
 <CAE9FiQXvLAJVY-t8EJHkJgugtRsPdT9SS=60vA+by6qMCd5-Wg@mail.gmail.com>
 <CAErSpo7xgJmT=gs8axiY-OseyurqwUEqYixm692kmZAoA-2sNw@mail.gmail.com>
 <CAE9FiQUMEv+=mXzGc_muM_zTQ14S8tVex+bYgyyM1F++37Cu8w@mail.gmail.com>
 <CAErSpo7Awb97fn=bZECqaf4RF4Tmkh1_sUf6_Vk+jgv5jCYNTw@mail.gmail.com>
 <CAE9FiQXj8W4G_SRKCFU-gHJRZ+qENPAs8WAcZA_PVgoageHcoQ@mail.gmail.com>
 <CAErSpo5cAQVJq858QGi0N_TM91PsKj0jzvUUT8_yA9ezf_wXAQ@mail.gmail.com> <CAE9FiQWH0KqsC3Yin0TS+RVCvtjTi6j5wa6aUf19qU3xuQsmOA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 Jan 2012 15:41:51 -0700
Message-ID: <CAErSpo4wQ_oA6jtfoH7JW=0kaptHpYO4cVn-_1EziCSeKx4_oA@mail.gmail.com>
Subject: Re: [PATCH 3/4] PCI: restrict subordinate buses to those reachable
 via host bridge
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 3:23 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Jan 19, 2012 at 2:13 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Thu, Jan 19, 2012 at 1:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> please check attached patch.
>>
>> You added bus_max to pci_scan_root_bus().  I'd prefer to pass a
>> pointer to a struct resource, as we do for io & mem resources.
>
> Well that depends.

Well, I suppose it does.  On what?

>> I'd
>> like to move away from pci_scan_root_bus() and toward a
>> pci_scan_host_bridge() (as in the patches I posted) that takes all the
>> host bridge-related info: parent, domain, resources (including bus
>> number range), ops, sysdata.  I don't like the current scheme of
>> "create it with defaults and fix them later."
>
> No, struct host bridge is bad idea.  you are tracking host bridge and
> peer root bus the same time.

Obviously host bridges and root buses are related, but it'd be useful
if you could give some clue about *why* you think this is a bad idea.
Redundancy, complication, what?

Root buses are special in important ways, and we currently don't have
a way to deal with that.  For example, everything below a host bridge
has the same domain, and we don't have a good place to keep the
domain.  The busn_res you add to struct pci_bus is only useful for
root buses, so I don't think pci_bus is quite the right place.

>> struct pci_bus already has secondary & subordinate.  I don't think
>> adding a "struct resource busn_res" adds useful information except for
>> the root bus, where the bus number range comes from something external
>> like _CRS rather than from the upstream bridge config.
>
> no, we need that to tracking the busn usage. aka insert them into
> iobusn_resource tree.

If we want a tree, I think we should just convert pci_bus.secondary
and subordinate to a struct resource and insert that.  Otherwise we
have redundant information.

> late it should be convert to list head even. for handling transparent bridge.

I think you're talking about a host bridge that passes multiple bus
number ranges, e.g., a PNP0A08 device with "[bus 00-3f] [bus 80-ff]"
in _CRS.  That makes sense.  I haven't seen anything like that, but it
seems like it would be legal.  But that wouldn't make sense for a P2P
bridge, so it doesn't seem like pci_bus is the right place for it.

Bjorn
