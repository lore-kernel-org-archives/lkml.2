Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab0FRNth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:49:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab0FRNte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a1yVQGdVqhnwlRZUf/5yBrreFxacWI2yx9e5TPMx1AwpThjn41uR84Z3P0+vieievf
         UYEZ8Nj8hqqOsLZvKzmVMnjx60b7EElERiacZGvCaymoOORLQvfjC+zBPHBy4YkNdu1X
         W55KRaClDNu6R/gFfFf7RsbHEgbRtCguAwNYg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
References: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
Date: Fri, 18 Jun 2010 15:49:32 +0200
Message-ID: <AANLkTinji7n8Hd1Ldci_ruH0r8qglGjC00YQkb-MEwoV@mail.gmail.com>
Subject: [RESEND][REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: akpm@linux-foundation.org
Cc: tabbott@ksplice.com, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Linus, Jeff, ... anyone?
Please apply this patch.

CONFIG_STATIC_LINK is still broken. :(

//richard
---------- Forwarded message ----------
From: Tim Abbott <tabbott@ksplice.com>
Date: Mon, Jan 4, 2010 at 10:08 PM
Subject: [REGRESSION] um: CONFIG_STATIC_LINK=y broken
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org,
richard -rw- weinberger <richard.weinberger@gmail.com>, Sam Ravnborg
<sam@ravnborg.org>


Hi Linus,

The following patch fixes a regression that I caused in 2.6.32 when
cleaning up the um architecture's linker scripts.

I've not heard anything from the um maintainers (they have had since
Richard Weinberger reported that this patch fixed the problem on December
22), so I'm sending this to you now (and CCing stable@ since it affects
2.6.32).

       -Tim Abbott

--

um: remove PAGE_SIZE alignment in linker script causing kernel segfault.

The linker script cleanup that I did in commit
5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 accidentally introduced an
ALIGN(PAGE_SIZE) when converting to use INIT_TEXT_SECTION; Richard
Weinberger reported that this causes the kernel to segfault with
CONFIG_STATIC_LINK=y.

I'm not certain why this extra alignment is a problem, but it seems likely
it is because previously

__init_begin = _stext = _text = _sinittext

and with the extra ALIGN(PAGE_SIZE), _sinittext becomes different from the
rest.  So there is likely a bug here where something is assuming that
_sinittext is the same as one of those other symbols.  But reverting the
accidental change fixes the regression, so it seems worth committing that
now.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Reported-by: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
 arch/um/kernel/uml.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index e7a6cca..664f942 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -22,7 +22,7 @@ SECTIONS
  _text = .;
  _stext = .;
  __init_begin = .;
-  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_TEXT_SECTION(0)
  . = ALIGN(PAGE_SIZE);

  .text      :
--
1.6.5.7
