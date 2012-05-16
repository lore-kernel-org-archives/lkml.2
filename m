Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966487Ab2EPIz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965328Ab2EPIzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:55:20 -0400
Message-ID: <4FB36B68.5000009@redhat.com>
Date: Wed, 16 May 2012 11:55:04 +0300
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>,
        linux-kernel@vger.kernel.org, acking@vmware.com, dtor@vmware.com,
        dsouders@vmware.com, cschamp@vmware.com, akpm@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        kvm-devel <kvm@vger.kernel.org>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [vmw_vmci RFC 00/11] VMCI for Linux
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com> <20120515235024.GB1758@kroah.com>
In-Reply-To: <20120515235024.GB1758@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 02:50 AM, Greg KH wrote:
> On Tue, May 15, 2012 at 08:06:57AM -0700, Andrew Stiegmann (stieg) wrote:
>> In an effort to improve the out-of-the-box experience with Linux
>> kernels for VMware users, VMware is working on readying the Virtual
>> Machine Communication Interface (vmw_vmci) and VMCI Sockets (vmw_vsock) kernel
>> modules for inclusion in the Linux kernel. The purpose of this post
>> is to acquire feedback on the vmw_vmci kernel module. The vmw_vsock
>> kernel module will be presented in a later post.
>>
>> VMCI allows virtual machines to communicate with host kernel modules
>> and the VMware hypervisors. User level applications both in a virtual
>> machine and on the host can use vmw_vmci through VMCI Sockets, a socket
>> address family designed to be compatible with UDP and TCP at the
>> interface level. Today, VMCI and VMCI Sockets are used by the VMware
>> shared folders (HGFS) and various VMware Tools components inside the
>> guest for zero-config, network-less access to VMware host services. In
>> addition to this, VMware's users are using VMCI Sockets for various
>> applications, where network access of the virtual machine is
>> restricted or non-existent. Examples of this are VMs communicating
>> with device proxies for proprietary hardware running as host
>> applications and automated testing of applications running within
>> virtual machines.
>>
>> In a virtual machine, VMCI is exposed as a regular PCI device. The
>> primary communication mechanisms supported are a point-to-point
>> bidirectional transport based on a pair of memory-mapped queues, and
>> asynchronous notifications in the form of datagrams and
>> doorbells. These features are available to kernel level components
>> such as HGFS and VMCI Sockets through the VMCI kernel API. In addition
>> to this, the VMCI kernel API provides support for receiving events
>> related to the state of the VMCI communication channels, and the
>> virtual machine itself.
>
> Don't we have something like this already for KVM and maybe Xen?

We have virtio-serial driver for guest-host communication:
http://fedoraproject.org/wiki/Features/VirtioSerial
http://www.linux-kvm.org/page/VMchannel_Requirements

Amit Shah, the writer is CCed as well as kvm-devel.

> virtio?  Can't you use that code instead of a new block of code that is
> only used by vmware users?  It has virtual pci devices which should give
> you what you want/need here, right?
>
> If not, why doesn't that work for you?  Would it be easier to just
> extend it?

KVM uses virtio-serial as a pci device which has 'ports' on top of it. 
The ports acts like channels that can be created dynamically and allows 
guest userspace <-> host userspace communication.
In theory, the kvm mechanism should be a good fit for other hypervisors.

Nevertheless, despite my biased love for KVM, I bet it would be 'tricky' 
for VMW to change their hardware model and shift to virtio hardware 
abstraction. In addition, they'll be required to change existing apps 
that use their socket code.

One can bunker in our rightful requirement of 'upstream first' but this 
may slow/vanish the benefits of getting VMW code upstream for out of the 
box experience for Linux users.

IMHO, let's be practical and include this pci device (pending standard 
review) but _require_ that the VMCI sockets family will be a general 
mechanism that may be used over virtio-serial as well.
Andrew, it would be the best to work w/ Amit and various other KVM 
hackers to get your (changed) code upstream.

Regards,
Dor

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

