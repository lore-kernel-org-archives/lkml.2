Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1BCHxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 02:53:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62748 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1BCHxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 02:53:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y/lygsMrBkXIL8V8WXIIVFJsjSZWruewtJ8Se3hvqyLHyx/EfR6NnTYSqnyIm1x6mL
         JCLv6TGcjjrBkD4sFoPLzNRWFg+4S39eUb/2HjOZALA3rh1EwPyc3ZSDpVyWguEzPfRe
         ouNJihJUdDeFCMGwjq6QHTBCd7zQZs226QYB8=
Subject: Re: epoll broken [was: mmotm 2011-01-25-15-47 uploaded]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, ML netdev <netdev@vger.kernel.org>,
        davidel@xmailserver.org
In-Reply-To: <4D4A5BBF.20806@gmail.com>
References: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org>
	 <4D4A5BBF.20806@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 08:53:21 +0100
Message-ID: <1296719601.3438.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 février 2011 à 08:39 +0100, Jiri Slaby a écrit :
> On 01/26/2011 12:48 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2011-01-25-15-47 has been uploaded to
> 
> Hi, the network daemons are broken here. cupsd and httpd children
> segfault too often without servicing requests. It's a regression against
> mmotm 2011-01-06-15-41.
> 
> It's epoll after it dies:
> 17836 epoll_create(8192)                = 3
> ...
> 17836 accept(7, {sa_family=AF_FILE, NULL}, [2]) = 11
> 17836 getsockname(11, {sa_family=AF_FILE,
> path="/var/run/cups/cups.sock"}, [26]) = 0
> 17836 setsockopt(11, SOL_TCP, TCP_NODELAY, [1], 4) = -1 EOPNOTSUPP
> (Operation not supported)
> 17836 fcntl(11, F_GETFD)                = 0
> 17836 fcntl(11, F_SETFD, FD_CLOEXEC)    = 0
> 17836 epoll_ctl(3, EPOLL_CTL_ADD, 11, {EPOLLIN, {u32=379708832,
> u64=140428630418848}}) = 0
> 17836 epoll_wait(3, {{EPOLLIN, {u32=379708832, u64=140428630418848}}},
> 8192, 1000) = 1
> 17836 recvfrom(11, "P", 1, MSG_PEEK, NULL, NULL) = 1
> 17836 poll([{fd=11, events=POLLIN}], 1, 10000) = 1 ([{fd=11,
> revents=POLLIN}])
> 17836 recvfrom(11, "POST / HTTP/1.1\r\nContent-Length:"..., 2048, 0,
> NULL, NULL) = 771
> 17836 sendto(11, "HTTP/1.1 100 Continue\r\n\r\n", 25, 0, NULL, 0) = 25
> 17836 epoll_wait(3, {{EPOLLIN, {u32=379708832, u64=140428630418848}},
> {0, {u32=0, u64=0}} .............. {0, {u32=0, u64=0}}, ?}
> 0x7fb816996660, 8192, 0) = 379151968
> 17836 --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> 17836 +++ killed by SIGSEGV +++
> 
> The parameter, the same as the retval, seems to be bogus.
> 
> Is it known (fixed in newer kernels)?
> 
> thanks,

Yes, its known, and a fix is there : https://lkml.org/lkml/2011/1/26/121


