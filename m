Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1BCHju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 02:39:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1BCHjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 02:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YSRKUYTDlOmVtWK0TSMKLRh3DnwHht07lQqlYyRbPKqiJvSYxyfnO0To7CydaxkXMM
         5RfKg0dhZJ7qCMUA8XUAJWvCq/lgJ4pHMa8NyhXbwDigC7nNFX8DdefeUDwbjAP029vs
         x6hR2Wr1AbDYmdd/UIIOB6G9DM10W1y5iRHvI=
Message-ID: <4D4A5BBF.20806@gmail.com>
Date: Thu, 03 Feb 2011 08:39:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        ML netdev <netdev@vger.kernel.org>, davidel@xmailserver.org
Subject: epoll broken [was: mmotm 2011-01-25-15-47 uploaded]
References: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org>
In-Reply-To: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 12:48 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2011-01-25-15-47 has been uploaded to

Hi, the network daemons are broken here. cupsd and httpd children
segfault too often without servicing requests. It's a regression against
mmotm 2011-01-06-15-41.

It's epoll after it dies:
17836 epoll_create(8192)                = 3
...
17836 accept(7, {sa_family=AF_FILE, NULL}, [2]) = 11
17836 getsockname(11, {sa_family=AF_FILE,
path="/var/run/cups/cups.sock"}, [26]) = 0
17836 setsockopt(11, SOL_TCP, TCP_NODELAY, [1], 4) = -1 EOPNOTSUPP
(Operation not supported)
17836 fcntl(11, F_GETFD)                = 0
17836 fcntl(11, F_SETFD, FD_CLOEXEC)    = 0
17836 epoll_ctl(3, EPOLL_CTL_ADD, 11, {EPOLLIN, {u32=379708832,
u64=140428630418848}}) = 0
17836 epoll_wait(3, {{EPOLLIN, {u32=379708832, u64=140428630418848}}},
8192, 1000) = 1
17836 recvfrom(11, "P", 1, MSG_PEEK, NULL, NULL) = 1
17836 poll([{fd=11, events=POLLIN}], 1, 10000) = 1 ([{fd=11,
revents=POLLIN}])
17836 recvfrom(11, "POST / HTTP/1.1\r\nContent-Length:"..., 2048, 0,
NULL, NULL) = 771
17836 sendto(11, "HTTP/1.1 100 Continue\r\n\r\n", 25, 0, NULL, 0) = 25
17836 epoll_wait(3, {{EPOLLIN, {u32=379708832, u64=140428630418848}},
{0, {u32=0, u64=0}} .............. {0, {u32=0, u64=0}}, ?}
0x7fb816996660, 8192, 0) = 379151968
17836 --- SIGSEGV (Segmentation fault) @ 0 (0) ---
17836 +++ killed by SIGSEGV +++

The parameter, the same as the retval, seems to be bogus.

Is it known (fixed in newer kernels)?

thanks,
-- 
js
