Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1LVW0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:26:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60232 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1LVW0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:26:18 -0500
MIME-Version: 1.0
In-Reply-To: <4EF3AA74.1060801@redhat.com>
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com>
 <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
 <4EF3AA74.1060801@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 14:25:56 -0800
X-Google-Sender-Auth: nYdZbSg7Lw2hQKauVVtL16eJLL8
Message-ID: <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 2:08 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> I don't know.  But given the ways in which earlier versions broke during
> testing, I wouldn't be able to tell before running many tests.  Which with
> the Christmas break would easily mean a little less than 2 weeks.

I don't think I'm ready to apply this as-is anyway, exactly because
I'd worry about some distribution really depending on being able to
eject disks by partition etc.

I don't *think* anybody does something as crazy as giving actual block
device ownership to people, but I don't know - and I could easily
imagine that even if they don't give the block device to the user, the
suid binary might do "eject /dev/sda1" etc. And one way to do that is
to do the "door unlock" scsi command itself.

So at this point I'd much *much* rather see this as a "we merge it for
3.3 and mark it for stable", so that we can at least get the testing
in the git tree, rather than me taking what could potentially break
peoples setups very late in the -rc series just before a release.

>> That's a completely independent bug that has been discussed several
>> times. We probably should just bite the bullet and fix it. EINVAL is
>> never the right return value (unless the per-ioctl arguments
>> themselves are invalid, not for bad ioctls).
>
> Makes a lot of sense and I was wondering about it myself, but I'm not sure
> stable would accept that.

Again, I think it's something we should do during the merge window
(early at that).

It really has come up several times, it just always comes up at the
wrong moment. If you remind me after the 3.2 release, I'll make sure
to "just do it", and we'll see if anything break.

I doubt anything will, because ENOTTY really is the correct error
return (to user space - for traditional reasons) for "no such ioctl".

Inside the kernel we generally want to use ENOIOCTLCMD, which is much
better named - and thus avoids the confusion that some people have
about the ENOTTY name - and that also has the whole "let's just try
another approach one then".

>> The EINVAL return comes from some people who didn't understand that
>> ENOTTY means "no such ioctl" despite the name.
>
> I did. :)

I suspect most people who have used Unix for a long time kind of take
the "ENOTTY - no such ioctl" thing for granted and don't even think
about it, but we do have a lot of people who write drivers etc and
that started with Linux, and I can understand why they think "ENOTTY"
is an odd name for a SCSI device driver to use.

                Linus
