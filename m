Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2GFUij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:38:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32978 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab2GFUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <CANHD2=pEham5SZ6EguurMd9MBuyptyx5CGF1RDhU8Ow9CaRoXA@mail.gmail.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com> <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
 <CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
 <20120528140448.GA22783@redhat.com> <CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
 <20120529092154.GA2441@redhat.com> <CAErSpo6Xxq_kcEYACKUsuNDOJDhEDnxWgBUateOJEBcfqufhSg@mail.gmail.com>
 <CANHD2=o-eyd2JR7oK4gJgQi3Mi-a=R1RKuGsuWzzR_WosQaNEA@mail.gmail.com>
 <20120702053110.GA2500@redhat.com> <CANHD2=pEham5SZ6EguurMd9MBuyptyx5CGF1RDhU8Ow9CaRoXA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 6 Jul 2012 14:38:14 -0600
Message-ID: <CAErSpo6Jq0oaq0Scq46C=_6LNhMyBv76QxHQDpujsuq-bizytQ@mail.gmail.com>
Subject: Re: Initializing iwl3945 error
To: Kamil Grzebien <ciptok@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 2:49 PM, Kamil Grzebien <ciptok@gmail.com> wrote:
> On Mon, Jul 2, 2012 at 6:31 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Sun, Jul 01, 2012 at 07:01:58PM +0100, Kamil Grzebien wrote:
>>> I haven't tried your patch yet, but wanted to share with one thing.
>>> Currently I use new kernel 3.4.3, where the problem doesn't exist
>>> anymore. However I still would like to know what was the cause and
>>> which change brought the solution. Is there anything which comes to
>>> your mind in terms of recent changes in kernel? I also added logs from
>>> the newest kernel, so it might be easier for track it.
>>
>> Below is the diff from working kernel and non working kernel.
>> You are using PAE kernel what influence PCI mappings. Is this fixed also
>> on 3.4 non-PAE kernel?
>
> The problem is also fixed in non-PAE kernel. I've attached the logs
> from that kernel also. Besides that currently I was comparing both PAE
> kernels installed on my machine - kernel 3.3.7 (problem exist) and
> kernel 3.4.3 (problem solved). There must be something that has
> changed either in the code or maybe kernel configuration!?

I compared your 3.3.0 and 3.4.3 logs:

    -Linux version 3.3.0-4.fc16.i686
(mockbuild@x86-04.phx2.fedoraproject.org) gcc version 4.6.2 20111027
(Red Hat 4.6.2-1) (GCC) ) #1 SMP Tue Mar 20 18:45:14 UTC 2012
    +Linux version 3.4.3-1.fc17.i686
(mockbuild@x86-04.phx2.fedoraproject.org) gcc
version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Mon Jun 18
20:52:37 UTC 2012

I don't see much that's different, except this:

    -pci 0000:03:09.1: reg 10: [mem 0xf1bff400-0xf1bff4ff]
    +pci 0000:03:09.1: reg 10: [mem 0xf1bff500-0xf1bff5ff]

which hints that the BIOS configured that device (an SD Host
controller) differently.  Is it possible that a BIOS setup change is
what made the difference?  Can you reproduce the failure and success
on the exact same hardware & BIOS setup?  I also notice the 3.3.0
failure was apparently on battery power and the 3.4.3 success was with
AC power.  Shouldn't matter, but obviously *something* that shouldn't
matter does matter in this case.

The problem device is 0000:0b:00.0, and the bridge 00:1c.1 leads to
bus 0b.  There's a little bit more noise in 3.4.3 related to 1c.1
bridge windows, but the ultimate configuration is the same except for
the 64-bit pref window, which 0b:00.0 doesn't use anyway:

 pci 0000:0b:00.0: reg 10: [mem 0xf1eff000-0xf1efffff]
-pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
+pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 0b-0b]
add_size 1000
+pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus
0b-0b] add_size 200000
+pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref]
get_res_add_size add_size 200000
+pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
+pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
 pci_bus 0000:0b: resource 1 [mem 0xf1e00000-0xf1efffff]
-pci_bus 0000:0b: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
+pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]

Any ideas, Yinghai?

Bjorn
