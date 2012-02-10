Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2BJHko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 02:40:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2BJHkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 02:40:43 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 9 Feb 2012 23:40:22 -0800
Message-ID: <CALCETrVWBdp2yyuZ54osq_QQ0a8NKUfOk8stxtuiFWq76FO7JQ@mail.gmail.com>
Subject: Do the x86 kernel entry points need an xabort on TSX cpus?
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just read the Intel TSX reference (Chapter 8 of the current
Instruction Set Extensions
Programming Reference).  It says, in Section 8.3.8.1:

In addition, in some implementations, the following instructions may
always cause
transactional aborts. These instructions are not expected to be commonly used
inside typical transactional regions. However, programmers must not
rely on these
instructions to force a transactional abort, since whether they cause
transactional
aborts is implementation dependent.

[...]

 - Ring transitions: SYSENTER, SYSCALL, SYSEXIT, and SYSRET.

I suspect that many bits of the kernel expect that things they do
won't unhappen.  For example, it could be fun to do:

int devrandom = open("/dev/random", O_RDONLY);
unsigned int abort_code = _xbegin();

if (abort_code & 1) {
  printf("Your next random byte is %d\n", (int)(abort_code >> 24));
} else if (abort_code != 0) {
  printf("Attack failed\n");
} else {
  char r;
  read(devrandom, &r, 1);
  _xabort(r);
}

[This won't compile because _xabort requires an immediate argument.
Fixing that is easy with assembler tricks.]

So... do all of the syscall entries (and maybe even the page fault
handler) need explicit xabort instructions?  Or is the manual (or my
understanding of it) wrong?

(The manual also says that IO instructions and sti might not abort.
That seems surprising.)

--Andy

P.S.  Aside from this issue, TSX seems really neat.  I can even think
of some single-threaded uses for it.
