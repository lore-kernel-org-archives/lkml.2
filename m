Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2AYMnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:43:35 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:62079 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2AYMnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:43:33 -0500
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 07:43:33 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20255.62146.305064.490693@pilspetsen.it.uu.se>
Date: Wed, 25 Jan 2012 13:17:06 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Stefan Seidel <stefans@android-x86.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Emulating unsupported x86 opcodes in software
In-Reply-To: <CACcUPpa5FydvemAX7idTOi9dU3+UYs_cra_YNq1bbQc47jr0Yw@mail.gmail.com>
References: <CACcUPpa5FydvemAX7idTOi9dU3+UYs_cra_YNq1bbQc47jr0Yw@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seidel writes:
 > Hello,
 > 
 > I'm looking for advice regarding the emulation of CPU instructions
 > which the current processor doesn't support. Specifically, I want to
 > emulate SSE3 instructions on non-SSE3-capable CPUs. The OSx86
 > project[1] has developed an SSE3 emulation based on SSE2 instructions.
 > 
 > The general idea is:
 >  - install a "stage 1" trap handler for INT 6h (invalid opcode)
 >  - "stage 1" handler returns the address of the "stage 2" handler, the
 > actual emulation routine
 >  - "stage 2" handler runs in user-mode, reads the invalid (SSE3)
 > instruction and operands and emulates it
 >  - "stage 2" handler stores the result in the correct destination
 > (register or memory) and restores all dirty registers to their
 > original state
 > More in-depth description is available as PDF[2].
 > 
 > Now it is not a problem to replace the INT 6h handler, but these are
 > my open questions:
 > 1. How can I have the stage 2 handler run in user-mode (ring 3)
 > 2. How do I allocate/obtain the address of the code segment containing
 > the stage 2 handler OR
 > 3. Is it even possible to for code which is implemented in the kernel
 > to be called and executed in user-mode, and if not, what is the
 > alternative.
 > 
 > Both stage 1 and 2 handlers are available as binary (currently, I'm
 > trying to contact the original author for the source code).
 > 
 > Thank you very much for any help.
 > 
 > Stefan Seidel
 > P.S.: CC'ing me in your answer would be appreciated.
 > 
 > [1] http://code.google.com/p/xnu-dev/
 > [2] http://code.google.com/p/xnu-dev/downloads/detail?name=SSE3%20Emulator.pdf

Just two general comments, not specifically related to emulating SSE3:

1. Deploying the emulator from userspace would be preferable.  LD_PRELOAD a
   library containing the SSE3 emulation and init code to set up a SIGILL
   handler.  This solves all the ring 0 vs 3 problems and avoids needing
   any kernel modifications.

   For static binaries you can use a debugger-like launcher to insert
   and activate the emulation code.

2. It's not always the case that new instructions in later generation x86
   processors trap in earlier generation processors.  E.g., several years
   ago I discovered by accident that a PIII would run SSE (or was it SSE2?)
   instructions w/o trapping, it just ignored the additional prefix and
   executed the corresponding MMX instruction instead.  Maybe that was an
   isolated case, I don't know.

   In the worst case you'll need binary rewriting (static or dynamic), which
   also is implementable entirely in userspace without kernel modifications.
