Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2ASWOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:14:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39968 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706Ab2ASWOU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:14:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXj8W4G_SRKCFU-gHJRZ+qENPAs8WAcZA_PVgoageHcoQ@mail.gmail.com>
References: <20120118003335.467.71863.stgit@bhelgaas.mtv.corp.google.com>
 <20120118003512.467.60770.stgit@bhelgaas.mtv.corp.google.com>
 <CAE9FiQXvLAJVY-t8EJHkJgugtRsPdT9SS=60vA+by6qMCd5-Wg@mail.gmail.com>
 <CAErSpo7xgJmT=gs8axiY-OseyurqwUEqYixm692kmZAoA-2sNw@mail.gmail.com>
 <CAE9FiQUMEv+=mXzGc_muM_zTQ14S8tVex+bYgyyM1F++37Cu8w@mail.gmail.com>
 <CAErSpo7Awb97fn=bZECqaf4RF4Tmkh1_sUf6_Vk+jgv5jCYNTw@mail.gmail.com> <CAE9FiQXj8W4G_SRKCFU-gHJRZ+qENPAs8WAcZA_PVgoageHcoQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 Jan 2012 15:13:57 -0700
Message-ID: <CAErSpo5cAQVJq858QGi0N_TM91PsKj0jzvUUT8_yA9ezf_wXAQ@mail.gmail.com>
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

On Thu, Jan 19, 2012 at 1:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Jan 18, 2012 at 9:46 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Wed, Jan 18, 2012 at 10:27 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Wed, Jan 18, 2012 at 8:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> If we make a quirk for this machine, we still have the question of
>>>> what to do with my patches.  I assert that if Linux ever reconfigures
>>>> any bus numbers or does any configuration of hot-added P2P bridges, it
>>>> must pay attention to the host bridge bus number window.  Therefore, I
>>>> think we need something like this series even if we make a quirk.
>>>
>>> We may need more smart way to find unused bus range instead of just
>>> just max+1 and ++max.
>>>
>>> For example:  one bridge (A) have two child bridges (B and C),
>>> A: bus range: 10-2f
>>> B: bus range: 11-1f
>>> C: bus range: 20-2f
>>>
>>> when some broken case happen, B bus BIOS assigned bus range will be
>>> all cleared in first pass.
>>> but C bus is ok.  but in second bus, bus will be assigned to 30- .
>>> that is totally wrong, We should still
>>> try to use bus 11-1f at first for bus B.
>>
>> Yes, I agree we may need a better way to choose bus numbers in the
>> first place.  My current patch (3/4) doesn't change how we choose
>> them; it only rejects invalid ones.
>
> come out draft about bus number tracking and allocate bus range instead.
>
> please check attached patch.

It's a pain to comment on attached patches vs. inline ones.

You added bus_max to pci_scan_root_bus().  I'd prefer to pass a
pointer to a struct resource, as we do for io & mem resources.  I'd
like to move away from pci_scan_root_bus() and toward a
pci_scan_host_bridge() (as in the patches I posted) that takes all the
host bridge-related info: parent, domain, resources (including bus
number range), ops, sysdata.  I don't like the current scheme of
"create it with defaults and fix them later."

The printk %pR format supports bus numbers so you don't need to print
them by hand.

struct pci_bus already has secondary & subordinate.  I don't think
adding a "struct resource busn_res" adds useful information except for
the root bus, where the bus number range comes from something external
like _CRS rather than from the upstream bridge config.

This makes pci_scan_bridge() significantly more ugly than it already
is.  I think it needs to get broken up.
