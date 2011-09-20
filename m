Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1ITPhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:37:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1ITPhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:37:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [GIT] Bcache version 12
Date: Tue, 20 Sep 2011 17:37:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
References: <20110910064531.GA32536@moria>
In-Reply-To: <20110910064531.GA32536@moria>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109201737.05515.arnd@arndb.de>
X-Provags-ID: V02:K0:5rru6ReqY8IKfSHXOWMusal8mqN3t5j2u4dIuUVqTcD
 CqWDFUFdW/VxRLD/EIpdMFLYBjtp2ryqZyYVcbwigAReKUf26R
 NMChhGVSkRkcTRthC+FKVKjLqrZ2DC/aKiiQPA4ACK2lyLOmA1
 Dj8VsVjrnW5O8seOeu/wfxJxFFPFCI5UXK2u4FPNxU6T2jYdrb
 2wwtWKjVctvlKQ7+sbprtC4SnxxTpFFvTzc7RBqpjIlmxqVvrU
 XRLep94+UgB9rgL/dQM/V7qROL/aDJlUP+NRUGSPVaXSsHgvB1
 R5AlQD1OAndLFVHwPIUtisPJbcI7GL87Ob6RQ/MTkFW0NQl4nm
 R3KxRij/irOO9GhEj8l0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011, Kent Overstreet wrote:
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself
> as a new block device, a bit like say md. You can cache an arbitrary
> number of block devices with a single cache device, and attach and
> detach things at runtime - it's quite flexible.
> 
> It's very fast. It uses a b+ tree for the index, along with a journal to
> coalesce index updates, and a bunch of other cool tricks like auxiliary
> binary search trees with software floating point keys to avoid a bunch
> of random memory accesses when doing binary searches in the btree. It
> does over 50k iops doing 4k random writes without breaking a sweat,
> and would do many times that if I had faster hardware.
> 
> It (configurably) tracks and skips sequential IO, so as to efficiently
> cache random IO. It's got more cool features than I can remember at this
> point. It's resilient, handling IO errors from the SSD when possible up
> to a configurable threshhold, then detaches the cache from the backing
> device even while you're still using it.

Hi Kent,

What kind of SSD hardware do you target here? I roughly categorize them
into two classes, the low-end (USB, SDHC, CF, cheap ATA SSD) and the
high-end (SAS, PCIe, NAS, expensive ATA SSD), which have extremely
different characteristics. 

I'm mainly interested in the first category, and a brief look at your
code suggests that this is what you are indeed targetting. If that is
true, can you name the specific hardware characteristics you require
as a minimum? I.e. what erase block (bucket) sizes do you support
(maximum size, non-power-of-two), how many buckets do you have
open at the same time, and do you guarantee that each bucket is written
in consecutive order?

On a different note, we had discussed at the last storage/fs summit about
using an SSD cache either without a backing store or having the backing
store on the same drive as the cache in order to optimize traditional
file system on low-end flash media. Have you considered these scenarios?
How hard would it be to support this in a meaningful way? My hope is that
by sacrificing some 10% of the drive size, you would get significantly
improved performance because you can avoid many internal GC cycles within
the drive.

	Arnd
