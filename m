Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1GRP0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1GRPZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:25:59 -0400
Date: Mon, 18 Jul 2011 11:25:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110718152532.GF31986@redhat.com>
References: <20110714091800.720da848@mschwide>
 <20110714175532.GE6672@redhat.com>
 <20110714180528.GF6672@redhat.com>
 <1310739717.10789.31.camel@br98xy6r>
 <20110715143820.GG3428@redhat.com>
 <1310744603.10789.79.camel@br98xy6r>
 <20110718123140.GB31986@redhat.com>
 <1310997641.4427.10.camel@br98xy6r>
 <20110718141943.GE31986@redhat.com>
 <1311000253.4427.23.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311000253.4427.23.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 04:44:13PM +0200, Michael Holzheu wrote:
> On Mon, 2011-07-18 at 10:19 -0400, Vivek Goyal wrote:
> > > > By parsing the ELF header. It will give you information about how many
> > > > program headers and notes are there, their sizes and locations etc.
> > > 
> > > The only thing we need is the size of the preallocated header that is in
> > > kdump memory. All other architectures seem to pass this information
> > > somehow with different mechanisms to the kdump kernel (memmap kernel
> > > parameter, boot parameters, etc.). Why should *we* parse the ELF header?
> > 
> > ELF headers and memmap parameters are communicating two different pieces
> > of information to second kenrel.
> > 
> > - memap tells what memory second kernel can use to boot.
> > - ELF headers tell what memory areas first kernel was using and using
> >   that information how to construct ELF headers for /proc/vmcore interface
> >   in second kernel. On x86, ELF headers also communicate where the saved
> >   cpu state is for the first kernel.
> > 
> > Arch independent code in kdump kenrel (fs/proc/vmcore.c) is parsing those
> > ELF headers to export /proc/vmcore. So if you set up the headers right
> > you get that arch independent code for free without any changes to generic
> > code.
> 
> Vivek, I know all these things. So, we (s390) do *not* have to parse the
> ELF header. We only have to ensure the kexec prepared ELF header is
> reserved until the /proc/vmcore parses it. All the ELF notes for CPUs,
> etc. should automatically be reserved, because they are allocated in
> oldmem by the old crashed kernel.
> 

[..]
> All what I was asking is how we pass best the information "size of the
> preallocated ELF header" to the 2nd kernel for reserving the header. We
> currently do not have the memmap kernel parameter.

In theory you could come up with another command line option to pass
which also tells size of header segment. But having a generic
mechanism to provide memory map to second kernel will be more useful.
The reason being that apart from ELF headers there might be more
segments/memory areas which you need to exclude from the view of second
kernel.

For example, backup reason on x86. This is a reason of 640K in reserved
area where we copy the contets of first 640K of memory. In the past
it looked like that even though we have relocatable kernel, it still
needed some memory in low memory rgions. So we copy the contents of
first 640K in backup area in reserved memory region and exclude that
memory from the memory kdump kenrel can use (again using memmap=
options).

How do you pass memory map to kernel in s390? Isn't there a way
to modify that? That would be easiest I think.

If you have only 1 memory area to exclude, probably you can get away
with implementing elfcorehdrsize parameter. But this will be highly
arch specific and works only if there is one memory area you want to
exlucde.

Or for s390, implement a new parameter excludemem=x@y where you
tell kernel not to use specified memory area and kexec-tools should
be able to put right commnad line options for second kernel.

> 
> > > 
> > > > When kexec-tools loads ELF headers, it knows what's the total size of
> > > > ELF headers and it removes that chunk of memory from the memory map
> > > > passed to second kernel with memmap= options. IOW, some memory out
> > > > of reserved region is not usable by second kernel because we have
> > > > stored information in that memory. Kdump kernel maps that memory and
> > > > gets to read the ELF headers.
> > > > 
> > > > So you shall have to do something similar where you need to tell second
> > > > kernel what memory areas it can use for boot and remove ELF header
> > > > memory area from the map.
> > > 
> > > So if we do that, why should we parse the ELF header?
> > 
> > To know three things.
> > 
> > - Memory areas being used by first kernel.
> > - Cpu states at the time of crash of first kernel.
> > - Some config options exported by first kernel with the help of ELF notes.
> 
> sure
> 
> > fs/proc/vmcore.c already does it for you. You just need to make sure that
> > you tell it following.
> > 
> > - Where to find the headers in memory (elfcorehdr=)
> > - A way to map that memory and access contents.
> 
> sure
> 
> > - Make sure these headers are not overwritten by newly booted kernel.
> 
> And that was my question: What is the best way to do that. E.g. we could
> pass a 2nd kernel parameter "elfcorehdr_size", implement s390 boot
> parameter or implement the memmap kernel parameter.

You could do that but I think a more generic parameter will make more
sense.

- Either something along the lines of memmap=
- Or excludemem=x@y
- Or modify memory map in s390 specific bootloading protocol block etc.

Thanks
Vivek
