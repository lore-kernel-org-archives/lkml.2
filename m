Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0EMXmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:42:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53866 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0EMXmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RqOpTcu+TtnOItdR4tRz5az/MW3cFAus9wQNxWsD/JhCsEr4cY6h5xQL0E7WG6mpwK
         9CJRFp2Ai46cebOql5buCnUiWhnba+sqxce35A2pyecBgIpb2BecmX592FRV4VkCUad5
         6uhU6hHniCHZUqSLkjtgn/awKRQsnIxC93IW4=
MIME-Version: 1.0
In-Reply-To: <31229.1273653365@redhat.com>
References: <20100511184949.6139.96826.stgit@localhost.localdomain>
	 <20100511185141.6139.98842.stgit@localhost.localdomain>
	 <31229.1273653365@redhat.com>
Date: Thu, 13 May 2010 16:42:30 -0700
X-Google-Sender-Auth: KTkd4gcEIlehCJjKGVHUd21yU6U
Message-ID: <AANLkTinHKVk9iWTKgEwcuKgmoCyCif2kSy3v0ZIsZ50p@mail.gmail.com>
Subject: Re: [PATCH 2/2] ioat2,3: convert to producer/consumer locking
From: Dan Williams <dan.j.williams@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 1:36 AM, David Howells <dhowells@redhat.com> wrote:
>
> Out of interest, does it make the code smaller if you mark
> ioat2_get_ring_ent() and ioat2_ring_mask() with __attribute_const__?
>
> I'm not sure whether it'll affect how long gcc is willing to cache these, but
> once computed, I would guess they won't change within the calling function.

Unfortunately, it does not make a difference, but I'll keep this in
mind if ioat2_get_ring_ent() ever gets more complicated (which it
might in the future).

> Also, is the device you're driving watching the ring and its indices?  If so,
> does it modify the indices?  If that is the case, you might need to use
> read_barrier_depends() rather than smp_read_barrier_depends().

The device does not observe the indices directly.  Instead we
increment a free running 'count' register by the distance between
ioat->pending and ioat->head.

>
>> +             prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
>> +             desc = ioat2_get_ring_ent(ioat, idx + i);
>>               dump_desc_dbg(ioat, desc);
>>               tx = &desc->txd;
>>               if (tx->cookie) {
>
> Is this right, I wonder?  You're prefetching [i+1] before reading [i]?  Doesn't
> this mean that you might have to wait for [i+1] to be retrieved from RAM before
> [i] can be read?  Should you instead read tx->cookie before issuing the
> prefetch?  Admittedly, this is only likely to affect the reading of the head of
> the queue - subsequent reads in the same loop will, of course, have been
> prefetched.

Yes, it should be the other way around.

Thanks!

--
Dan
