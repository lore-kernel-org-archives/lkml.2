Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1LWAIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 19:08:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41660 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1LWAII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 19:08:08 -0500
MIME-Version: 1.0
In-Reply-To: <20111222234830.GC31021@agk-dp.fab.redhat.com>
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com>
 <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
 <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
 <20111222234830.GC31021@agk-dp.fab.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 16:07:46 -0800
X-Google-Sender-Auth: -Nmdxl9SGYJ8Ai9UsscGUsivM_0
Message-ID: <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 3:48 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Thu, Dec 22, 2011 at 02:25:56PM -0800, Linus Torvalds wrote:
>> I don't *think* anybody does something as crazy as giving actual block
>> device ownership to people,
>
> That can happen when running virtual machines backed by logical volumes.

So my worry is not so much the security fix for the vm case, but
simply normal people - who don't hit the issue to begin with - now
being screwed because what their distro does no longer works.

For example, I just traced it, and "eject /dev/sdb1" does a CDROMEJECT
ioctl when used as the root user. I haven't tested the patch, but just
reading it, I'd expect it to break that.

And that's the *natural* way to eject a mounted device. Look at the
USB memory sticks you have. They are almost all partitioned to have
one partition, and that one partition doesn't cover the whole device.
And it's that one partition you use to interact with it - it's what
you mount, and what you eject.

Breaking things like that is not an option. It's stuff people do every
day. And there may be some very non-obvious reason that I don't see
why it's not broken by this patch-series, but that's the kind of thing
that I worry about.

And I worry about it a *lot* more than I worry about some broken
virtualization setup where you have system engineers that could patch
their own kernel if they feel strongly about this. We simply
*must*not* break things.

I absolutely do not get the feeling that this has been tested so much
and is so obvious that there is no risk of breakage.

I suspect one thing that would be reasonable would be to just say
"Root can do any ioctl's he damn well wants on a partial device". That
would make me worry much less about the "normal" setup breaking where
you don't give regular users direct access to partitions to begin
with.

But even that might not work reliably. Maybe the system deamon that
actually does the eject (when a normal user does an eject) has been
setguid to 'disk' instead, and isn't root. I don't know. I doubt you
know either.  Maybe some of them have fallback code to find the parent
device. Do you know? Do you know that all do? I doubt it.

                          Linus
