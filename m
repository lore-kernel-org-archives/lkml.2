Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1HSSts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:49:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54390 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1HSStp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110819175316.GA999@ime.usp.br>
References: <20110819175316.GA999@ime.usp.br>
Date: Fri, 19 Aug 2011 15:49:44 -0300
X-Google-Sender-Auth: 8T5fE6P83BwDg0ukl8vKmq5yhOc
Message-ID: <CAOtrxKNVckzkxM=ahV13kV=7-Jtj=WWkx_So4pCdVX3e8mdjPw@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] Notebook crashes upon detecting the PCI
 subsystem with kernels >= 2.6.24-rc7
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Thomas Meyer <thomas@m3y3r.de>,
        Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi once again.

2011/8/19 Rogério Brito <rbrito@ime.usp.br>:
> ,----[ git bisect bad ]
> | 12c22d6ef299ccf0955e5756eb57d90d7577ac68 is the first bad commit
> | commit 12c22d6ef299ccf0955e5756eb57d90d7577ac68
> | Author: Linus Torvalds <torvalds@linux-foundation.org>
> | Date:   Wed Mar 26 11:22:40 2008 -0700
> |
> |     Revert "PCI: remove transparent bridge sizing"
(...)
> `----

Reverting the commit above with the patch below makes me able to
compile and run Linus's v3.1-rc2:

diff --cc drivers/pci/setup-bus.c
index 8a1d3c7,125e7b7..0000000
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@@ -783,16 -486,14 +783,14 @@@ void __ref __pci_bus_size_bridges(struc
  		break;

  	case PCI_CLASS_BRIDGE_PCI:
+ 		/* don't size subtractive decoding (transparent)
+ 		 * PCI-to-PCI bridges */
+ 		if (bus->self->transparent)
+ 			break;
  		pci_bridge_check_ranges(bus);
- 		if (bus->self->is_hotplug_bridge) {
- 			additional_io_size  = pci_hotplug_io_size;
- 			additional_mem_size = pci_hotplug_mem_size;
- 		}
- 		/*
- 		 * Follow thru
- 		 */
+ 		/* fall through */
  	default:
 -		pbus_size_io(bus);
 +		pbus_size_io(bus, 0, additional_io_size, add_head);
  		/* If the bridge supports prefetchable range, size it
  		   separately. If it doesn't, or its prefetchable window
  		   has already been allocated by arch code, try



-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
