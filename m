Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0ESIHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:07:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0ESIG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:06:59 -0400
Message-ID: <4BF39C12.7090407@redhat.com>
Date: Wed, 19 May 2010 11:06:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
 ring itself
References: <20100505205814.GA7090@redhat.com> <201005071253.53393.rusty@rustcorp.com.au> <4BE9AF9A.8080005@redhat.com> <201005191709.16401.rusty@rustcorp.com.au>
In-Reply-To: <201005191709.16401.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 10:39 AM, Rusty Russell wrote:
>
> I think we're talking about the last 2 entries of the avail ring.  That means
> the worst case is 1 false bounce every time around the ring.

It's low, but why introduce an inefficiency when you can avoid doing it 
for the same effort?

> I think that's
> why we're debating it instead of measuring it :)
>    

Measure before optimize is good for code but not for protocols.  
Protocols have to be robust against future changes.  Virtio is warty 
enough already, we can't keep doing local optimizations.

> Note that this is a exclusive->shared->exclusive bounce only, too.
>    

A bounce is a bounce.

Virtio is already way too bouncy due to the indirection between the 
avail/used rings and the descriptor pool.  A device with out of order 
completion (like virtio-blk) will quickly randomize the unused 
descriptor indexes, so every descriptor fetch will require a bounce.

In contrast, if the rings hold the descriptors themselves instead of 
pointers, we bounce (sizeof(descriptor)/cache_line_size) cache lines for 
every descriptor, amortized.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

