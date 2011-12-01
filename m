Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1LADRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:17:21 -0500
Received: from ozlabs.org ([203.10.76.45]:34889 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab1LADRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:17:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@redhat.com>
Subject: Re: [PATCH] Add virtio-scsi to the virtio spec
In-Reply-To: <1322661042-28191-1-git-send-email-pbonzini@redhat.com>
References: <1322661042-28191-1-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 01 Dec 2011 13:44:37 +1030
Message-ID: <87sjl5rnj6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 14:50:41 +0100, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Hi all,
> 
> here is the specification for a virtio-based SCSI host (controller, HBA,
> you name it).  The virtio SCSI host is the basis of an alternative
> storage stack for KVM. This stack would overcome several limitations of
> the current solution, virtio-blk:

OK, I like the idea, but I'd prefer to see the spec only cover things
which are implemented and tested, otherwise the risk of a flaw in the
spec is really high in my experience.

Comments below:

>   num_queues is the total number of virtqueues exposed by the
>     device. The driver is free to use only one request queue, or
>     it can use more to achieve better performance.

s/total number of virtqueues/total number of request virtqueues/ ?

>   max_channel, max_target and max_lun can be used by the driver
>     as hints for scanning the logical units on the host. In the
>     current version of the spec, they will always be respectively
>     0, 255 and 16383.

s/hints for scanning/hints to constrain scanning/ ? (I assume).  But why
mention the current values?  That doesn't help someone implementing a
driver or a device.  If you want to, you could mention that as an
implementation detail of your current implmentation, but it seems out of
place in the spec.

> If the driver uses the eventq, it should then place at least a
> buffer in the eventq.

s/at least a/at least one/

> The driver queues requests to an arbitrary request queue, and they are
> used by the device on that same queue. In this version of the spec,
> if a driver uses more than one queue it is the responsibility of the
> driver to ensure strict request ordering; commands placed on different
> queue will be consumed with no order constraints.

Suggest simplification of second sentence:

It is the responsibility of the driver to ensure strict request
ordering; commands placed on different queues will be consumed with no
order constraints.

> The lun field addresses a target and logical unit in the
> virtio-scsi device's SCSI domain. In this version of the spec,
> the only supported format for the LUN field is: first byte set to
> 1, second byte set to target, third and fourth byte representing
> a single level LUN structure, followed by four zero bytes. With
> this representation, a virtio-scsi device can serve up to 256
> targets and 16384 LUNs per target.

You keep saying "In this version of the spec".  I would delete that
phrase everywhere.

> Task_attr, prio and crn should be left to zero: command priority
> is explicitly not supported by this version of the device;
> task_attr defines the task attribute as in the table above, but
> all task attributes may be mapped to SIMPLE by the device; crn
> may also be provided by clients, but is generally expected to be
> 0. The maximum CRN value defined by the protocol is 255, since
> CRN is stored in an 8-bit integer.

Be braver in your language please.  It helps poor implementers who are
already confused by learning SCSI and virtio:

 Task_attr, and prio must be zero.[1] task_attr defines the task
 attribute as in the table above, but all task attributes may be mapped
 to SIMPLE by the device; crn may also be provided by clients, but is
 generally expected to be 0.

 [1] Future extensions may use these fields.

Is it useful for a driver to specify ordered (or other) modes, knowing
it could be reduced to SIMPLE without it being aware?  Or should we use
feature bits to indicate what the device supports?

>   Note that since ACA is not supported by this version of the
>   spec, VIRTIO_SCSI_T_TMF_CLEAR_ACA is always a no-operation.

I think if you don't support ACA in the spec, don't define this.  How
will a driver author use this information?

>     struct virtio_scsi_ctrl_an {
>	 u32 type;
>	 u8  lun[8];
>	 u32 event_requested;
>	 u32 event_actual;
>	 u8  response;
>     }

With all these structures, you might want a comment indicating the
read-only and write-only (from the device POV) parts of the struct, eg:

     struct virtio_scsi_ctrl_an {
         // Read-only part
	 u32 type;
	 u8  lun[8];
	 u32 event_requested;
         // Write-only part
	 u32 event_actual;
	 u8  response;
     }

But basically, though I know nothing about SCSI, I like both the content
and style of this addition!

Thanks,
Rusty.
