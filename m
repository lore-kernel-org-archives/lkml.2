Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3ABJpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:45:39 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:46745 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab3ABJpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:45:38 -0500
Date: Wed, 2 Jan 2013 11:45:29 +0200 (EET)
From: Tero Roponen <tero.roponen@gmail.com>
X-X-Sender: terrop@terrop.lan
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: linux-kernel@vger.kernel.org, Daniel Phillips <lkml@phunq.net>
Subject: Re: Tux3 report: New news for the new year
In-Reply-To: <201301011537.08466.Martin@lichtvoll.de>
Message-ID: <alpine.LFD.2.03.1301021144280.10305@gmail.com>
References: <2597526.usDRg4h3X1@mars> <201301011406.19983.Martin@lichtvoll.de> <1492866.3ugQ2fqrP0@mars> (sfid-20130101_150635_182498_1B81CD52) <201301011537.08466.Martin@lichtvoll.de>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795455-1613803893-1357119934=:10305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795455-1613803893-1357119934=:10305
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT


On Tue, 1 Jan 2013, Martin Steigerwald wrote:

> martin@merkaba:~[…]> sudo ./tux3fuse tux3.img /mnt/zeit
> [sudo] password for martin: 
> 
> martin@merkaba:~[…]> mount | grep fuse
> fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
> tux3.img on /mnt/zeit type fuse.tux3.img (rw,nosuid,nodev,relatime,user_id=0,group_id=0)
> 
> 
> 
> But I am stuck with accessing it:
> 
> martin@merkaba:~[…]> LANG=C ls -l /mnt/zeit            
> ls: cannot access /mnt/zeit: Permission denied
> 
> martin@merkaba:~[…]> LANG=C sudo chown martin:martin /mnt/zeit
> chown: cannot access '/mnt/zeit': Transport endpoint is not connected
> martin@merkaba:~[…]> LANG=C sudo ls -l /mnt/zeit
> ls: cannot access /mnt/zeit: Transport endpoint is not connected
> martin@merkaba:~[…]>

Hi,

I have not looked at Tux3 for a long time, but there seems to be
a simple fix for at least this problem, and two workarounds:

1) Run the program in foreground (-f):

   sudo ./tux3fuse tux3.img /mnt/zeit -f

2) Use absolute path for image file:

   sudo ./tux3fuse $(pwd)/tux3.img /mnt/zeit

The following patch should hopefully fix this for good.

commit efc0cf49f6dd00dfbb84e88336d2c5d147a09ed0
Author: Tero Roponen <tero.roponen@gmail.com>
Date:   Wed Jan 2 11:20:46 2013 +0200

    Use absolute path for volume name
    
    If fuse_daemonize() puts us into background it also switches our
    working directory to '/', breaking the use of relative paths.
    
    This patch fixes the problem by converting the relative path to
    an absolute one.
    
    Signed-off-by: Tero Roponen <tero.roponen@gmail.com>

diff --git a/user/tux3fuse.c b/user/tux3fuse.c
index 6401204..5047cab 100644
--- a/user/tux3fuse.c
+++ b/user/tux3fuse.c
@@ -993,7 +993,7 @@ int main(int argc, char *argv[])
 		goto error;
 
 	struct tux3fuse tux3fuse = {
-		.volname = argv[1],
+		.volname = canonicalize_file_name(argv[1]),
 	};
 	fs = fuse_lowlevel_new(&args, &tux3_ops, sizeof(tux3_ops), &tux3fuse);
 	if (fs) {
---1463795455-1613803893-1357119934=:10305--
