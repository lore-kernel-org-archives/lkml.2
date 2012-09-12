Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2ILGde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:33:34 -0400
Received: from ozlabs.org ([203.10.76.45]:45993 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2ILGd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:33:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Lendacky <tahm@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache when possible
In-Reply-To: <14037987.hiN6MSGY6z@tomlt1.ibmoffice.com>
References: <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120906084526.GE17656@redhat.com> <87txvahfv3.fsf@rustcorp.com.au> <14037987.hiN6MSGY6z@tomlt1.ibmoffice.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 12 Sep 2012 15:43:11 +0930
Message-ID: <87bohbdb0o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Lendacky <tahm@linux.vnet.ibm.com> writes:
> I ran some TCP_RR and TCP_STREAM sessions, both host-to-guest and
> guest-to-host, with a form of the histogram patch applied against a
> RHEL6.3 kernel. The histogram values were reset after each test.

Hey, thanks!  This is exactly what I wanted to see...

> 60 session TCP_RR from host-to-guest with 256 byte request and 256 byte
> response for 60 seconds:
>
> Queue histogram for virtio1:
> Size distribution for input (max=7818456):
>  1: 7818456 ################################################################

These are always 1, so we don't indirect them anyway, so no cache required.

> Size distribution for output (max=7816698):
>  2: 149     
>  3: 7816698 ################################################################
>  4: 2       
>  5: 1       
> Size distribution for control (max=1):
>  0: 0

OK, tiny TCP data, but latency sensitive.

> Queue histogram for virtio1:
> Size distribution for input (max=16050941):
>  1: 16050941 ################################################################
> Size distribution for output (max=1877796):
>  2: 1877796 ################################################################
>  3: 5       
> Size distribution for control (max=1):
>  0: 0

Acks.  Not that many, not that latency sensitive.

> 4 session TCP_STREAM from guest-to-host with 4K message size for 60 seconds:
>
> Queue histogram for virtio1:
> Size distribution for input (max=1316069):
>  1: 1316069 ################################################################
> Size distribution for output (max=879213):
>  2: 24      
>  3: 24097   #
>  4: 23176   #
>  5: 3412    
>  6: 4446    
>  7: 4663    
>  8: 4195    
>  9: 3772    
> 10: 3388    
> 11: 3666    
> 12: 2885    
> 13: 2759    
> 14: 2997    
> 15: 3060    
> 16: 2651    
> 17: 2235    
> 18: 92721   ######  
> 19: 879213  ################################################################

Hey, that +1 is there in MAX_SKB_FRAGS for a reason!  Who knew?

This looks like we could really use a:

        int vq_set_indirect_cache(struct virtqueue *vq, unsigned num);

Which networking would set on the xmit queue(s) if we have GSO.

The real question is now whether we'd want a separate indirect cache for
the 3 case (so num above should be a bitmap?), or reuse the same one, or
not use it at all?

Benchmarking will tell...

Thanks,
Rusty.
