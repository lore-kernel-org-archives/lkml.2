Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1BJM2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:28:30 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:58730 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1BJMZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:08 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: Andy Isaacson <adi@hexapodia.org>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
Date: Thu, 10 Feb 2011 14:24:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-ARCH; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20110209195258.GN11874@hexapodia.org> <201102100001.42769.lasse.collin@tukaani.org> <20110209232302.GS11874@hexapodia.org>
In-Reply-To: <20110209232302.GS11874@hexapodia.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102101424.59128.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-10 Andy Isaacson wrote:
> On Thu, Feb 10, 2011 at 12:01:42AM +0200, Lasse Collin wrote:
> > On 2011-02-09 Andy Isaacson wrote:
> > > % ls -l arch/x86/boot/bzImage
> > > -rw-r--r-- 1 adi adi 1991504 Feb  1 18:41 arch/x86/boot/bzImage
> > 
> > "Feb 1" was about a week ago. The file is a few days older than the
> > commit ID, assuming that your clock is set correctly.
> 
> Ah, yes, this is my regular build tree; I routinely pull and build
> there.
> 
> So the build failed, but the output file remains because it failed on
> an intermediate step.  (This testing was from me reproducing it on a
> different system, with 100b33).
> 
> Rewinding to the original system which failed to boot...
> 
> How did "make install" create a broken
> /boot/vmlinuz-2.6.38-rc3-0312-gcb5520f that caused the boot-time
> error message?
> 
> If I re-run "make -j4" in the tree that caused the problem, make
> fails with exit code 2.
> 
> The following seems to reproduce the silent error:
> 
> rm .config
> make defconfig
> make -j4
> edit .config and set CONFIG_KERNEL_XZ=y, CONFIG_KERNEL_GZIP=n
> 
> % make -j4
> ...
> Kernel: arch/x86/boot/bzImage is ready  (#64)
> % echo $?
> 0

It looks a like a bug in dash. The following with dash prints foo bar 
and returns with exit status 0, but other shells print only foo and 
return with non-zero exit status:

    sh -c 'set -e ; echo foo ; ( false ) ; echo bar'

That is, "set -e" has no effect on a subshell returning a non-zero exit 
status. Without a subshell it works correctly:

    sh -c 'set -e ; echo foo ; { false ; } ; echo bar'

Kernel compression and mkpiggy use command lines that hit this bug. Here 
is a quick hack to avoid the unneeded subshell for these command lines, 
which also works around the dash bug:

    sed -i 's|( *\( *rm -f $@ ; false\) *)|{ \1 ; }|' \
        scripts/Makefile.lib arch/x86/boot/compressed/Makefile

There are similar "set -e" + subshell constructs in other makefiles and 
scripts. I don't know if it makes sense to accommodate a buggy but 
common /bin/sh by modifying makefiles and scripts to avoid the 
problematic construct. Maybe it would be better to have a test to catch 
the buggy shell and tell the user to use e.g. "make SHELL=/bin/bash".

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
