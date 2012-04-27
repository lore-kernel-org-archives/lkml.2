Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab2D0UNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:13:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59048 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2D0UNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:13:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
	<20120427.151651.2274764174217164454.davem@davemloft.net>
	<CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
	<20120427.152404.2292425516870981391.davem@davemloft.net>
	<CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
Date: Fri, 27 Apr 2012 22:13:39 +0200
Message-ID: <CANXojcy2CinBrBY2+ZRoD_4PzZDj5dELsaa57_byQpwmmHpk+g@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: Stef Bon <stefbon@gmail.com>
To: autofs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not have any solution to the issue discussed here, but mentioned
is that automount and systemd are the only packages using autofs. I'm
thinking about creating a FUSE filesystem which will make use of
autofs (direct) mounting, where the FUSE fs will do something what now
automount does.  Indirect mounts are not necessary anymore, the
browsable maps will be created in the FUSE fs.

Stef Bon

2012/4/27 Linus Torvalds <torvalds@linux-foundation.org>:
> On Fri, Apr 27, 2012 at 12:24 PM, David Miller <davem@davemloft.net> wrote:
>>
>> If you can pull that off, it would certainly work and be the best
>> solution.
>>
>> BTW, this has happened before, we had this same problem passing data
>> over netlink sockets.  And since it's packetized already we had a
>> slightly easier time dealing with it.
>
> Ok, so here's a fairly quick hack.
>
> NOTE! I haven't actually tested this, because I don't use autofs
> (well, not knowingly - maybe I have a machine that actually does).
>
> What it does is add a new "packetized" flag to pipes, which does two
> simple things:
>  - do not merge write data in pipe buffers when writing
>  - when reading, consider a pipe buffer to be "spent" when any of the
> data has been read
>
> Of course, if you write more than PIPE_BUFFER bytes, the packetization
> doesn't work, but hey, if you do that, it's your own damn problem.
>
> Then, this just makes (for debugging!) autofs always write eight extra
> bytes of garbage (NOTE NOTE NOTE! This will write uninitialized data,
> so this is literally just for debugging this particular issue), so
> that if the whole "kernel writes a few bytes extra" approach with pipe
> packetization doesn't work, you would see it even on native 32-bit or
> 64-bit mode, without having to even test the special case of "32-bit
> automount binary on a 64-bit kernel". So *anybody* who uses autofs can
> test this patch and see if autofs still works for them despite the
> extra padding on the write.
>
> So note the "+8" in autofs_v5_packet_size(). It's there on purpose,
> but it needs to be removed for actual final results if this works for
> testing.
>
> Comments? The patch looks fairly simple. The "packetized pipe" might
> even be useful for other users and maybe we might want to expose it as
> an actual pipe fcntl, but right now the only thing that sets that flag
> is autofs.
>
> Does this even work? I might well have missed some obvious thing, this
> was put together pretty quickly, but I think the *concept* may be the
> right approach to this whole mess.
>
> (And yes, we could probably just pack the "struct pipe_inode_info"
> better. We don't really need 32 bits for the pipe writer count etc.
> But to make the patch simple, I just added a whole new bitfield, which
> will just grow that silly structure).
>
>                       Linus
