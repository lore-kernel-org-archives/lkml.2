Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1DJCyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 22:54:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50232 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1DJCyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 22:54:41 -0400
Message-ID: <4DA11BEE.1080500@codemonkey.ws>
Date: Sat, 09 Apr 2011 21:54:38 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com> <4D9847BC.9060906@redhat.com> <4D98716D.9040307@codemonkey.ws> <4D9873CD.3080207@redhat.com> <20110406093333.GB6465@elte.hu> <4D9E6F6E.9050709@codemonkey.ws> <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com> <4D9F150B.1030809@codemonkey.ws> <20110409182347.GB27431@dspnet.fr>
In-Reply-To: <20110409182347.GB27431@dspnet.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2011 01:23 PM, Olivier Galibert wrote:
> On Fri, Apr 08, 2011 at 09:00:43AM -0500, Anthony Liguori wrote:
>> Really, having a flat table doesn't make sense.  You should just send
>> everything to an i440fx directly.  Then the i440fx should decode what it
>> can, and send it to the next level, and so forth.
> No you shouldn't.  The i440fx should merge and arbitrate the mappings
> and then push *direct* links to the handling functions at the top
> level.  Mapping changes don't happen often on modern hardware, and
> decoding is expensive.

Decoding is not all that expensive.  For non-PCI devices, the addresses 
are almost always fixed so it becomes a series of conditionals and 
function calls with a length of no more than 3 or 4.

For PCI devices, any downstream devices are going to fall into specific 
regions that the bridge registers.  Even in the pathological case of a 
bus populated with 32 multi-function devices each having 6 bars, it's 
still a non-overlapping list of ranges.  There's nothing that prevents 
you from storing a sorted version of the list such that you can binary 
search to the proper dispatch device.  Binary searching a list of 1500 
entries is quite fast.

In practice, you have no more than 10-20 PCI devices with each device 
having 2-3 bars.  A simple linear search is not going to have a 
noticeable overhead.

>    Incidentally, you can have special handling
> functions which are in reality references to kernel handlers,
> shortcutting userspace entirely for critical ports/mmio ranges.

The cost here is the trip from the guest to userspace and back.  If you 
want to short cut in the kernel, you have to do that *before* returning 
to userspace.  In that case, how userspace models I/O flow doesn't matter.

The reason flow matters is that PCI controllers alter I/O.  Most PCI 
devices use little endian for device registers and some big endian 
oriented buses will automatically do endian conversion.

Even without those types of controllers, if you use a native endian API, 
an MMIO dispatch API is going to do endian conversion to the target 
architecture.  However, if you're expecting to return the data in little 
endian (as PCI registers are expected to usually be), you need to flip 
the endianness.

In QEMU, we handle this by registering bars with a function pointer 
trampoline to do this.  But this is with the special API.  If you hook 
the mapping API, you'll probably get this wrong.

Regards,

Anthony Liguori

>    OG.

