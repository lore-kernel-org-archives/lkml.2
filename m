Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1AYNr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:47:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab1AYNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:47:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=I/90Fzi45RSBxexB1Ntmtbzb4Zx87zNYuioCHW3wC8YUQ/Q7y+tm8VnBPpcrk6ZVTU
         nYLZhCGF24DlGmeRPSQWKPjrzsDvCEsze8SSHrhkocUqvSqRx6+j6qImrFUOn6E5sMwR
         GE5yFTzSTbOcSb6U9gc9+nWjiYndNJ5vLHaF8=
Date: Tue, 25 Jan 2011 15:47:48 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
	panic
Message-ID: <20110125134748.GA10051@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've faced some very early panics in latest kernel. Being a run of the mill
x86 laptop, the machine is void of debugging aids like serial ports or
network boot.

As a possible solution, below patches prototypes the idea of persistently
storing the kernel log ring to a hard disk partition using the enhanced BIOS
0x13 services.

The used BIOS INT 0x13 functions are the same ones originally used by all
contemporary bootloaders to load the Linux kernel. If the kernel code is
already loaded to RAM and being executed, such parts of the BIOS should be
stable enough.

The basic idea is to switch from 64-bit long mode all the way down to 16-bit
real-mode. Once in real-mode, we reset the disk controller and write the log
buffer to disk using a user-supplied absolute disk block address (LBA).

Doing so, we can capture very early panics (along with earlier log messages)
reliably since the writing mechanism has minimal dependency on any Linux code.

Unfortunately, there are problems on some machines.

In my laptop, when calling the BIOS with the "Reset Disk Controllers" command
or even issuing a direct "Extend Write" without a controller reset, the BIOS
hangs for around __5 minutes__. Afterwards, it returns with a 'Timeout' error
code.

The main problem, it seems, is that the BIOS "Reset controller" command is not
enough to restore disk hardware to a state understandable by the BIOS code.

So:

 - Is it possible to re-initialize the disk hardware to its POST state (thus
   make the BIOS services work reliably) while keeping system RAM unmodified?
 - If not, can we do it manually by reprogramming the controllers?

The first patch (#1) implements the longMode -> realMode switch and invokes
the BIOS. The second reserves needed low-memory areas for such code and
registers a panic logger using the kmsg_dump interface.

Both patches are on '-next' and include XXX marks where further help is also
appreciated. Please remember that these patches, while tested, are now for
prototyping the technical feasibility of the idea.

Diffstat:

 arch/x86/kernel/saveoops-rmode.S |  483 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/saveoops.h  |   15 ++
 arch/x86/kernel/saveoops.c       |  219 +++++++++++++++++
 arch/x86/kernel/setup.c          |    9 +
 arch/x86/kernel/Makefile         |    3 +
 lib/Kconfig.debug                |   15 ++
 6 files changed, 744 insertions(+), 0 deletions(-)

Related work and discussions:

 - Tony Luck, persistent store: http://article.gmane.org/gmane.linux.kernel.cross-arch/8495
 - Dirk Hohndel, hpa, Japan Symposium, 2D barcode: http://video.linux.com/video/1661
 - akpm, Dave Jones, oops pauser: http://article.gmane.org/gmane.linux.kernel/369739
 - Willy Tarreau, Randy Dunlap, kmsgdump: http://www.xenotime.net/linux/kmsgdump/

Thanks,

--
Darwish
http://darwish.07.googlepages.com

