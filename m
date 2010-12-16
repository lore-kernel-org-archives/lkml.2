Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0LPBYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 20:24:04 -0500
Received: from mail.vyatta.com ([76.74.103.46]:54999 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab0LPBYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 20:24:02 -0500
Date: Wed, 15 Dec 2010 17:23:58 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "Tang, Xinan" <xinan.tang@intel.com>,
        Junchang Wang <junchangwang@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
Message-ID: <20101215172358.64a611c8@nehalam>
In-Reply-To: <20101216011425.GA17446@linux-os.sc.intel.com>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	<46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	<1292446118.2603.11.camel@edumazet-laptop>
	<20101216011425.GA17446@linux-os.sc.intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 17:14:25 -0800
Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Wed, Dec 15, 2010 at 12:48:38PM -0800, Eric Dumazet wrote:
> > Le mercredi 15 décembre 2010 à 12:02 -0800, Fenghua Yu a écrit :
> > > From: Fenghua Yu <fenghua.yu@intel.com>
> > > 
> > > Multiqueue and multicore provide packet parallel processing methodology.
> > > Current kernel and network drivers place one queue on one core. But the higher
> > > level socket doesn't know multiqueue. Current socket only can receive or send
> > > packets through one network interfaces. In some cases e.g. multi bpf filter
> > > tcpdump and snort, a lot of contentions come from socket operations like ring
> > > buffer. Even if the application itself has been fully parallelized and run on
> > > multi-core systems and NIC handlex tx/rx in multiqueue in parallel, network layer
> > > and NIC device driver assemble packets to a single, serialized queue. Thus the
> > > application cannot actually run in parallel in high speed.
> > > 
> > > To break the serialized packets assembling bottleneck in kernel, one way is to
> > > allow socket to know multiqueue associated with a NIC interface. So each socket
> > > can handle tx/rx in one queue in parallel.
> > > 
> > > Kernel provides several interfaces by which sockets can be bound to rx/tx queues.
> > > User applications can configure socket by providing several sockets that each
> > > bound to a single queue, applications can get data from kernel in parallel. After
> > > that, competitions mentioned above can be removed.
> > > 
> > > With this patch, the user-space receiving speed on a Intel SR1690 server with
> > > a single L5640 6-core processor and a single ixgbe-based NIC goes from 0.73Mpps
> > > to 4.20Mpps, nearly a linear speedup. A Intel SR1625 server two E5530 4-core
> > > processors and a single ixgbe-based NIC goes from 0.80Mpps to 4.6Mpps. We noticed
> > > the performance penalty comes from NUMA memory allocation.
> > > 
> > 
> > ??? please elaborate on these NUMA memory allocations. This should be OK
> > after commit 564824b0c52c34692d (net: allocate skbs on local node)
> > 
> > > This patch set provides kernel ioctl interfaces for user space. User space can
> > > either directly call the interfaces or libpcap interfaces can be further provided
> > > on the top of the kernel ioctl interfaces.
> > 
> > So, say we have 8 queues, you want libpcap opens 8 sockets, and bind
> > them to each queue. Add a bpf filter to each one of them. This seems not
> > generic way, because it wont work for an UDP socket for example.
> 
> This only works for AF_PACKET like this patch set shows.
> 
> > And you already can do this using SKF_AD_QUEUE (added in commit
> > d19742fb)
> 
> SKF_AD_QUEUE doesn't know number of rx queues. Thus user application can't
> specify right SKF_AD_QUEUE.
> 
> SKF_AD_QUEUE only works for rx. There is no queue bound interfaces for tx.
> 
> I can change the patch set to use SKF_AD_QUEUE by removing the set rx queue
> interface and still keep interfaces of
> #define SIOGNUMRXQUEUE 0x8939  /* Get number of rx queues. */
> #define SIOGNUMTXQUEUE 0x893A  /* Get number of tx queues. */
> #define SIOSTXQUEUEMAPPING     0x893C  /* Set tx queue mapping. */
> #define SIOGRXQUEUEMAPPING     0x893D  /* Get rx queue mapping. */
> #define SIOGTXQUEUEMAPPING     0x893E  /* Get tx queue mapping. */
> 
> > 
> > Also your AF_PACKET patch only address mmaped sockets.
> > 
> The new patch set will use SKF_AD_QUEUE for rx. So it won't be limited to mmaped
> sockets.

Do we really want to expose this kind of internals to userspace?
The problem is once exposed, it becomes a kernel ABI and can not ever
change. 
-- 
