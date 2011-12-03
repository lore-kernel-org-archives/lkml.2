Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1LCCYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 21:24:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46865 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab1LCCYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 21:24:00 -0500
MIME-Version: 1.0
Date: Fri, 2 Dec 2011 18:23:58 -0800
Message-ID: <CA+XNFZNKmH5a1fTvGonG=Z5KaN66gEKCzgeDO-EFKz1VgTxD_w@mail.gmail.com>
Subject: sendmsg/recvmsg ambiguities
From: Ben Longbons <brlongbons@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry to bother you guys with this wall of text, but I've searched and
asked for help in other places and nobody else seems to know anything.

I'm programming in userspace, but dealing with some poorly documented
system calls, so I hope this isn't inappropriate.

There's not a lot of documentation about passing an arbitrary number
of file descriptors over a stream-based Unix socket, at any time. Most
example code out there assumes that you're only passing one or a small
constant number, and/or not passing any normal data with it.

What I need to do is pass normal data and file descriptors both ways
across the socket, without getting MSG_CTRUNC (which is essentially
unrecoverable, since there's no way of knowing *how much* was lost -
otherwise I could resend).

I've discovered empirically that all the ancillary data is associated
with a single byte in the stream; if you read that byte into your
buffer, then you get all the ancillary data. Even if your buffers are
large enough, it will stop reading before a subsequent "heavy" byte;
conversely, it will set MSG_CTRUNC rather than return the data with
subsequent "light" bytes. If you pass multiple struct cmsgs to
sendmsg, all the file descriptors get aggregated into one for recvmsg.

I thought about implementing a loop with MSG_PEEK, but the behavior is
undefined and might change? (Search in net/unix/af_unix.c for "It is
questionable: on PEEK we could") but in any case it would be wasteful
for the common case of having a big enough buffer.

How much of the preceding is "fixed" and how much is subject to
change? This really needs to be documented.

It would be nice if there were an ioctl analogous to FIONREAD, but for
ancillary data instead of normal data. Speaking of which - FIONREAD
returns the total amount of data bytes available, which is pretty
useless for allocating a buffer because you won't actually get that
many bytes in the case where there are multiple pieces of ancillary
data.

Are there any other kinds of ancillary data that may spontaneously add
themselves in the future (besides the 2 mentioned in unix(7) ),
leading to a possible MSG_CTRUNC or some kind of resource limit?
Obviously, ignoring SCM_RIGHTS will lead to a shortage of file
descriptors ... I've read about setting SO_PASSCRED (which I don't
need) to get SCM_CREDENTIALS, which seems pointless as it's safe to
ignore while looping over the cmsg structures.

If a hostile or buggy process connects and intentionally passes a
larger buffer and I get MSG_CTRUNC, I can just kill their connection
(and be careful to close any file descriptors in the truncated
message, etc).

I'm also being paranoid about whether the amount of data available can
change (for FIONREAD or MSG_PEEK). I can deal with spurious
notifications from ppoll(2) - I'm looping until EAGAIN/EWOULDBLOCK,
which is needed anyway to handle the case of *more* data arriving, or
working without FIONREAD. Common sense says that a file descriptor
won't suddenly have less data available, but common sense is wrong -
it's quite possible that someone else has a dup, i.e. because
depending on the interpretation of the data bytes, I may start
listening to the file descriptor I get passed.

Is it safe to close the passed file descriptor as soon sendmsg returns
successfully? That would imply that there's a brief period of time
when no userland process holds an open file descriptor referring to
the underlying file description.

cmsg(3) says that msg_controllen should be set to the sum of the
CMSG_SPACE of each struct cmsg (presumably this means the size before
being passed to CMSG_LEN). But the code below it initializes it to
cmsg->cmsg_len, which was initialized via CMSG_LEN. If I've chosen my
buffer size carefully via CMSG_SPACE in the first place, I shouldn't
have to change it a second time, right?

I'm aware that it would be too much trouble to change the API, but
wouldn't it be perfectly valid to have CMSG_LEN be a noop, since the
only thing it's supposed to be used for is initializing
cmsg->cmsg_len, everything else should use CMSG_SPACE? And this would
make the above mistake more easily caught.

It would be *very* useful if that header provided an inverse function
to CMSG_LEN (for the above reason) and CMSG_SPACE (so, given the
maximum buffer size (/proc/sys/net/core/optmem_max), you can figure
out how much you can actually use (i.e., how many fds you can pass in
a single call), after the overhead of struct cmsg).

Is there a sane minimum for optmem_max? RFC 2292 demands 10240 but
mentions many BSD-derived systems having 108 (I don't want to rule out
running my program on other unices) ... the main server has exactly
10240 and my home systems have double that.

It's also not clear whether optmem_max falls under the statement from
socket(7): "thus the values in the corresponding /proc files are twice
what can be observed on the wire"

Also - for the case of a non-unix socket, or when I don't have any
ancillary data: is writev any more efficient than sendmsg? Also, is
sendmsg (with no ancillary data) even valid for non-sockets?

I'm not subscribed to the list, so please CC me.

Thanks,
-Ben Longbons (aka o11c in some circles)
