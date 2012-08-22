Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab2HVT2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:28:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2HVT15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:27:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] cross-arch: don't corrupt personality flags upon exec()
Date: Wed, 22 Aug 2012 19:27:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Mark Salter <msalter@redhat.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Richard Kuo <rkuo@codeaurora.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Jonas Bonn <jonas@southpole.se>, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
References: <alpine.LNX.2.00.1208031143320.29827@pobox.suse.cz> <alpine.LNX.2.00.1208131518520.29827@pobox.suse.cz> <20120815154520.f9cf4e24.akpm@linux-foundation.org>
In-Reply-To: <20120815154520.f9cf4e24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221927.28993.arnd@arndb.de>
X-Provags-ID: V02:K0:PLk6Tpl9qTu20Jxlwqpw469d/3dvSL29EoT6GnxomDP
 5kq5jtzQW8boFSrlzR2OIV6UabuwgNTGefJH/UwzaVDO67tNOZ
 DtvJUhnEoQax0hePJq+7ywTfFOFGMzUV2BFXsHv95qwsH6fjng
 Fh4VxljQr5ieNHMzCUyEVb/f6xco8PCuw8fG1g0NSAMuHhoMab
 wn3lDEy3dc+nmUyOwRAVtOaY3X866fMDE3QeXpGl6+sFM0Pum6
 BmycL8B4cFOHi4gtuISI2yYCxmXcJADYsDoJo1UamkrLbKgT4O
 xqu3EN52DITYfan8ssQ+SG2ZX6+xIFfdG7KvdJ3VG1ArApk3EU
 XD1tN/cJfGcrdzENxWP8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2012, Andrew Morton wrote:
> Extra marks will be awarded if you can work out whether to use
> PER_LINUX_32BIT ;)

I'll try this:

PER_LINUX_32BIT is defined as (PER_LINUX | ADDR_LIMIT_32BIT).

The ADDR_LIMIT_32BIT flag is used in exactly two places in the kernel:

1. On alpha, it limits the available address space to 32 bits, in order to
  run certain legacy applications (Netscape) that are not 64 bit safe and were
  compiled with an interesting 32 bit user space mode with 64 bit syscalls.

2. on ARM, it is used to /not/ limit the user address space to 26 bits.
   For all practical purposes, one must set the ADDR_LIMIT_32BIT flag to
   run modern applications now.

The avr32, microblaze architectures always set PER_LINUX_32BIT because they
copied from ARM, but the flag has no effect there.

On tile, the PER_LINUX_32BIT is always set for 32 bit compat tasks in a 64 bit
kernel, which is harmless but wrong anyway. Also this, tile never calls
set_personality, which is also harmless because it just means that exec_domain
switching on tile is broken, but the only non-bogus exec_domain besides the
default one is an experimental support for Acorn RISC OS binaries that was
last updated in 2002 for for linux-2.5.49.

	Arnd
