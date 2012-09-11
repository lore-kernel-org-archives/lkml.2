Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab2IKTYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:24:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63869 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2IKTYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:24:38 -0400
Message-ID: <504F8FF0.3000408@redhat.com>
Date: Tue, 11 Sep 2012 21:24:32 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com> <20120911182904.GS7677@google.com> <504F88CB.6030105@redhat.com> <20120911191325.GU7677@google.com>
In-Reply-To: <20120911191325.GU7677@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2012 21:13, Tejun Heo ha scritto:
> Hello, Paolo.
> 
> On Tue, Sep 11, 2012 at 08:54:03PM +0200, Paolo Bonzini wrote:
>>> On Tue, Sep 11, 2012 at 07:56:53PM +0200, Paolo Bonzini wrote:
>>>> Understood; unfortunately, there is another major user of it
>>>> (virtualization).  If you are passing "raw" LUNs down to a virtual
>>>> machine, there's no possibility at all to use a properly encapsulated
>>>
>>> Is there still command filtering issue when you're passing "raw" LUNs
>>> down?
>>
>> Yes, the passing down is just a userland program that gets SCSI
>> commands from the guest, sends them via SG_IO, and passes back the
>> result.  If the userland program is unprivileged (it usually is), then
>> you go through the filter.
> 
> Could being able to bypass the filters for this "you own this LUN" be
> a solution?  Or is it that we still need command filtering for
> whatever reason?

Yes, it could be.  Enabling/disabling the filters from a privileged
program and passing the unfiltered fd via SCM_RIGHTS would be enough.

>> This is the userland for virtio-scsi (the kernel part of virtio-scsi is just
>> a driver running in the guest).  It can run in two mode: it can do its own
>> SCSI emulation, or it can just relay CDBs and their results.
>>
>> It can (and does) use higher-level services if SCSI emulation is done in
>> userland.  In that case, trim/discard can become a BLKDISCARD or a fallocate
>> for example.  However, in this case userland doesn't do any emulation and in
>> fact doesn't even need to know that this CDB is a discard.
> 
> Couldn't it intercept some of them - e.g. RWs and discards?
> What's the benifit / use case of doing pure bypass?

Basically, using the same storage technology for bare metal and
virtualized systems.  IMHO losing sense data is a no-no, but the above
solution could be feasible too.

> Would the benefits be strong enough to justify whole bpf cdb filtering?

If we can get a simpler solution that is okay with kernel maintainers,
I'm all for it.

>>> Hmmm?  This was about discard, no?
>>
>> One example of block layer interfaces that I want to add is BLKPING, so
>> that you can see if the NAS is reachable.  Then SCSI emulation can map
>> the "test unit ready" command to BLKPING.  There's a handful of such
>> ioctls that would be useful, such as BLKDISCARD itself.
> 
> Can't you make use of the existing disk events mechanism for that?
> Block layer already knows how to watch readiness of a device and tell
> the userland about it via uevent.

How?  But anyway i don't want to divert the discussion from the actual
topic...

Paolo
