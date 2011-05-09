Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1EIPFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:05:24 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59595 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1EIPFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:05:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.39-rc6-mmotm0506 and -next - __kfree_rcu breaks third-party kernel code
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304953500_2759P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 May 2011 11:05:00 -0400
Message-ID: <7961.1304953500@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DC8029E.002E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304953500_2759P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <7948.1304953491.1@localhost>

So I have a third-party kernel module which wants to check what kernel version
it's building against, and it fails to build under -rc6-mmotm0506 (it works
just fine under -rc5-mmotm0429).

I finally isolated it down to a two-liner section of code, which seems to die
because somebody didn't include something that rcupdate.h wanted to see:

cat > /tmp/kernconf.c <<EOF
#include <linux/version.h>
#include <linux/utsname.h>
EOF
+ cat

# This builds fine
kern="2.6.39-rc5-mmotm0429"
+ kern=2.6.39-rc5-mmotm0429
cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/${kern}/build/include -include /lib/modules/${kern}/build/include/generated/autoconf.h -I/lib/modules/${kern}/build/arch/x86/include -c /tmp/kernconf.c
+ cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc5-mmotm0429/build/include -include /lib/modules/2.6.39-rc5-mmotm0429/build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc5-mmotm0429/build/arch/x86/include -c /tmp/kernconf.c

# this one dies
kern="2.6.39-rc6-mmotm0506"
+ kern=2.6.39-rc6-mmotm0506
cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/${kern}/build/include -include /lib/modules/${kern}/build/include/generated/autoconf.h -I/lib/modules/${kern}/build/arch/x86/include -c /tmp/kernconf.c
+ cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc6-mmotm0506/build/include -include /lib/modules/2.6.39-rc6-mmotm0506/build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc6-mmotm0506/build/arch/x86/include -c /tmp/kernconf.c
In file included from /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/sem.h:81:0,
                 from /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/sched.h:72,
                 from /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/utsname.h:35,
                 from /tmp/kernconf.c:2:
/lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/rcupdate.h: In function '__kfree_rcu':
/lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/rcupdate.h:822:2: error: size of unnamed array is negative

rm /tmp/kernconf.c
+ rm /tmp/kernconf.c

'git blame include/linux/rcudate.h' points at this commit:

commit 896d4eb94e0b7cd896ee92c380fadc1e9d867cfc
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Fri Mar 18 11:15:47 2011 +0800

    rcu: introduce kfree_rcu()



--==_Exmh_1304953500_2759P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNyAKccC3lWbTT17ARAkkTAJ9LBsnOZ4GafOFnL0op2dVDWH4oQQCfT3i0
/8A9vjYXRFJjLBbY4IEC1S4=
=0TZ6
-----END PGP SIGNATURE-----

--==_Exmh_1304953500_2759P--

