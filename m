Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1AVPPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:15:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43461 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab1AVPPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EhTJgnpHeYuO0hKifReQe/nXArudK0n2cC46OI8nk99CMv/7uucWf21+p2p5qewcK1
         pmn1+RYD3C6jiQADcftrG3CIy1YWgfIQg1TGsJ+qvUqo6x3SDb8CQkLflaQSd471JUr/
         hajcZeBNI/89e/VtKJ5qeU5f0YHY8fpf3sJ2s=
Subject: Re: Problems with /proc/net/tcp6  - possible bug - ipv6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: PK <runningdoglackey@yahoo.com>, David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <1295686781.2609.37.camel@edumazet-laptop>
References: <702550.61465.qm@web63902.mail.re1.yahoo.com>
	 <1295686781.2609.37.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Jan 2011 16:15:44 +0100
Message-ID: <1295709344.2651.55.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 22 janvier 2011 à 09:59 +0100, Eric Dumazet a écrit : 
> Le vendredi 21 janvier 2011 à 22:30 -0800, PK a écrit :
> > Creating many ipv6 connections hits a ceiling on connections/fds ; okay, fine.
> > 
> > But in my case I'm seeing millions of entries spring up within a few seconds and 
> > then vanish within a few minutes, in /proc/net/tcp6 (vanish due to garbage 
> > collection?)
> > 
> > Furthermore I can trigger this easily on vanilla kernels from 2.6.36 to 
> > 2.6.38-rc1-next-20110121  inside a ubuntu 10.10 amd64 vm, causing the kernel to 
> > spew warnings.  There is also some corruption in the logs (see kernel-sample.log 
> > line 296), but that may be unrelated.
> > 
> > More explanation, kernel config of the primary machine I saw this on, sample 
> > ruby script to reproduce (inside the ubuntu VMs I apt-get and use ruby-1.9.1), 
> > are located at
> > https://github.com/runningdogx/net6-bug
> > 
> > Seems to only affect 64-bit.  So far I have not been able to reproduce on 32-bit 
> > ubuntu VMs of any kernel version.
> > Seems to only affect IPv6.  So far I have not been able to reproduce using IPv4 
> > connections (and watching /proc/net/tcp of course).
> > Does not trigger the bug if the connections are made to ::1.  Only externally 
> > routable local and global IPv6 addresses seem to cause problems.
> > Seems to have been introduced between 2.6.35 and 2.6.36 (see README on github 
> > for more kernels I've tried)
> > 
> > All the tested Ubuntu VMs are stock 10.10 userland, with vanilla kernels (the 
> > latest ubuntu kernel is 2.6.35-something, and my initial test didn't show it 
> > suffering from this problem)
> > 
> > Originally noticed on separate Gentoo 64-bit non-vm system when doing web 
> > benchmarking.
> > 
> > not subscribed, so please keep me in cc although I'll try to follow the thread
> > 
> > 


I had some incidents, after hours of testing...

After following patch, I could not reproduce it.

I cant believe this bug was not noticed before today.

Thanks !

[PATCH] tcp: fix bug in listening_get_next()

commit a8b690f98baf9fb19 (tcp: Fix slowness in read /proc/net/tcp)
introduced a bug in handling of SYN_RECV sockets.

st->offset represents number of sockets found since beginning of
listening_hash[st->bucket].

We should not reset st->offset when iterating through
syn_table[st->sbucket], or else if more than ~25 sockets (if
PAGE_SIZE=4096) are in SYN_RECV state, we exit from listening_get_next()
with a too small st->offset

Next time we enter tcp_seek_last_pos(), we are not able to seek past
already found sockets.

Reported-by: PK <runningdoglackey@yahoo.com>
CC: Tom Herbert <therbert@google.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/tcp_ipv4.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 856f684..02f583b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1994,7 +1994,6 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 				}
 				req = req->dl_next;
 			}
-			st->offset = 0;
 			if (++st->sbucket >= icsk->icsk_accept_queue.listen_opt->nr_table_entries)
 				break;
 get_req:


