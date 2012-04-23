Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2DWRIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:08:09 -0400
Received: from haggis.mythic-beasts.com ([93.93.131.52]:55678 "EHLO
	haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2DWRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:08:07 -0400
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2012 13:08:07 EDT
Subject: Fixing NFS over OpenVPN
From: Toby Goodwin <toby@mythic-beasts.com>
To: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 17:57:28 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335200249.5607.41.camel@rocinante.mythic-beasts.com>
Mime-Version: 1.0
X-BlackCat-Spam-Score: -10
X-Mythic-Debug: Threshold =  On = 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFS over OpenVPN is unreliable. On systems with modest RAM, it quite
quickly locks up in a nasty way, with unkillable processes, and the
system unable even to shutdown or reboot. Ouch.

I've been looking at this for some time, and have finally made some
progress. The problem is that if the openvpn process needs any more
kernel memory, the kernel will sometimes ask nfs to release some pages,
nfs calls commit_inode(), which wants to write to the openvpn tunnel,
and we have deadlock.

I believe I know how to fix this, but would appreciate some guidance.
Part of the solution is to specify the "--mlock" flag to openvpn -- this
exists so that secrets are never written to swap, but as a side effect
it prevents openvpn from ever page faulting.

The other kernel allocation culprits are the sockets that openvpn holds.
To prevent them triggering the deadlock, we need to set sk_allocation =
GFP_NOIO. For the socket created by the tun driver it's a simple change
to drivers/net/tun.c. (This is the socket that applications use when
they want to communicate with the tunnel.)

The other socket created by openvpn is trickier, as it's just a normal
userland AF_INET socket. (This is the socket through which OpenVPN sends
its encrypted packets to the remote end of the tunnel.) I haven't
discovered any way for userland to request a particular allocation
policy for a socket, please let me know if I've missed something.

So I've added a setsockopt() call that can do it:

--- net/core/sock.c.orig	2012-03-18 23:15:34.000000000 +0000
+++ net/core/sock.c	2012-04-22 22:55:34.320023377 +0100
@@ -793,6 +793,10 @@
 		sock_valbool_flag(sk, SOCK_WIFI_STATUS, valbool);
 		break;
 
+	case SO_RECURSIVE:
+		sk->sk_allocation = GFP_NOIO;
+		break;
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;

(I picked the SO_RECURSIVE name late at night -- suggestions for a
better name are very welcome!)

I've dealt with these three troublesome memory allocations as I've
discovered them, and initial testing shows that I can now keep nfs over
openvpn going, even on a system with limited memory that is also
thrashing with a large compile.

But this seems like a fragile process: I don't know if there are other
troublespots lurking. Really I'd like openvpn to say to the kernel
"whenever you allocate memory for me, use GFP_NOIO", but I haven't
discovered a way to do this: none of the process flags quite seem to fit
the bill. (I did consider PF_KSWAPD, but thought better of it. :-)

Is there a better way to solve this?

Thanks,

Toby.


