Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2BEQgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 11:36:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38156 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2BEQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 11:36:11 -0500
Message-ID: <4F2EAFF6.7030006@codemonkey.ws>
Date: Sun, 05 Feb 2012 10:36:06 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com>	<4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com>
In-Reply-To: <20120205095153.GA29265@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 03:51 AM, Gleb Natapov wrote:
> On Sun, Feb 05, 2012 at 11:44:43AM +0200, Avi Kivity wrote:
>> On 02/05/2012 11:37 AM, Gleb Natapov wrote:
>>> On Thu, Feb 02, 2012 at 06:09:54PM +0200, Avi Kivity wrote:
>>>> Device model
>>>> ------------
>>>> Currently kvm virtualizes or emulates a set of x86 cores, with or
>>>> without local APICs, a 24-input IOAPIC, a PIC, a PIT, and a number of
>>>> PCI devices assigned from the host.  The API allows emulating the local
>>>> APICs in userspace.
>>>>
>>>> The new API will do away with the IOAPIC/PIC/PIT emulation and defer
>>>> them to userspace.  Note: this may cause a regression for older guests
>>>> that don't support MSI or kvmclock.  Device assignment will be done
>>>> using VFIO, that is, without direct kvm involvement.
>>>>
>>> So are we officially saying that KVM is only for modern guest
>>> virtualization?
>>
>> No, but older guests may have reduced performance in some workloads
>> (e.g. RHEL4 gettimeofday() intensive workloads).
>>
> Reduced performance is what I mean. Obviously old guests will continue working.

An interesting solution to this problem would be an in-kernel device VM.

Most of the time, the hot register is just one register within a more complex 
device.  The reads are often side-effect free and trivially computed from some 
device state + host time.

If userspace had a way to upload bytecode to the kernel that was executed for a 
PIO operation, it could either pass the operation to userspace or handle it 
within the kernel when possible without taking a heavy weight exit.

If the bytecode can access variables in a shared memory area, it could be pretty 
efficient to work with.

This means that the kernel never has to deal with specific in-kernel devices but 
that userspace can accelerator as many of its devices as it sees fit.

This could replace ioeventfd as a mechanism (which would allow clearing the 
notify flag before writing to an eventfd).

We could potentially just use BPF for this.

Regards,

Anthony Liguori
