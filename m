Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1IUSEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:04:35 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:59603 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1IUSEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:04:34 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
Date: Wed, 21 Sep 2011 19:04:29 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Jonas Bonn <jonas.bonn@gmail.com>, Richard Kuo <rkuo@codeaurora.org>,
        linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
References: <20110909010847.294039464@codeaurora.org> <201109211715.20795.pedro@codesourcery.com> <20110921175009.GA3703@codeaurora.org>
In-Reply-To: <20110921175009.GA3703@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109211904.29572.pedro@codesourcery.com>
X-OriginalArrivalTime: 21 Sep 2011 18:04:31.0974 (UTC) FILETIME=[E9C44060:01CC7888]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 September 2011 18:50:09, Linas Vepstas (Code Aurora) wrote:
> On Wed, Sep 21, 2011 at 05:15:20PM +0100, Pedro Alves wrote:
> > > On Sat, Sep 10, 2011 at 12:29:57PM +0100, Pedro Alves wrote:
> > > > Yes, the x86/x86-64 ports or gdb and gdbserver are already
> > > > using GET/SETREGSET even.
> 
> Thanks; after a bit of initial confusion, I've gotten gdb to
> work with this, so I'm happy. 
> 
> > I wish there was an equivalent of PTRACE_GETREGSET for siginfo...
> 
> How? Why?

One of the the cool features of PTRACE_GETREGSET is that it returns
the regset in the natural layout of the tracee.  So when debugging a 
32-bit process on a 64-bit kernel, PTRACE_GETREGSET returns the
regset in 32-bit layout.  Recent enough GDBs can print the siginfo of a
caught signal (before its delivered with (PTRACE_CONT, sig).
Try "(gdb) p $_siginfo" on x86.  Trouble is 32-bit processes on 64-bit
kernels or other biarch setups.  PTRACE_GETSIGINFO returns the siginfo in
64-bit layout, so GDB gets to try to immitate what the kernel's 32-bit
compat layer does.  Both for reading and writting siginfo.
See compat_siginfo_from_siginfo and siginfo_from_compat_siginfo
at [1].
The kernel already knows to convert siginfo to the native layout
of the process -- needed to pass to the user space signal handler
at least.  But AFAIK, there's no way for the debugger to get at it
before the signal is actually delivered.

[1]
http://sourceware.org/cgi-bin/cvsweb.cgi/src/gdb/amd64-linux-nat.c?rev=1.35&content-type=text/x-cvsweb-markup&cvsroot=src

-- 
Pedro Alves
