Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab0IHABv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:01:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58525 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0IHABt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim9EOUVuSq6Z3q6-j-x2w+JDD8F-_xH614uDFi8@mail.gmail.com>
References: <AANLkTimk19OmkNYvVemxgyFfgByNDDq6R2fa6=FQ8H9L@mail.gmail.com>
	<4C83CA5A.7030404@redhat.com>
	<AANLkTimtATH7JvBRXBbnr0hJ5bFrtOa_3vsZRe4a_rfR@mail.gmail.com>
	<AANLkTim9EOUVuSq6Z3q6-j-x2w+JDD8F-_xH614uDFi8@mail.gmail.com>
Date: Tue, 7 Sep 2010 18:01:48 -0600
X-Google-Sender-Auth: buIFG25sYsoDrDzPP4bkmTPtsGA
Message-ID: <AANLkTimGui3atGAa-FE=6JhF1rM7BU0xtN-T4mZKqD8_@mail.gmail.com>
Subject: Re: [Qemu-devel] [solved] Guest cannot handle a PCI BAR > 1GB
From: Cam Macdonell <cam@cs.ualberta.ca>
To: Avi Kivity <avi@redhat.com>
Cc: "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Wright <chrisw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems it was the alignment value being passed back from
pci_resource_alignment().  The return type is an int, which was
causing value of 2GB to be sign extended to to 0xffffffff80000000.
Changing the return type to resource_size_t allows BAR values >= 2GB
to be successfully assigned.

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 679c39d..3d23522 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -318,7 +318,7 @@ static inline int pci_ats_enabled(struct pci_dev *dev)
 }
 #endif /* CONFIG_PCI_IOV */

