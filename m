Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab1CCDsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:48:08 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:52262 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1CCDsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:48:07 -0500
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Low-level Fibre Channel
Date: Thu, 3 Mar 2011 06:48:01 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103030648.01846@blacky.localdomain>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In a project we work on, we are using custom hardware that provides direct 
access to low-level Fibre Channel protocol layers. So software (running on 
linux host) can send/receive FC2 sequences and even individual FC1 frames. 
This is used to work with "non-so-mainstream" FC protocols (such as those 
used in avionics) that commodity FC hardware can't deal with.

I'm now working on drivers for that.

I was going to implement /dev/fcraw device class with ioctl()s to send and 
receive FC1/FC2, and provide in-kernel API for particular device drivers.
This is something I've already done for mil-std-1553 devices, and also for 
other devices, and have experience with.

Question I'd like to ask is - isn't it better to use socket-based API - 
create FC protocol family, support sockets to send and receive FC2 
sequences or FC1 frames, etc etc

I currently have very limited experience with in-kernel network layer.
Is there any practical benefit in doing socket-based API instead of a 
custom ioctl()-based API (e.g.: easier to implement or to use)?

Maybe someone did FC protocol family support before? I wasn't able to find, 
but still?

I guess that FC1 frames (~2200 bytes max) can map well into skb's, but what 
about FC2 sequences that are up to 16 megabytes in size? Is linux network 
layer ready to handle "messages" of that size?

If creating custom interface, I could use in-memory receive buffer that is 
DMAed to by hardware, and read-only mmapped into consumer process address 
space. Thus avoiding on-cpu copy, which could be essential for high data 
rates of FC. Is something similar implementable within socket API?

[we have device that does FC2 in hardware, and can DMA received FC2 
sequences in chunks of 64 kilobytes, but for application software, having 
entire sequence continuous in application's virtual address space is much 
preferred]

Also, to handle high data rate, I am thinking of early filtering. Such as 
driver could first analyse header of particular incoming frame or sequence 
(using direct access to adapter memory via pci), and then decide if it's 
content should be DMAed from adapter memory to host memory or not. Doesn't 
this conflict with socket API?

Any other advice on topic?

Thanks.

Nikita

P.S.
Btw, anyone interested in /dev/mstd1553 or /dev/arinc429? We can share some 
code... although particular API implemented is overengineered and 
questionable, and driver support is done only for virtual devices and for 
several adapters manufactured by local Russian companies not widely known.
