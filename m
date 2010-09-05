Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0IEQul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:50:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab0IEQuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:50:40 -0400
Message-ID: <4C83CA5A.7030404@redhat.com>
Date: Sun, 05 Sep 2010 19:50:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Cam Macdonell <cam@cs.ualberta.ca>
CC: "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] Guest cannot handle a PCI BAR > 1GB
References: <AANLkTimk19OmkNYvVemxgyFfgByNDDq6R2fa6=FQ8H9L@mail.gmail.com>
In-Reply-To: <AANLkTimk19OmkNYvVemxgyFfgByNDDq6R2fa6=FQ8H9L@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/04/2010 01:22 AM, Cam Macdonell wrote:
> Hi,
>
> I'm trying to test 2 GB (and eventually larger) BARs with ivshmem and
> I get an error in the guest that it is able to find a mem resource for
> a BAR larger than 1GB.  I'm using 64-bit BARs.
>
> when running with 6GB of RAM and a 1GB BAR for ivshmem, it finds a
> resource (and searches beyond 32-bit values to find it).  Here is a
> log from printfs added to the loop that searches the resources from
> find_resource() in kernel/resource.c:363.
>

This is a kernel question, not a qemu issue.  Copying lkml.

> trying 'tmp.start' 1000 to
>          'tmp.end' fff
> trying 'tmp.start' 9f400 to
>          'tmp.end' 9f3ff
> trying 'tmp.start' a0000 to
>          'tmp.end' effff
> trying 'tmp.start' 100000 to
>          'tmp.end' fffff
> trying 'tmp.start' dfffd000 to
>          'tmp.end' dfffcfff
> trying 'tmp.start' e0000000 to
>          'tmp.end' efffffff
> trying 'tmp.start' f2000000 to
>          'tmp.end' f1ffffff
> trying 'tmp.start' f2001000 to
>          'tmp.end' f200ffff
> trying 'tmp.start' f2020000 to
>          'tmp.end' f201ffff
> trying 'tmp.start' f2021000 to
>          'tmp.end' f202ffff
> trying 'tmp.start' f2040000 to
>          'tmp.end' f203ffff
> trying 'tmp.start' f2040100 to
>          'tmp.end' febfffff
> trying 'tmp.start' fec00400 to
>          'tmp.end' fffbffff
> trying 'tmp.start' 100000000 to
>          'tmp.end' ffffffff
> trying 'tmp.start' 1a0000000 to
>          'tmp.end' ffffffffffffffff
> pci 0000:00:04.0: BAR 2: assigned [mem 0x1c0000000-0x1ffffffff 64bit]
> pci 0000:00:04.0: BAR 2: set to [mem 0x1c0000000-0x1ffffffff 64bit]
> (PCI address [0x1c0000000-0x1ffffffff]
>
> and you can see the BAR is successfully assigned.
>
> However, with a 2GB BAR (below), the search fails, but it also never
> searches beyong 32-bits.  Again, all that's changed is the size of the
> ivshmem region.
>
> trying 'tmp.start' 1000 to
>          'tmp.end' fff
> trying 'tmp.start' 9f400 to
>          'tmp.end' 9f3ff
> trying 'tmp.start' a0000 to
>          'tmp.end' effff
> trying 'tmp.start' 100000 to
>          'tmp.end' fffff
> trying 'tmp.start' dfffd000 to
>          'tmp.end' dfffcfff
> pci 0000:00:04.0: BAR 2: can't assign mem (size 0x80000000)
>
> Is there a limit to PCI BAR sizes or resources?  Any pointers or
> further debugging tips are greatly appreciated.
>

What kernel version are you looking at?

Please add printks to the loop so we can see this->start and this->end.  
It smells like a truncation issue.

-- 
error compiling committee.c: too many arguments to function

