Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2JSI0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:26:37 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:7071 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2JSI0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:26:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344211200"; 
   d="scan'208";a="15269907"
Message-ID: <50810EB8.3060801@citrix.com>
Date: Fri, 19 Oct 2012 10:26:32 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: James Harper <james.harper@bendigoit.com.au>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Oliver Chick <oliver.chick@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC] Persistent grant maps for xen blk drivers
References: <1350559321-19066-1-git-send-email-roger.pau@citrix.com> <6035A0D088A63A46850C3988ED045A4B32C1043A@BITCOM1.int.sbss.com.au>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B32C1043A@BITCOM1.int.sbss.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10/12 03:34, James Harper wrote:
>>
>> This patch implements persistent grants for the xen-blk{front,back}
>> mechanism. The effect of this change is to reduce the number of unmap
>> operations performed, since they cause a (costly) TLB shootdown. This allows
>> the I/O performance to scale better when a large number of VMs are
>> performing I/O.
>>
>> Previously, the blkfront driver was supplied a bvec[] from the request
>> queue. This was granted to dom0; dom0 performed the I/O and wrote
>> directly into the grant-mapped memory and unmapped it; blkfront then
>> removed foreign access for that grant. The cost of unmapping scales badly
>> with the number of CPUs in Dom0. An experiment showed that when
>> Dom0 has 24 VCPUs, and guests are performing parallel I/O to a ramdisk, the
>> IPIs from performing unmap's is a bottleneck at 5 guests (at which point
>> 650,000 IOPS are being performed in total). If more than 5 guests are used,
>> the performance declines. By 10 guests, only
>> 400,000 IOPS are being performed.
>>
>> This patch improves performance by only unmapping when the connection
>> between blkfront and back is broken.
> 
> I assume network drivers would suffer from the same affliction... Would a more general persistent map solution be worth considering (or be possible)? So a common interface to this persistent mapping allowing the persistent pool to be shared between all drivers in the DomU?

Yes, there are plans to implement the same for network drivers. I would
generally avoid having a shared pool of grants for all the devices of a
DomU, as said in the description of the patch:

Blkback stores a mapping of grefs=>{page mapped to by gref} in
a red-black tree. As the grefs are not known apriori, and provide no
guarantees on their ordering, we have to perform a search
through this tree to find the page, for every gref we receive. This
operation takes O(log n) time in the worst case.

Having a shared pool with all grants would mean that n will become much
higher, and so the search time for a grant would increase. Also, if the
pool is shared some kind of concurrency control should be added, which
will make it even slower.

What should be shared are the structures used to save the grants (struct
grant and struct persistent_gnt for front and back drivers
respectively), and the red-black tree implementation (foreach_grant,
add_persistent_gnt and get_persistent_gnt). This functions should be
moved to a common header for the net implementation.
