Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0C0Df5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 23:35:57 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46421
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0C0Df4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 23:35:56 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: David Miller <davem@davemloft.net>, blauwirbel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
Date: Fri, 26 Mar 2010 22:35:47 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-18-generic; KDE/4.2.2; x86_64; ; )
References: <f43fc5581002201359x50aff2b1ofc4f816762bda597@mail.gmail.com> <201002211025.11588.rob@landley.net> <20100221.180658.226784107.davem@davemloft.net>
In-Reply-To: <20100221.180658.226784107.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003262235.48736.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 February 2010 20:06:58 David Miller wrote:
> Here's the fix I'll use, thanks for the report Rob:
>
> sparc32: Fix struct stat uid/gid types.
>
> Commit 085219f79cad89291699bd2bfb21c9fdabafe65f
> ("sparc32: use proper types in struct stat")

Unfortunately, while this fix makes sparc buidl and run again, the exported 
kernel headers are horked and can't build strace natively.

gcc -DHAVE_CONFIG_H -I. -Ilinux/sparc -I./linux/sparc -Ilinux -I./linux   -
Wall --static -MT file.o -MD -MP -MF .deps/file.Tpo -c -o file.o file.c
In file included from file.c:88:
/usr/bin/../include/asm/stat.h:56: error: expected specifier-qualifier-list 
before 'uid16_t'
file.c: In function 'realprintstat':
file.c:951: warning: format '%lu' expects type 'long unsigned int', but 
argument 2 has type 'unsigned int'
make[1]: *** [file.o] Error 1
make[1]: Leaving directory `/home/strace-4.5.19'
make: *** [all] Error 2

The problem is that uid16_t is a kernel internal type that gets cleaned out of 
the headers when they're exported, thus there's no definition for userspace to 
pick up if that structure is ever used from a userspace build.

What exactly was the problem with just saying "unsigned short" when you mean 
an unsigned short?  The way x86 does, and arm?  (If these ever change, it 
breaks binary compatability.  Not sure what these changes were trying to 
accomplish...)

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
