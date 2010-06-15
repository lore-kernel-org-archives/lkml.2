Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab0FOSI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:08:26 -0400
Received: from lirone.symas.net ([64.71.152.235]:44387 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab0FOSIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:08:24 -0400
Message-ID: <4C17C190.1020000@symas.com>
Date: Tue, 15 Jun 2010 11:08:16 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] tty: add EXTPROC support for LINEMODE
References: <4C120D8A.8050207@symas.com> <87631pq2aj.fsf@basil.nowhere.org> <4C121B4C.2000702@symas.com> <4C12E4B7.4020900@symas.com>
In-Reply-To: <4C12E4B7.4020900@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paraphrased from the 1989 BSD patch by David Borman @ cray.com:

     These are the changes needed for the kernel to support
     LINEMODE in the server.

     There is a new bit in the termios local flag word, EXTPROC.
     When this bit is set, several aspects of the terminal driver
     are disabled.  Input line editing, character echo, and mapping
     of signals are all disabled.  This allows the telnetd to turn
     off these functions when in linemode, but still keep track of
     what state the user wants the terminal to be in.

     New ioctl:
         TIOCSIG         Generate a signal to processes in the
                         current process group of the pty.

     There is a new mode for packet driver, the TIOCPKT_IOCTL bit.
     When packet mode is turned on in the pty, and the EXTPROC bit
     is set, then whenever the state of the pty is changed, the
     next read on the master side of the pty will have the TIOCPKT_IOCTL
     bit set, and the data will be the contents of a struct termios.
     This allows the process on the server side of the pty to know
     when the state of the terminal has changed, and what the new
     state is.

Since the original BSD patches accompanied the source code for telnet I've 
left that reference here, but obviously the feature is useful for any remote 
terminal protocol, including ssh.

The corresponding feature has existed in the BSD tty driver since 1989. For 
historical reference, a good copy of the relevant files can be found here:

http://anonsvn.mit.edu/viewvc/krb5/trunk/src/appl/telnet/?pathrev=17741

Signed-off-by: Howard Chu <hyc@symas.com>

---
Howard Chu (2):
   Add EXTPROC tty support for Telnet LINEMODE
   Add arch-specific EXTPROC definitions

  arch/alpha/include/asm/ioctls.h     |    2 ++
  arch/alpha/include/asm/termbits.h   |    1 +
  arch/arm/include/asm/ioctls.h       |    2 ++
  arch/arm/include/asm/termbits.h     |    1 +
  arch/avr32/include/asm/ioctls.h     |    2 ++
  arch/avr32/include/asm/termbits.h   |    1 +
  arch/cris/include/asm/ioctls.h      |    2 ++
  arch/cris/include/asm/termbits.h    |    1 +
  arch/frv/include/asm/ioctls.h       |    2 ++
  arch/frv/include/asm/termbits.h     |    1 +
  arch/h8300/include/asm/ioctls.h     |    2 ++
  arch/h8300/include/asm/termbits.h   |    1 +
  arch/ia64/include/asm/ioctls.h      |    2 ++
  arch/ia64/include/asm/termbits.h    |    1 +
  arch/m32r/include/asm/ioctls.h      |    2 ++
  arch/m32r/include/asm/termbits.h    |    1 +
  arch/m68k/include/asm/ioctls.h      |    2 ++
  arch/m68k/include/asm/termbits.h    |    1 +
  arch/mips/include/asm/ioctls.h      |    3 ++-
  arch/mips/include/asm/termbits.h    |    1 +
  arch/mn10300/include/asm/ioctls.h   |    2 ++
  arch/mn10300/include/asm/termbits.h |    1 +
  arch/parisc/include/asm/ioctls.h    |    2 ++
  arch/parisc/include/asm/termbits.h  |    1 +
  arch/powerpc/include/asm/ioctls.h   |    2 ++
  arch/powerpc/include/asm/termbits.h |    1 +
  arch/s390/include/asm/ioctls.h      |    2 ++
  arch/sh/include/asm/ioctls.h        |    2 ++
  arch/sparc/include/asm/ioctls.h     |    2 ++
  arch/sparc/include/asm/termbits.h   |    1 +
  arch/xtensa/include/asm/ioctls.h    |    2 ++
  arch/xtensa/include/asm/termbits.h  |    1 +
  drivers/char/n_tty.c                |   25 ++++++++++++++++++++++---
  drivers/char/pty.c                  |   13 +++++++++++++
  drivers/char/tty_ioctl.c            |   18 ++++++++++++------
  fs/compat_ioctl.c                   |    1 +
  include/asm-generic/ioctls.h        |    2 ++
  include/asm-generic/termbits.h      |    1 +
  include/linux/tty.h                 |    1 +
  39 files changed, 101 insertions(+), 10 deletions(-)

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
