Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0IPHGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:06:00 -0400
Received: from iona.labri.fr ([147.210.8.143]:53655 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab0IPHF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:05:59 -0400
X-Greylist: delayed 2034 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 03:05:59 EDT
Message-ID: <4C91B9E9.4020701@ens-lyon.org>
Date: Thu, 16 Sep 2010 08:32:09 +0200
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
References: <20100915104855.41de3ebf@lilo> <4C90A6C7.9050607@redhat.com> <20100916001232.0c496b02@lilo>
In-Reply-To: <20100916001232.0c496b02@lilo>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/09/2010 16:42, Christopher Yeoh a écrit :
> On Wed, 15 Sep 2010 12:58:15 +0200
> Avi Kivity <avi@redhat.com> wrote:
>
>   
>>   On 09/15/2010 03:18 AM, Christopher Yeoh wrote:
>>     
>>> The basic idea behind cross memory attach is to allow MPI programs
>>> doing intra-node communication to do a single copy of the message
>>> rather than a double copy of the message via shared memory.
>>>       
>> If the host has a dma engine (many modern ones do) you can reduce
>> this to zero copies (at least, zero processor copies).
>>     
> Yes, this interface doesn't really support that. I've tried to keep
> things really simple here, but I see potential for increasing
> level/complexity of support with diminishing returns:
>
> 1. single copy (basically what the current implementation does)
> 2. support for async dma offload (rather arch specific)
> 3. ability to map part of another process's address space directly into
>    the current one. Would have setup/tear down overhead, but this would
>    be useful specifically for reduction operations where we don't even
>    need to really copy the data once at all, but use it directly in
>    arithmetic/logical operations on the receiver.
>
> For reference, there is also knem http://runtime.bordeaux.inria.fr/knem/
> which does implement (2) for I/OAT, though it looks to me the interface
> and implementation are relatively speaking quite a bit more complex.
>   

I am the guy doing KNEM so I can comment on this. The I/OAT part of KNEM
was mostly a research topic, it's mostly useless on current machines
since the memcpy performance is much larger than I/OAT DMA Engine. We
also have an offload model with a kernel thread, but it wasn't used a
lot so far. These features can be ignored for the current discussion.

We've been working on this for a while with MPICH and OpenMPI developers
(both already use KNEM), and here's what I think is missing in
Christopher's proposal:
* Vectorial buffer support: MPI likes things like datatypes, which make
buffers non-contigous. You could add vectorial buffer support to your
interface, but the users would have to store the data-representation of
each process in all processes. Not a good idea, it's easier to keep the
knowledge of the non-contigous-ness of the remote buffer only in the
remote process.
* Collectives: You don't want to pin/unpin the same region over and
over, it's overkill when multiple processes are reading for the same
exact buffer (broadcast) or from contigous parts of the same buffer
(scatter).

So what we do in KNEM is:
* declare a memory region (sets of non-contigous segments + protection),
aka get_user_pages and return an associated cookie id
* have syscalls to read/write from region given a cookie, an offset in
the region and a length
This one-sided interface looks like an InfiniBand model, but only for
intra-node data transfers.

So OpenMPI and MPICH declare regions, pass their cookies through their
shared-memory buffer, and the remote process reads from there. Then,
they notify the first process that it may destroy the region (can be
automatic if the region creator passed a specific flag saying destroy
after first use).

Brice

