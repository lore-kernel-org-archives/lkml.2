Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1GROoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:44:32 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57658 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1GROob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:44:31 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110718141943.GE31986@redhat.com>
References: <20110713184611.6dcb09b4@mschwide>
	 <20110713200004.GG4426@redhat.com> <20110714091800.720da848@mschwide>
	 <20110714175532.GE6672@redhat.com> <20110714180528.GF6672@redhat.com>
	 <1310739717.10789.31.camel@br98xy6r> <20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r> <20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r>  <20110718141943.GE31986@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 18 Jul 2011 16:44:13 +0200
Message-ID: <1311000253.4427.23.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 10:19 -0400, Vivek Goyal wrote:
> > > By parsing the ELF header. It will give you information about how many
> > > program headers and notes are there, their sizes and locations etc.
> > 
> > The only thing we need is the size of the preallocated header that is in
> > kdump memory. All other architectures seem to pass this information
> > somehow with different mechanisms to the kdump kernel (memmap kernel
> > parameter, boot parameters, etc.). Why should *we* parse the ELF header?
> 
> ELF headers and memmap parameters are communicating two different pieces
> of information to second kenrel.
> 
> - memap tells what memory second kernel can use to boot.
> - ELF headers tell what memory areas first kernel was using and using
>   that information how to construct ELF headers for /proc/vmcore interface
>   in second kernel. On x86, ELF headers also communicate where the saved
>   cpu state is for the first kernel.
> 
> Arch independent code in kdump kenrel (fs/proc/vmcore.c) is parsing those
> ELF headers to export /proc/vmcore. So if you set up the headers right
> you get that arch independent code for free without any changes to generic
> code.

Vivek, I know all these things. So, we (s390) do *not* have to parse the
ELF header. We only have to ensure the kexec prepared ELF header is
reserved until the /proc/vmcore parses it. All the ELF notes for CPUs,
etc. should automatically be reserved, because they are allocated in
oldmem by the old crashed kernel.

All what I was asking is how we pass best the information "size of the
preallocated ELF header" to the 2nd kernel for reserving the header. We
currently do not have the memmap kernel parameter.

> > 
> > > When kexec-tools loads ELF headers, it knows what's the total size of
> > > ELF headers and it removes that chunk of memory from the memory map
> > > passed to second kernel with memmap= options. IOW, some memory out
> > > of reserved region is not usable by second kernel because we have
> > > stored information in that memory. Kdump kernel maps that memory and
> > > gets to read the ELF headers.
> > > 
> > > So you shall have to do something similar where you need to tell second
> > > kernel what memory areas it can use for boot and remove ELF header
> > > memory area from the map.
> > 
> > So if we do that, why should we parse the ELF header?
> 
> To know three things.
> 
> - Memory areas being used by first kernel.
> - Cpu states at the time of crash of first kernel.
> - Some config options exported by first kernel with the help of ELF notes.

sure

> fs/proc/vmcore.c already does it for you. You just need to make sure that
> you tell it following.
> 
> - Where to find the headers in memory (elfcorehdr=)
> - A way to map that memory and access contents.

sure

> - Make sure these headers are not overwritten by newly booted kernel.

And that was my question: What is the best way to do that. E.g. we could
pass a 2nd kernel parameter "elfcorehdr_size", implement s390 boot
parameter or implement the memmap kernel parameter.

Currently the s390 kernel knows only two objects when booting: kernel
and ramdisk. Now with the ELF header we would have a third one.

Michael

