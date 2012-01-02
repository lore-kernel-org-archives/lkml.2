Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab2ABQMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 11:12:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43518 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2ABQMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 11:12:07 -0500
Message-ID: <4F01D750.7040304@redhat.com>
Date: Mon, 02 Jan 2012 17:12:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Minchan Kim <minchan@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to
 BIO
References: <1324429254-28383-1-git-send-email-minchan@kernel.org> <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com> <20111222234135.GB7056@barrios-laptop.redhat.com> <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
In-Reply-To: <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2012 05:45 PM, Stefan Hajnoczi wrote:
> By the way, drivers for solid-state devices can set QUEUE_FLAG_NONROT
> to hint that seek time optimizations may be sub-optimal.  NBD and
> other virtual/pseudo device drivers set this flag.  Should virtio-blk
> set it and how does it affect performance?

By itself is not a good idea in general.

When QEMU uses O_DIRECT, the guest should not use QUEUE_FLAG_NONROT 
unless it is active for the host disk as well.  (In doubt, as is the 
case for remote hosts accessed over NFS, I would also avoid NONROT and 
allow more coalescing).

When QEMU doesn't use O_DIRECT, instead, using QUEUE_FLAG_NONROT and 
leaving optimizations to the host may make some sense.

In Xen, the back-end driver is bio-based, so the scenario is like QEMU 
with O_DIRECT.  I remember seeing worse performance when switching the 
front-end to either QUEUE_FLAG_NONROT or the noop scheduler.  This was 
with RHEL5 (2.6.18), but it might still be true in more recent kernels, 
modulo benchmarking of course.  Still, the current in-tree xen-blkfront 
driver does use QUEUE_FLAG_NONROT unconditionally, more precisely its 
synonym QUEUE_FLAG_VIRT.

Still, if benchmarking confirms this theory, QEMU could expose a hint 
via a feature bit.  The default could be simply "use QUEUE_FLAG_NONROT 
iff not using O_DIRECT", or it could be more complicated with help from 
sysfs.

Paolo
