Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2K2IOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:14:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11816 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2K2IOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:14:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 29 Nov 2012 00:13:53 -0800
Message-ID: <50B71A28.5060807@nvidia.com>
Date: Thu, 29 Nov 2012 10:17:44 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Dave Airlie <airlied@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>     <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>     <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>     <50B46336.8030605@nvidia.com>     <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>     <50B476E1.4070403@nvidia.com>     <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>     <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur>     <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>     <50B4A483.8030305@nvidia.com>     <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>     <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>    <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur>   <50B6237B.8010808@nvidia.com> <1354115609.1479.91.camel@tellur>  <50B63A70.8020107@nvidia.com> <1354128408.1479.137.camel@tellur>
In-Reply-To: <1354128408.1479.137.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2012 20:46, Lucas Stach wrote:
> Am Mittwoch, den 28.11.2012, 18:23 +0200 schrieb Terje Bergström:
>> Sorry. I promised in another thread a write-up explaining the design. I
>> still owe you guys that.
> That would be really nice to have. I'm also particularly interested in
> how you plan to do synchronization of command streams to different
> engines working together, if that's not too much to ask for now. Like
> userspace uploading a texture in a buffer, 2D engine doing mipmap
> generation, 3D engine using mipmapped texture.

I can briefly explain (and then copy-paste to a coherent text once I get
to it) how inter-engine synchronization is done. It's not specifically
for 2D or 3D, but generic to any host1x client.

Sync point register is a counter that can only increase. It starts from
0 and is incremented by a host1x client or CPU. host1x can freeze a
channel until a sync point value is reached, and it can trigger an
interrupt upon reaching a threshold. On Tegra2 and Tegra3 we have 32
sync points.

host1x clients all implement a method for incrementing a sync point
based on a condition, and on all of them (well, not entirely true) the
register is number 0. The most used condition is op_done, telling the
client to increment sync point once the previous operations are done.

In kernel, we keep track of the active range of sync point values, i.e.
ones we expect to be reached with the active jobs. Active range's
minimum is the current value read from hw and shadowed in memory. At job
submit time, kernel increments the maximum by the number of sync points
the stream announces it will perform. After performing the increment, we
have a number, which the sync point is supposed to reach at the end of
submit. That number is the the fence and it is recorded in kernel and
returned to user space.

So, when user space flushes, it receives a fence. It can insert the
fence into another command stream as parameter to a host1x channel wait.
This makes that channel freeze until an operation in another channel is
finished. That's how different host1x clients can synchronize without
using CPU.

Kernel's sync point wait essentially puts the process into sleep until
host1x sends an interrupt and we determine the value that a process is
waiting for, has been reached.

On top of this, we guard against wrapping issues by nulling out any sync
point waits (CPU or inside stream) that are waiting for values outside
the active range, and we have a timeout for jobs so that we can kick out
misbehaving command streams.

> Ah yes I see. So if we consider nvhost to be the central entity in
> charge of controlling all host1x clients and tegradrm as the interface
> that happens to bundle display, 2d and 3d engine functionality into it's
> interface we should probably aim for two things:
> 1. Move everything needed by all engines down into nvhost (I especially
> see the allocator falling under this point, I'll explain why this would
> be beneficial a bit later)

Ok. This is almost the current design, except for the allocator.

> 2. Move the exposed DRM interface more in line with other DRM drivers.
> Please take a look at how for example the GEM_EXECBUF ioctl works on
> other drivers to get a feeling of what I'm talking about. Everything
> using the display, 2D and maybe later on the 3D engine should only deal
> with GEM handles. I really don't like the idea of having a single
> userspace application, which uses engines with similar and known
> requirements (DDX) dealing with dma-buf handles or other similar high
> overhead stuff to do the most basic tasks.
> If we move down the allocator into nvhost we can use buffers allocated
> from this to back GEM or V4L2 buffers transparently. The ioctl to
> allocate a GEM buffer shouldn't do much more than wrapping the nvhost
> buffer.

Ok, this is actually what we do downstream. We use dma-buf handles only
for purposes where they're really needed (in fact, none yet), and use
our downstream allocator handles for the rest. I did this, because
benchmarks were showing that memory management overhead shoot through
the roof if I tried doing everything via dma-buf.

We can move support for allocating GEM handles to nvhost, and GEM
handles can be treated just as another memory handle type in nvhost.
tegradrm would then call nvhost for allocation.


> This may also solve your problem with having multiple mappings of the
> same buffer into the very same address space, as nvhost is the single
> instance that manages all host1x client address spaces. If the buffer is
> originating from there you can easily check if it's already mapped. For
> Tegra 3 to do things in an efficient way we likely have to move away
> from dealing with the DMA API to dealing with the IOMMU API, this gets a
> _lot_ easier_ if you have a single point where you manage memory
> allocation and address space.

Yep, this would definitely simplify our IOMMU problem. But, I thought
the canonical way of dealing with device memory is DMA API, and you're
saying that we should just bypass it and call IOMMU directly?

>> Concurrency is handled with sync points. User space will know when a
>> command stream is processed and can be reused by comparing the current
>> sync point value, and the fence that 2D driver returned to user space.
>> User space can have a pool of buffers and can recycle when it knows it
>> can do so. But, this is not enforced by kernel.
>>
> This is the point where we have differ: You have to deal with syncpts in
> kernel anyway, otherwise you don't know when it's safe to destroy a
> buffer. And no, userspace should not have the ability to destroy a
> buffer itself, userspace should always just be able to free it's
> reference to the buffer. Remember: never trust the userspace. And if you
> are dealing with syncpts in kernel anyway, you can just go ahead and
> enforce some sane concurrency rules. There may be some corener cases
> related to userspace suballocating a kernel buffer, which might need
> some more thought still, but that's not a valid excuse to not do any
> concurrency validation in kernel.

nvhost is already dealing with sync points, and protecting memory from
being freed if it's used. We use refcounting to do that. When a job is
sent to hw, we get reference to all memory (command stream & surfaces).
When job is done (fence reached), nvhost unreferences them. User space
can free the memory it has allocated, but kernel would hold on to it
until it's safe to actually release the memory.

>> The difference with your proposal and what I posted is the level of
>> control user space has over its command stream management. But as said,
>> 2D streams are so short that my guess is that there's not too much
>> penalty copying it to kernel managed host1x push buffer directly instead
>> of inserting a GATHER reference.
>>
> This an implementation detail. Whether you shoot down the old pushbuf
> mapping and insert a new one pointing to free backing memory (which may
> be the way to go for 3D) or do an immediate copy of the channel pushbuf
> contents to the host1x pushbuf (which may be beneficial for very small
> pushs) is all the same. Both methods implicitly guarantee that the
> memory mapped by userspace always points to a location the CPU can write
> to without interfering with the GPU.

Ok. Based on this, I propose the way to go for cases without IOMMU
support and all Tegra20 cases (as Tegra20's GART can't provide memory
protection) is to copy the stream to host1x push buffer. In Tegra30 with
IOMMU support we can just reference the buffer. This way we don't have
to do expensive MMU operations.

> I really enjoyed the discussion so far and hope we can get to the point
> where we have a nice design/interface, working together.

Thanks. I don't have a strict deadline for upstreaming, so I'm fine
continuing with discussion until we're settled, and then doing the
needed changes.

My goal is to end up with something that we can take advantage of in
upstream with tegradrm and 2D, but also downstream with the rest of the
downstream stack. That way there's no technical barrier to us moving in
downstream to use the upstream code.

Terje