-static inline int pci_resource_alignment(struct pci_dev *dev,
+static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
                                         struct resource *res)
 {
 #ifdef CONFIG_PCI_IOV


On Mon, Sep 6, 2010 at 11:24 AM, Cam Macdonell <cam@cs.ualberta.ca> wrote:
> On Mon, Sep 6, 2010 at 10:37 AM, Cam Macdonell <cam@cs.ualberta.ca> wrote:
>>
>>
>> On Sun, Sep 5, 2010 at 10:50 AM, Avi Kivity <avi@redhat.com> wrote:
>>>
>>>  On 09/04/2010 01:22 AM, Cam Macdonell wrote:
>>>>
>>>> Hi,
>>>>
>>>> I'm trying to test 2 GB (and eventually larger) BARs with ivshmem and
>>>> I get an error in the guest that it is able to find a mem resource for
>>>> a BAR larger than 1GB.  I'm using 64-bit BARs.
>>>>
>>>> when running with 6GB of RAM and a 1GB BAR for ivshmem, it finds a
>>>> resource (and searches beyond 32-bit values to find it).  Here is a
>>>> log from printfs added to the loop that searches the resources from
>>>> find_resource() in kernel/resource.c:363.
>>>>
>>>
>>> This is a kernel question, not a qemu issue.  Copying lkml.
>>>
>>>> trying 'tmp.start' 1000 to
>>>>         'tmp.end' fff
>>>> trying 'tmp.start' 9f400 to
>>>>         'tmp.end' 9f3ff
>>>> trying 'tmp.start' a0000 to
>>>>         'tmp.end' effff
>>>> trying 'tmp.start' 100000 to
>>>>         'tmp.end' fffff
>>>> trying 'tmp.start' dfffd000 to
>>>>         'tmp.end' dfffcfff
>>>> trying 'tmp.start' e0000000 to
>>>>         'tmp.end' efffffff
>>>> trying 'tmp.start' f2000000 to
>>>>         'tmp.end' f1ffffff
>>>> trying 'tmp.start' f2001000 to
>>>>         'tmp.end' f200ffff
>>>> trying 'tmp.start' f2020000 to
>>>>         'tmp.end' f201ffff
>>>> trying 'tmp.start' f2021000 to
>>>>         'tmp.end' f202ffff
>>>> trying 'tmp.start' f2040000 to
>>>>         'tmp.end' f203ffff
>>>> trying 'tmp.start' f2040100 to
>>>>         'tmp.end' febfffff
>>>> trying 'tmp.start' fec00400 to
>>>>         'tmp.end' fffbffff
>>>> trying 'tmp.start' 100000000 to
>>>>         'tmp.end' ffffffff
>>>> trying 'tmp.start' 1a0000000 to
>>>>         'tmp.end' ffffffffffffffff
>>>> pci 0000:00:04.0: BAR 2: assigned [mem 0x1c0000000-0x1ffffffff 64bit]
>>>> pci 0000:00:04.0: BAR 2: set to [mem 0x1c0000000-0x1ffffffff 64bit]
>>>> (PCI address [0x1c0000000-0x1ffffffff]
>>>>
>>>> and you can see the BAR is successfully assigned.
>>>>
>>>> However, with a 2GB BAR (below), the search fails, but it also never
>>>> searches beyong 32-bits.  Again, all that's changed is the size of the
>>>> ivshmem region.
>>>>
>>>> trying 'tmp.start' 1000 to
>>>>         'tmp.end' fff
>>>> trying 'tmp.start' 9f400 to
>>>>         'tmp.end' 9f3ff
>>>> trying 'tmp.start' a0000 to
>>>>         'tmp.end' effff
>>>> trying 'tmp.start' 100000 to
>>>>         'tmp.end' fffff
>>>> trying 'tmp.start' dfffd000 to
>>>>         'tmp.end' dfffcfff
>>>> pci 0000:00:04.0: BAR 2: can't assign mem (size 0x80000000)
>>>>
>>>> Is there a limit to PCI BAR sizes or resources?  Any pointers or
>>>> further debugging tips are greatly appreciated.
>>>>
>>>
>>> What kernel version are you looking at?
>>
>> latest kvm git, 2.6.36-rc2+
>>
>>>
>>> Please add printks to the loop so we can see this->start and this->end.  It smells like a truncation issue.
>>
>> Success with a 1GB BAR
>> this->start 1000, this->end 9f3ff
>> this->start 9f400, this->end 9ffff
>> this->start f0000, this->end fffff
>> this->start 100000, this->end dfffcfff
>> this->start dfffd000, this->end dfffffff
>> this->start f0000000, this->end f1ffffff
>> this->start f2000000, this->end f2000fff
>> this->start f2010000, this->end f201ffff
>> this->start f2020000, this->end f2020fff
>> this->start f2030000, this->end f203ffff
>> this->start f2040000, this->end f20400ff
>> this->start fec00000, this->end fec003ff
>> this->start fffc0000, this->end ffffffff
>> this->start 100000000, this->end 11fffffff
>> tmp.start 120000000, tmp.end ffffffffffffffff
>> pci 0000:00:04.0: BAR 2: assigned [mem 0x140000000-0x17fffffff 64bit]
>> and when it fails with a 2GB BAR, the following is printed
>> this->start 1000, this->end 9f3ff
>> this->start 9f400, this->end 9ffff
>> this->start f0000, this->end fffff
>> this->start 100000, this->end dfffcfff
>> this->start dfffd000, this->end dfffffff
>> pci 0000:00:04.0: BAR 2: can't assign mem (size 0x80000000)
>> I added a few more debug statements and found that in the failure case, the function returns that it found a region (the last one printed before the error).  I've added printfs for the two tests in the if that determine when a region is found:
>>        if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
>>             new->start = tmp.start;
>>             new->end = tmp.start + size - 1;
>>             printk(KERN_INFO "returning 0\n");
>>             return 0;
>>         }
>> this->start 1000, this->end 9f3ff
>> tmp.start 80000000, tmp.end fff
>>     true: ffffffff80000fff >= 7fffffff
>> this->start 9f400, this->end 9ffff
>> tmp.start 80000000, tmp.end 9f3ff
>>     true: ffffffff8009f3ff >= 7fffffff
>> this->start f0000, this->end fffff
>> tmp.start 80000000, tmp.end effff
>>     true: ffffffff800effff >= 7fffffff
>> this->start 100000, this->end dfffcfff
>> tmp.start 80000000, tmp.end fffff
>>     true: ffffffff800fffff >= 7fffffff
>> this->start dfffd000, this->end dfffffff
>> tmp.start 100000, tmp.end dfffcfff
>>     true: 100000 < dfffcfff
>>     true: dfefcfff >= 7fffffff
>> returning 0
>> pci 0000:00:04.0: BAR 2: can't assign mem (size 0x80000000)
>
> Further to this, it seems tmp.start is getting set to zero by the ALIGN macro
>
> 2GB BAR:
> this->start dfffd000, this->end dfffffff
> tmp.start dfffd000
> tmp.start 0
> tmp.start 100000, tmp.end dfffcfff
>
> 1GB BAR:
> this->start dfffd000, this->end dfffffff
> tmp.start dfffd000
> tmp.start 100000000
> tmp.start 100000000, tmp.end dfffcfff
>
> I'll dig into the ALIGN macro.
>
>>
>>
>>
>>
>>>
>>> --
>>> error compiling committee.c: too many arguments to function
>>>
>>
>
