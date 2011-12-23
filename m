Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab1LWOyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:54:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab1LWOyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:54:00 -0500
Message-ID: <4EF48CE4.3000104@redhat.com>
Date: Fri, 23 Dec 2011 15:15:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com> <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com> <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
In-Reply-To: <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 10:22 AM, Linus Torvalds wrote:
> On Thu, Dec 22, 2011 at 10:26 PM, Willy Tarreau<w@1wt.eu>  wrote:
>>
>> Call me dumb, but why would someone use "eject" on a non-physically
>> ejectable device such as a memory stick ?
>
> Perhaps because that's the operation that works everywhere and is the
> simplest one?

But does it actually do anything?  For me, "eject /dev/sdf1" does 
nothing beyond unmounting the disk.  Yes, it sends a CDROMEJECT ioctl 
which becomes a start/stop unit SCSI command, but it has no effect on 
the USB stick I tried.

I tried it on a card reader, and indeed it started reporting "no medium 
found" after ejecting.

And actually there it fixes a potential data corruption.  Because yes, 
most USB sticks and cards have one partition.  But if you had two, 
"eject /dev/sdf1" would unmount one partition and CDROMEJECT the whole 
card.  Which means the other partition is left unclean.  (Invoked with 
"eject /dev/sdb", eject at least tries to go through the partitions and 
unmounts all of them.  Not bulletproof, but almost there).

So "eject /dev/sdb1" on USB sticks is just an unmount.  On card readers 
it will indeed be affected by the patch.  But the actual eject operation 
that it does after unmounting ought to fail.  It hasn't so far?  Just 
another instance of the bug I'm fixing.

> Just look at the icon on your desktop - it probably has "Eject" above
> the silly "Safely remove drive" when you right-click it. It has for
> me.

Assuming you're using GNOME3, for USB sticks the "Eject" button unmounts 
the volume, but it leaves the /dev/ files in place.  "Safely remove 
drive" unmounts the volume and also does what udisks calls "detach".  It 
sends a start/stop unit SCSI command (same as CDROMEJECT and the eject 
command) and then unplugs the device via sysfs.  To be precise, it also 
sends a cache flush, just in case the disk reported itself as 
writethrough but wasn't, so it is actually safer than eject.

But udisks never sends SCSI commands to partition devices, because 
udisks knows the distinction between disk and partition.  Even on an 
unpatched kernel, "udisks --detach /dev/sdf1" fails with "Detach failed: 
Device is not a drive".  In general, I looked at the source code for 
this throughout the GNOME stack (both GNOME2 and GNOME3), and everywhere 
they distinguish between "drive" and "volume" objects.  Eject maps to a 
method on the volume's eject method, while "safely remove drive" maps to 
the drive's stop method.

So, no, nothing I tried to do on USB sticks from a recent desktop 
environment will break with the patch.

Before udisks, HAL had "unmount" and "eject".  With or without the 
patch, on USB sticks they act the same.  They unmount the volume and 
leave /dev/ files in place.

> So yes, I claim that "eject" is actually the *natural* thing to do
> before you physically remove the medium, because it works across
> different media.

If you talk about ejecting the disk, yeah, "safely remove drive" is just 
paranoia.  But if you talk about ejecting a partition from the 
command-line, then no, not at all.

Paolo
