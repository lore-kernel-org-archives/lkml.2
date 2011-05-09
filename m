Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1EIQ4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:56:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60030 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1EIQ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:56:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 and -next - __kfree_rcu breaks third-party kernel code
In-Reply-To: Your message of "Mon, 09 May 2011 09:17:57 PDT."
             <20110509091757.580f3f6c.randy.dunlap@oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <7961.1304953500@localhost>
            <20110509091757.580f3f6c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304960192_2759P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 May 2011 12:56:32 -0400
Message-ID: <14010.1304960192@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DC81CC1.01DE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304960192_2759P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <14004.1304960192.1@localhost>

On Mon, 09 May 2011 09:17:57 PDT, Randy Dunlap said:

> I'd be happy to see a simple fix, but we don't generally support building
> external modules without using the kernel kbuild infrastructure AFAIK --
> and when I add a Makefile along with your kernconf.c file, it builds successfully
> on mmotm-2011-0506-1639.

And in fact the module *does* use the Makefile stuff for the actual build - it
was just the installer's "am I looking at a sane 2.6 tree" sanity check that
bombed. So I go looking for what special sauce the Makefile adds to make it
work, and....

OK, *now* I'm confused.  The magic sauce appears to be "-Os". Adding that makes
the compile work.  And for no obvious reason - there's something in there that
causes indigestion, but only if the optimizer isn't invoked.

*WTF*?

 LANG=C ./kern.sh 
cat > /tmp/kernconf.c <<EOF
#include <linux/version.h>
#include <linux/utsname.h>
EOF
+ cat

kern="/lib/modules/2.6.39-rc6-mmotm0506/"
+ kern=/lib/modules/2.6.39-rc6-mmotm0506/
cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I${kern}/build/include -I$kern/arch/x86/include/generated -include ${kern}/build/include/generated/autoconf.h -I${kern}/build/arch/x86/include -I${kern}/include/generated -Os -c /tmp/kernconf.c
+ cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc6-mmotm0506//build/include -I/lib/modules/2.6.39-rc6-mmotm0506//arch/x86/include/generated -include /lib/modules/2.6.39-rc6-mmotm0506//build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc6-mmotm0506//build/arch/x86/include -I/lib/modules/2.6.39-rc6-mmotm0506//include/generated -Os -c /tmp/kernconf.c
cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I${kern}/build/include -I$kern/arch/x86/include/generated -include ${kern}/build/include/generated/autoconf.h -I${kern}/build/arch/x86/include -I${kern}/include/generated -c /tmp/kernconf.c
+ cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc6-mmotm0506//build/include -I/lib/modules/2.6.39-rc6-mmotm0506//arch/x86/include/generated -include /lib/modules/2.6.39-rc6-mmotm0506//build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc6-mmotm0506//build/arch/x86/include -I/lib/modules/2.6.39-rc6-mmotm0506//include/generated -c /tmp/kernconf.c
In file included from /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/sem.h:81:0,
                 from /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/sched.h:72,
                 from /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/utsname.h:35,
                 from /tmp/kernconf.c:2:
/lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/rcupdate.h: In function '__kfree_rcu':
/lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/rcupdate.h:822:2: error: size of unnamed array is negative

rm /tmp/kernconf.c
+ rm /tmp/kernconf.c





--==_Exmh_1304960192_2759P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNyBzAcC3lWbTT17ARAtAsAKCBjgt8GlXuQhBrChI8/Al/qGrSbACfRE0V
4G7tnEZwOWJOKRHGHQWVSEs=
=PVdx
-----END PGP SIGNATURE-----

--==_Exmh_1304960192_2759P--

