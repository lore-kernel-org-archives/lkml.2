Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2HURSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:18:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45950 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab2HURSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:18:02 -0400
MIME-Version: 1.0
In-Reply-To: <5033B199.6080305@parallels.com>
References: <20120809124436.5156.26944.stgit@localhost.localdomain>
	<20120809.161639.1789560369123168415.davem@davemloft.net>
	<5033B199.6080305@parallels.com>
Date: Tue, 21 Aug 2012 13:18:01 -0400
Message-ID: <CADVnQy=HGxFiczXGxb4iMumKUAXt77UzTWFqFwGzpLoQjvUR7Q@mail.gmail.com>
Subject: Re: [PATCH] tun: don't zeroize sock->file on detach
From: Neal Cardwell <ncardwell@google.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: David Miller <davem@davemloft.net>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rick.jones2@hp.com" <rick.jones2@hp.com>,
        "ycheng@google.com" <ycheng@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mikulas@artax.karlin.mff.cuni.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 12:04 PM, Stanislav Kinsbursky
<skinsbursky@parallels.com> wrote:
> 10.08.2012 03:16, David Miller пишет:
>
>> From: Stanislav Kinsbursky <skinsbursky@parallels.com>
>> Date: Thu, 09 Aug 2012 16:50:40 +0400
>>
>>> This is a fix for bug, introduced in 3.4 kernel by commit
>>> 1ab5ecb90cb6a3df1476e052f76a6e8f6511cb3d, which, among other things,
>>> replaced
>>> simple sock_put() by sk_release_kernel(). Below is sequence, which leads
>>> to
>>> oops for non-persistent devices:
>>>
>>> tun_chr_close()
>>> tun_detach()                            <== tun->socket.file = NULL
>>> tun_free_netdev()
>>> sk_release_sock()
>>> sock_release(sock->file == NULL)
>>> iput(SOCK_INODE(sock))                  <== dereference on NULL pointer
>>>
>>> This patch just removes zeroing of socket's file from __tun_detach().
>>> sock_release() will do this.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Ruan Zhijie <ruanzhijie@hotmail.com>
>>> Tested-by: Ruan Zhijie <ruanzhijie@hotmail.com>
>>> Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
>>> Acked-by: Eric Dumazet <edumazet@google.com>
>>> Acked-by: Yuchung Cheng <ycheng@google.com>
>>> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
>>
>>
>> Applied, thanks.
>>
>
> Hi, David.
> I found out, that this commit: b09e786bd1dd66418b69348cb110f3a64764626a
> was previous attempt to fix the problem.
> I believe this commit have to be dropped.

Have you tried testing with that commit reverted? AFAICT from reading
the code, if you revert b09e786bd1dd66418b69348cb110f3a64764626a then
the sockets_in_use count becomes incorrect, because sock_release()
will be calling this_cpu_sub() for each tun socket teardown when there
was no corresponding this_cpu_add() for the tun socket (because the
tun socket is not allocated with sock_alloc()).

Can you sketch in more detail why that commit should be dropped?

neal
