Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1IPIVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:21:23 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:34167 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1IPIVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:21:20 -0400
Subject: Re: [patch 1/2] kdump: Initialize vmcoreinfo note at startup
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110915184637.GF32658@redhat.com>
References: <20110909102659.320220628@linux.vnet.ibm.com>
	 <20110909102732.497569031@linux.vnet.ibm.com>
	 <20110915184637.GF32658@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 16 Sep 2011 10:21:17 +0200
Message-ID: <1316161277.3507.8.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Thu, 2011-09-15 at 14:46 -0400, Vivek Goyal wrote:
> On Fri, Sep 09, 2011 at 12:27:00PM +0200, Michael Holzheu wrote:
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > Currently the vmcoreinfo note is only initialized in case of kdump. On s390
> > it is possible to create kernel dumps with other dump mechanisms than kdump
> > (e.g. via hypervisor dump or stand-alone dump tools).
> 
> Both of these will be invoked through panic notifiers because kdump kernel
> is not loaded?

This is only one possibility. The other is that they are invoked
manually or by hypervisor watchdog without any Linux kernel involvement.

> 
> >For those dumps it
> > would also be desirable to include the vmcoreinfo data.
> 
> Curious that how these two dump schemes make use vmcoreinfo data?

We have a tool named zgetdump. With this tool it is possible to convert
dump formats on the fly using fuse. E.g. you can mount a s390
stand-alone dump as ELF dump. When this is done, the tool finds the
vmcoreinfo in the stand-alone dump via our well known ABI defined
address and it creates the respective VMCOREINFO ELF note in the output
ELF dump. This then can be used e.g. by makedumpfile for dump filtering.
No more need for a vmlinux file with debug information.

So this will look like the following:

# zgetdump --mount standalone.dump -f elf /mnt
# ls /mnt
# dump.elf
# readelf -n /mnt/dump.elf
# ...
  VMCOREINFO		0x00000474	Unknown note type: (0x00000000)
# makedumpfile -c -d 31 /mnt/dump.elf dump.kdump

> 
> > To accomplish this,
> > with this patch the vmcoreinfo ELF note is always initialized, not only in
> > case of a (kdump) crash. On s390 we will add an ABI defined pointer at
> > a well known address to vmcoreinfo so that dump analysis tools are able to
> > find this information.
> 
> Instead of this, why don't you initialize the notes in your arch specific
> call. IOW, why don't you give a call to crash_save_vmcoreinfo() in stand
> alone dump path to prepare the note and then continue with stand alone
> dump.

We can't do that because stand-alone and hypervisor dump can be
triggered completely without Linux. So no Linux kernel function can/will
be called.

Michael

