Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0LOUsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:48:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64508 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab0LOUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:48:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k7t3cIWFHNH6YBDHA1r8ELmTin2eR9yShyH3atMEQQpNHk5HyKfTNSIo07G9O90CVM
         mwWs33UuoBcGoqqJDwpKg12UKwbSRoWfGU2QYp2lJXhj/wACJfGP/6PsdXcGtPp3BSsc
         ei+Y5zYo/znCA81hjV6Dsbl7kgLyJT4K6NQu4=
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Xinan Tang <xinan.tang@intel.com>,
        Junchang Wang <junchangwang@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	 <46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 21:48:38 +0100
Message-ID: <1292446118.2603.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 décembre 2010 à 12:02 -0800, Fenghua Yu a écrit :
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Multiqueue and multicore provide packet parallel processing methodology.
> Current kernel and network drivers place one queue on one core. But the higher
> level socket doesn't know multiqueue. Current socket only can receive or send
> packets through one network interfaces. In some cases e.g. multi bpf filter
> tcpdump and snort, a lot of contentions come from socket operations like ring
> buffer. Even if the application itself has been fully parallelized and run on
> multi-core systems and NIC handlex tx/rx in multiqueue in parallel, network layer
> and NIC device driver assemble packets to a single, serialized queue. Thus the
> application cannot actually run in parallel in high speed.
> 
> To break the serialized packets assembling bottleneck in kernel, one way is to
> allow socket to know multiqueue associated with a NIC interface. So each socket
> can handle tx/rx in one queue in parallel.
> 
> Kernel provides several interfaces by which sockets can be bound to rx/tx queues.
> User applications can configure socket by providing several sockets that each
> bound to a single queue, applications can get data from kernel in parallel. After
> that, competitions mentioned above can be removed.
> 
> With this patch, the user-space receiving speed on a Intel SR1690 server with
> a single L5640 6-core processor and a single ixgbe-based NIC goes from 0.73Mpps
> to 4.20Mpps, nearly a linear speedup. A Intel SR1625 server two E5530 4-core
> processors and a single ixgbe-based NIC goes from 0.80Mpps to 4.6Mpps. We noticed
> the performance penalty comes from NUMA memory allocation.
> 

??? please elaborate on these NUMA memory allocations. This should be OK
after commit 564824b0c52c34692d (net: allocate skbs on local node)

> This patch set provides kernel ioctl interfaces for user space. User space can
> either directly call the interfaces or libpcap interfaces can be further provided
> on the top of the kernel ioctl interfaces.

So, say we have 8 queues, you want libpcap opens 8 sockets, and bind
them to each queue. Add a bpf filter to each one of them. This seems not
generic way, because it wont work for an UDP socket for example.
And you already can do this using SKF_AD_QUEUE (added in commit
d19742fb)

Also your AF_PACKET patch only address mmaped sockets.



