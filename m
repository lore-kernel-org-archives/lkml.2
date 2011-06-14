Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1FNPxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:53:50 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43318 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FNPxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b5l73+oqw1pv3Jf5YSjn/JHYcgZP7YpKQOAZTaNn2WN14tnV9Pr9HT3od9bQwelP04
         FpIUABDV/Yg7IIb1jaiTJs+A6KVNwhtxcdbRdlRLRcRymYfV0J3J3jSr76nUyqZkIVV5
         GY1ZlDOeQLFaV9A2Jrrp7XRhmCB0hwGJBQZeY=
MIME-Version: 1.0
In-Reply-To: <4DF71E28.6070009@suse.de>
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
	<4DF71E28.6070009@suse.de>
Date: Tue, 14 Jun 2011 16:53:46 +0100
Message-ID: <BANLkTimcXuLjhKrhdzRtELvqu9JMHS8vCQ@mail.gmail.com>
Subject: Re: virtio scsi host draft specification, v3
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 9:39 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 06/10/2011 04:35 PM, Paolo Bonzini wrote:
>>>
>>> If requests are placed on arbitrary queues you'll inevitably run on
>>> locking issues to ensure strict request ordering.
>>> I would add here:
>>>
>>> If a device uses more than one queue it is the responsibility of the
>>> device to ensure strict request ordering.
>>
>> Applied with s/device/guest/g.
>>
>>> Please do not rely in bus/target/lun here. These are leftovers from
>>> parallel SCSI and do not have any meaning on modern SCSI
>>> implementation (eg FC or SAS). Rephrase that to
>>>
>>> The lun field is the Logical Unit Number as defined in SAM.
>>
>> Ok.
>>
>>>>      The status byte is written by the device to be the SCSI status
>>>>      code.
>>>
>>> ?? I doubt that exists. Make that:
>>>
>>> The status byte is written by the device to be the status code as
>>> defined in SAM.
>>
>> Ok.
>>
>>>>      The response byte is written by the device to be one of the
>>>>      following:
>>>>
>>>>      - VIRTIO_SCSI_S_OK when the request was completed and the
>>>>      status byte
>>>>        is filled with a SCSI status code (not necessarily "GOOD").
>>>>
>>>>      - VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires
>>>>      transferring
>>>>        more data than is available in the data buffers.
>>>>
>>>>      - VIRTIO_SCSI_S_ABORTED if the request was cancelled due to a
>>>>      reset
>>>>        or another task management function.
>>>>
>>>>      - VIRTIO_SCSI_S_FAILURE for other host or guest error. In
>>>>      particular,
>>>>        if neither dataout nor datain is empty, and the
>>>>        VIRTIO_SCSI_F_INOUT
>>>>        feature has not been negotiated, the request will be
>>>>        immediately
>>>>        returned with a response equal to VIRTIO_SCSI_S_FAILURE.
>>>>
>>> And, of course:
>>>
>>> VIRTIO_SCSI_S_DISCONNECT if the request could not be processed due
>>> to a communication failure (eg device was removed or could not be
>>> reached).
>>
>> Ok.
>>
>>> This specification implies a strict one-to-one mapping between host
>>> and target. IE there is no way of specifying more than one target
>>> per host.
>>
>> Actually no, the intention is to use hierarchical LUNs to support
>> more than one target per host.
>>
> Can't.
>
> Hierarchical LUNs is a target-internal representation.
> The initiator (ie guest OS) should _not_ try to assume anything about the
> internal structure and just use the LUN as an opaque number.
>
> Reason being that the LUN addressing is not unique, and there are several
> choices on how to represent a given LUN.
> So the consensus here is that different LUN numbers represent
> different physical devices, regardless on the (internal) LUN representation.
> Which in turn means we cannot use the LUN number to convey anything else
> than a device identification relative to a target.
>
> Cf SAM-3 paragraph 4.8:
>
> A logical unit number is a field (see 4.9) containing 64 bits that
> identifies the logical unit within a SCSI target device
> when accessed by a SCSI target port.
>
> IE the LUN is dependent on the target, but you cannot make assumptions on
> the target.
>
> Consequently, it's in the hosts' responsibility to figure out the targets in
> the system. After that it invokes the 'scan' function from the SCSI
> midlayer.
> You can't start from a LUN and try to figure out the targets ...
>
> If you want to support more than on target per host you need some sort of
> enumeration/callback which allows the host to figure out
> the number of available targets.
> But in general the targets are referenced by the target port identifier as
> specified in the appropriate standard (eg FC or SAS).
> Sadly, we don't have any standard to fall back on for this.
>
> If, however, we decide to expose some details about the backend, we could be
> using the values from the backend directly.
> EG we could be forwarding the SCSI target port identifier here
> (if backed by real hardware) or creating our own SAS-type
> identifier when backed by qemu block. Then we could just query
> the backend via a new command on the controlq
> (eg 'list target ports') and wouldn't have to worry about any protocol
> specific details here.

I think we want to be able to pass through one or more SCSI targets,
so we probably need a 'list target ports' control command.

Stefan
