Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2KELIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:08:50 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40557 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2KELIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:08:48 -0500
Message-ID: <50979E3C.7030309@redhat.com>
Date: Mon, 05 Nov 2012 12:08:44 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
References: <20121025180045.GL11442@htj.dyndns.org> <1657557410.1945557.1351190120407.JavaMail.root@redhat.com> <20121031212241.GZ2945@htj.dyndns.org> <5093DD5E.6030808@redhat.com> <20121102165123.GB3823@mtj.dyndns.org> <509407B7.3030904@redhat.com> <20121102175350.GB27843@mtj.dyndns.org> <50951A0E.9010103@redhat.com> <20121103145052.0da49071@pyramind.ukuu.org.uk>
In-Reply-To: <20121103145052.0da49071@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/11/2012 15:50, Alan Cox ha scritto:
>>> It's not really about the lines of code.  It adds a new userland
>>> visible interface.  As for the "long" list of commands, it depends on
>>> how you write it but even if it's textually long it's still very
>>> simple in terms of actual complexity.
>>
>> Sure, but its place is not the kernel.
>>
>> As to implementing the ioctl, it's all but trivial.  For one thing, you
>> have to make the block device ioctl op take a "struct file".  I have
>> been asking Al Viro about it for 6 months and I haven't got any answer yet.
> 
> Just do it - if Al cared he'd have replied about it.

Yeah, so far I chickened out because---for the usecases I know, at
least---a sysfs knob would be simpler to use.

>> I proposed a way to implement the ultimately flexible solution (BPF) and
>> you shot it down because it was too complex.  Alan is showing you with
>> multiple examples of why the flexibility would be useful (perhaps nobody
>> would use it, but the use cases _are_ there), and you are mostly
>> ignoring them.
> 
> My feeling too - It feels to me like Tejun is trying to railroad a broken
> non-solution into the system

Thanks for spelling it out. :)

> without regards for anyone else and by
> simply dismissing any other input.

My main worry about the BPF implementation is that I need to do CDB
inspection, which is similar to packet inspection but doesn't have an
sk_buff.  The seccomp guys worked around it by using an ANC opcode to
access syscall arguments, but here I really need LD.  This means for
example that it wouldn't be so easy to use the JIT.

These are the usecases that really require BPF:

> - giving people access to parts of disks

This is quite obvious, but I'm not sure why you would that (other than
just because).  It feels a bit strange to give access to part of a disk
with "absolute" LBAs rather than relative.

For people needing access to partitions of LVs, what we really need is
better access to block device features.  We just got BLKZEROOUT, but
access to block devices via fallocate() or lseek(SEEK_HOLE/SEEK_DATA)
would be a more interesting and useful thing to do.

> - giving end users minimal access to things like SMART but only on drives
>   where it is safe

I'm actually in agreement with Tejun that this is handled more than
decently by udisks.  And the reason this needs BPF, is because the ATA
command set is incredibly complicated.  If there were request, SMART
access could be moved to the kernel/libata and use sysfs+uevents.  This
is similar to how media change is in the kernel, and SCSI disks allow
limited access to mode pages via sysfs.

These uses instead are fine with a bitmap:

> - giving a user a SCSI disk or partition to play with but preventing them
>   issuing weird ass commands that can disrupt other devices in the fabric
>   (like drive to drive transfers, some kinds of resets, management
>   commands)
> - allowing access to specific vendor specific commands on certain
>   non-standard CD and DVD drives so they can be used for burning but you
>   can't trash them
> - minimising the ability of a VM to do damage if compromised while
>   maximising its raw access to a device

(I'm obviously trying to champion my own patches, but I'll try to be
open minded about it). :)

Paolo
