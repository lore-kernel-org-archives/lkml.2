Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0HTVS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:18:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0HTVSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:18:37 -0400
Message-Id: <20100820211401.651509182@suse.com>
User-Agent: quilt/0.47-15.10
Date: Fri, 20 Aug 2010 17:14:01 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [patch 00/10] ioctls: Convert ten architectures to asm-generic/ioctls.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around the time of the 32-/64-bit x86 merge, asm-generic/ioctls.h was
created. It was modeled after the x86 version and new architectures are
encouraged to use it.

It turns out that ten other architectures have done essentially the same
thing, but by copying it instead. This series of patches updates those
architectures to use the generic version.

There were a few differences between the arch-specific versions and the
generic one, but none problematic enough to preclude this merge.

Specifically:
- 5 architectures define their own FIOQSIZE. asm-generic/ioctls.h
  already contains an ifndef for exactly this case.
- cris defines two new rs-485 ioctls and redefines another one. The
  two new ones are kept private and an ifndef line is added to the
  generic list.
- frv and h8300 provide TIOCTTYGSTRUCT, which is completely unused.
  I've kept it private to those architectures but it should probably
  be removed.
- The generic list contains the termiox ioctl set. This seems to have
  been added to x86 with the expectation that other arch maintainers
  would add it to their own. New architectures have inherited this
  automatically via asm-generic/ioctls.h and there isn't anything
  inherently architecture specific about it. It's safe to just
  add it to the affected architectures. If there is resistance to
  this, I can submit a separate patchset to enable it on those
  architectures and THEN apply this patchet, but it seems like a
  waste of time.
- The generic list provides TIOCGRS485 and TIOCSRS485, but they are
  still only used by two drivers, which are only available on arm,
  avr32, and cris. Again, there is nothing inherently architecture
  specific about it and new architectures have inherited it already.

All this can be verified with the following script. It strips
whitespace, comments, and the leading ifndef/define header, sorts the
output, and compares it without whitespace. It doesn't do any value
processing, strictly 1:1 text.

I plan to audit the remaining architectures when I get a chance. Those
are parisc, powerpc, sh, and xtensa.

-Jeff

---->8----
#!/bin/sh
process_include() {
	sed -ne 's/^#[[:space:]]*define/#define/p' < $1 | \
	sed -e 's#/\*.*##'| sed -e 's/[[:space:]]*$//' | \
	egrep -v '#define _*(ASM|ARCH)'|grep -v ^$ | sort -k 2
}

process_include include/asm-generic/ioctls.h > generic_ioctls

for arch in arm avr32 cris frv h8300 ia64 m32r m68k mn10300 s390; do
	process_include arch/$arch/include/asm/ioctls.h > $arch-ioctls
	echo [$arch]
	diff -wu $arch-ioctls generic_ioctls #|grep '^+#'
	rm -f $arch-ioctls
done

rm generic_ioctls
----8<----


