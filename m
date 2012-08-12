Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab2HLIgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 04:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2HLIgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 04:36:38 -0400
Message-ID: <50276B11.8020708@redhat.com>
Date: Sun, 12 Aug 2012 11:36:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
References: <20120724203628.21081.56884.stgit@bling.home>  <20120724204320.21081.32333.stgit@bling.home> <501F99A8.9050006@redhat.com>  <501F9E99.9010109@redhat.com> <501F9F27.708@redhat.com> <1344540375.3441.228.camel@ul30vt.home>
In-Reply-To: <1344540375.3441.228.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 10:26 PM, Alex Williamson wrote:
> On Mon, 2012-08-06 at 13:40 +0300, Avi Kivity wrote:
>> On 08/06/2012 01:38 PM, Avi Kivity wrote:
>> 
>> > Regarding the implementation, instead of a linked list, would an array
>> > of counters parallel to the bitmap make it simpler?
>> 
>> Or even, replace the bitmap with an array of counters.
> 
> I'm not sure a counter array is what we're really after.  That gives us
> reference counting for the irq source IDs, but not the key->gsi lookup.

You can look up the gsi while registering the eoifd, so it's accessible
as eoifd->gsi instead of eoifd->source->gsi.  The irqfd can go away
while the eoifd is still active, but is this a problem?


> It also highlights another issue, that we have a limited set of source
> IDs.  Looks like we have BITS_PER_LONG IDs, with two already used, one
> for the shared userspace ID and another for the PIT.  How happy are we
> going to be with a limit of 62 level interrupts in use at one time?

When we start being unhappy we can increase that number.  On the other
hand more locks and lists makes me unhappy now.

> 
> It's arguably a reasonable number since the most virtualization friendly
> devices (sr-iov VFs) don't even support this kind of interrupt.  It's
> also very wasteful allocating an entire source ID for a single GSI
> within that source ID.  PCI supports interrupts A, B, C, and D, which,
> in the most optimal config, each go to different GSIs.  So we could
> theoretically be more efficient in our use and allocation of irq source
> IDs if we tracked use by the source ID, gsi pair.

There are, in one userspace, just three gsis available for PCI links, so
you're compressing the source id space by 3.

> That probably makes it less practical to replace anything at the top
> level with a counter array.  The key that we pass back is currently the
> actual source ID, but we don't specify what it is, so we could split it
> and have it encode a 16bit source ID plus 16 bit GSI.  It could also be
> an idr entry.

We can fix those kinds of problems by adding another layer of
indirection.  But I doubt they will be needed.  I don't see people
assigning 60 legacy devices to one guest.

> Michael, would the interface be more acceptable to you if we added
> separate ioctls to allocate and free some representation of an irq
> source ID, gsi pair?  For instance, an ioctl might return an idr entry
> for an irq source ID/gsi object which would then be passed as a
> parameter in struct kvm_irqfd and struct kvm_eoifd so that the object
> representing the source id/gsi isn't magically freed on it's own.  This
> would also allow us to deassign/close one end and reconfigure it later.
> Thanks,

Another option is to push the responsibility for allocating IDs for the
association to userspace.  Let userspace both create the irqfd and the
eoifd with the same ID, the kernel matches them at registration time and
copies the gsi/sourceid from the first to the second eventfd.

-- 
error compiling committee.c: too many arguments to function
