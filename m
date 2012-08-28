Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2H1SuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:50:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2H1SuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:50:14 -0400
Date: Tue, 28 Aug 2012 11:49:52 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
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
        Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] cross-arch: don't corrupt personality flags upon
 exec()
In-Reply-To: <503CF76C.2010105@tilera.com>
Message-ID: <alpine.LNX.2.00.1208281135320.22447@pobox.suse.cz>
References: <alpine.LNX.2.00.1208031143320.29827@pobox.suse.cz> <alpine.LNX.2.00.1208131518520.29827@pobox.suse.cz> <20120815154520.f9cf4e24.akpm@linux-foundation.org> <201208221927.28993.arnd@arndb.de> <503CF76C.2010105@tilera.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012, Chris Metcalf wrote:

> > On tile, the PER_LINUX_32BIT is always set for 32 bit compat tasks in a
> > 64 bit kernel, which is harmless but wrong anyway. Also this, tile never
> > calls set_personality, which is also harmless because it just means that
> > exec_domain switching on tile is broken, but the only non-bogus
> > exec_domain besides the default one is an experimental support for Acorn
> > RISC OS binaries that was last updated in 2002 for for linux-2.5.49.
> 
> Arnd, thanks for the drive-by code review.  Is this change the correct fix
> for your observation?
> 
> diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
> index d16d006..fd31920 100644
> --- a/arch/tile/include/asm/elf.h
> +++ b/arch/tile/include/asm/elf.h
> @@ -156,12 +156,12 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
>  #undef SET_PERSONALITY
>  #define SET_PERSONALITY(ex) \
>  do { \
> -       current->personality = PER_LINUX; \
> +       set_personality(PER_LINUX);                  \
>         current_thread_info()->status &= ~TS_COMPAT; \
>  } while (0)
>  #define COMPAT_SET_PERSONALITY(ex) \
>  do { \
> -       current->personality = PER_LINUX_32BIT; \
> +       set_personality(PER_LINUX);                 \
>         current_thread_info()->status |= TS_COMPAT; \
>  } while (0)

Actually this is also wrong. You should be rather doing

	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))

otherwise you clobber the upper personality bits upon exec().

Something like the patch below. Either you can take it for tile, or I can 
ask Andrew to fold it into my tree-wide fix currently waiting in -mm. Just 
let me know.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] tile: Don't corrupt personality flags upon exec()

Historically, the top three bytes of personality have been used for things
such as ADDR_NO_RANDOMIZE, which made sense only for specific
architectures.

We now however have a flag there that is general no matter the
architecture (UNAME26); generally we have to be careful to preserve the
personality flags across exec().

This patch fixes tile architecture not to forcefully overwrite
personality flags during exec().

Plus it fixes exec_domain switching -- set_personality() should always be 
used instead of directly assigning to current->personality.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/tile/include/asm/elf.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index d16d006..cf7f3bd 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -156,12 +156,12 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 #undef SET_PERSONALITY
 #define SET_PERSONALITY(ex) \
 do { \
-	current->personality = PER_LINUX; \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK))); \
 	current_thread_info()->status &= ~TS_COMPAT; \
 } while (0)
 #define COMPAT_SET_PERSONALITY(ex) \
 do { \
-	current->personality = PER_LINUX_32BIT; \
+	set_personality(PER_LINUX_32BIT | (current->personality & (~PER_MASK))); \
 	current_thread_info()->status |= TS_COMPAT; \
 } while (0)
 

-- 
Jiri Kosina
SUSE Labs
