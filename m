Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1GFJZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:25:13 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:56559 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab1GFJZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:25:09 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110705202615.GJ24348@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
	 <20110705202615.GJ24348@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 06 Jul 2011 11:24:47 +0200
Message-ID: <1309944287.3937.39.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivec,

On Tue, 2011-07-05 at 16:26 -0400, Vivek Goyal wrote:
> On Mon, Jul 04, 2011 at 07:09:22PM +0200, Michael Holzheu wrote:

[snip]

> I don't understand what is stand-alone dump tools and 

S390 stand-alone dump tools are independent mini operating systems that
are installed on disks or tapes. When a dump should be created, these
stand-alone dump tools are booted. All that they do is to write the dump
(current memory plus the CPU registers) to the disk/tape device.

The advantage compared to kdump is that since they are freshly loaded
into memory they can't be overwritten in memory. Another advantage is
that since it is different code, it is much less likely that the dump
tool will run into the same problem than the previously crashed kernel.
Also the boot process ensures that the hardware is in a initialized
state. And last but not least, with the stand-alone dump tools you can
dump early kernel problems which is not possible using kdump, because
you can't dump before the kdump kernel has been loaded with kexec.

That were more or less the arguments, why we did not support kdump in
the past.

In order to increase dump reliability with kdump, we now implemented a
two stage approach. The stand-alone dump tools first check via meminfo,
if kdump is valid using checksums. If kdump is loaded and healthy it is
started. Otherwise the stand-alone dump tools create a full-blown
stand-alone dump.

With this approach we still keep our s390 dump reliability and gain the
great kdump features, e.g. distributor installer support, dump filtering
with makedumpfile, etc.

> why the existing
> mechanism of preparing ELF headers to describe all the above info
> and just passing the address of header on kernel commnad line
> (crashkernel=) will not work for s390. Introducing an entirely new
> infrastructure for communicating the same information does not
> sound too exciting.

We need the meminfo interface anyway for the two stage approach. The
stand-alone dump tools have to find and verify the kdump kernel in order
to start it. Therefore the interface is there and can be used. Also
creating the ELF header in the 2nd kernel is more flexible and easier
IMHO:
* You do not have to care about memory or CPU hotplug.
* You do not have to preallocate CPU crash notes etc.
* It works independently from the tool/mechanism that loads the kdump
kernel into memory. E.g. we have the idea to load the kdump kernel at
boot time into the crashkernel memory (not via the kexec_load system
call). That would solve the main kdump problems: The kdump kernel can't
be overwritten by I/O and also early kernel problems could then be
dumped using kdump.

What do you think?

Michael

