Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2IMAWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:22:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab2ILXfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:35:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 084/108] Fix order of arguments to compat_put_time[spec|val]
Date: Wed, 12 Sep 2012 16:29:22 -0700
Message-Id: <20120912232459.310121042@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit ed6fe9d614fc1bca95eb8c0ccd0e92db00ef9d5d upstream.

Commit 644595f89620 ("compat: Handle COMPAT_USE_64BIT_TIME in
net/socket.c") introduced a bug where the helper functions to take
either a 64-bit or compat time[spec|val] got the arguments in the wrong
order, passing the kernel stack pointer off as a user pointer (and vice
versa).

Because of the user address range check, that in turn then causes an
EFAULT due to the user pointer range checking failing for the kernel
address.  Incorrectly resuling in a failed system call for 32-bit
processes with a 64-bit kernel.

On odder architectures like HP-PA (with separate user/kernel address
spaces), it can be used read kernel memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -2605,7 +2605,7 @@ static int do_siocgstamp(struct net *net
 	err = sock_do_ioctl(net, sock, cmd, (unsigned long)&ktv);
 	set_fs(old_fs);
 	if (!err)
-		err = compat_put_timeval(up, &ktv);
+		err = compat_put_timeval(&ktv, up);
 
 	return err;
 }
@@ -2621,7 +2621,7 @@ static int do_siocgstampns(struct net *n
 	err = sock_do_ioctl(net, sock, cmd, (unsigned long)&kts);
 	set_fs(old_fs);
 	if (!err)
-		err = compat_put_timespec(up, &kts);
+		err = compat_put_timespec(&kts, up);
 
 	return err;
 }


