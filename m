Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0IXRfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:35:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:39587 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0IXRfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:35:21 -0400
Date: Fri, 24 Sep 2010 18:22:57 +0100
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Alban Crequy <alban.crequy@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Ian Molton <ian.molton@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbus@freedesktop.org
Subject: [PATCH 0/5] RFC: Multicast and filtering features on AF_UNIX
Message-ID: <20100924182257.11abd9a6@chocolatine.cbg.collabora.co.uk>
Organization: Collabora
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on improving the performances of D-Bus [1]. dbus-daemon is
connected to the peers with Unix sockets and delivers D-Bus messages
according to match rules set by the peers themselves. Every D-Bus
message goes through dbus-daemon. The number of recipients if often 1
but it can be 0, 1, or more. With this architecture, dbus-daemon has to
wake up for every message on the bus and the context switches are
expensive.

/--------\ unix socket  /-------------\ unix socket  /-----------\
| sender |------------->| dbus-daemon |------------->| recipient |
\--------/  AF_UNIX     \-------------/  AF_UNIX     \-----------/

Ian and I wrote a kernel module "dbus" to improve the performances (the
sources are not attached to this email but available there: [2]). This
is a proof-of-concept. It implements a new address family AF_DBUS,
similar to AF_UNIX, but the kernel is smart enough to deliver the
messages directly to the correct recipients, bypassing dbus-daemon. The
only change in userspace is to use AF_DBUS instead of AF_UNIX. I
compared the performances here [2]. It is about 5000 lines of code (a
big part is duplicated from net/unix/af_unix.c).

Another possibility is to add the needed features directly in AF_UNIX
sockets (and avoid to create a new address family for D-Bus):

- multicast
- some kind of BSD socket filters?
- untables?

And hopefully the new features would be useful for other userspace
applications in addition to D-Bus. Wireshark could read and display
AF_UNIX packets.

I am looking for feedback on what is the best way to do this.

The following patches implements multicast on stream Unix socket.
Applications have to enable multicast on the socket with setsockopt()
and then every packets will be delivered to all sockets connected to
the multicast address. The patches are also available on [3].

[1] http://www.freedesktop.org/wiki/Software/dbus
[2] http://alban.apinc.org/blog/2010/09/15/d-bus-in-the-kernel-faster/
[3]
http://git.collabora.co.uk/?p=user/alban/linux-2.6.35.y/.git;a=shortlog;h=refs/heads/unix-multicast

-- 
Alban Crequy

