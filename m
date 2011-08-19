Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1HSN2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:16 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:45968 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab1HSN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:10 -0400
Subject: Re: [patch v3 2/8] kdump: Make kimage_load_crash_segment() weak
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110818171541.GC15413@redhat.com>
References: <20110812134849.748973593@linux.vnet.ibm.com>
	 <20110812134907.166585439@linux.vnet.ibm.com>
	 <20110818171541.GC15413@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 19 Aug 2011 15:27:52 +0200
Message-ID: <1313760472.3858.26.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Thu, 2011-08-18 at 13:15 -0400, Vivek Goyal wrote:
> On Fri, Aug 12, 2011 at 03:48:51PM +0200, Michael Holzheu wrote:
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > On s390 we do not create page tables at all for the crashkernel memory.
> > This requires a s390 specific version for kimage_load_crash_segment().
> > Therefore this patch declares this function as "__weak". The s390 version is
> > very simple. It just copies the kexec segment to real memory without using
> > page tables:
> > 
> > int kimage_load_crash_segment(struct kimage *image,
> >                               struct kexec_segment *segment)
> > {
> >         return copy_from_user_real((void *) segment->mem, segment->buf,
> >                                    segment->bufsz);
> > }
> > 
> > There are two main advantages of not creating page tables for the
> > crashkernel memory:
> > 
> > a) It saves memory. We have scenarios in mind, where crashkernel
> >    memory can be very large and saving page table space is important.
> > b) We protect the crashkernel memory from being overwritten.
> 
> Michael,
> 
> Thinking more about it. Can't we provide a arch specific version of
> kmap() and kunmap() so that we create temporary mappings to copy
> the pages and then these are torn off.

Isn't kmap/kunmap() used for higmem? These functions are called from
many different functions in the Linux kernel, not only for kdump. I
would assume that creating and removing mappings with these functions is
not what a caller would expect and probably would break the Linux kernel
at many other places, no?

Perhaps we can finish this discussion after my vacation. I will change
my patch series that we even do not need this patch...

So only two common code patches are remaining. I will send the common
code patches again and will ask Andrew Morton to integrate them in the
next merge window. The s390 patches will be integrated by Martin.

Michael

