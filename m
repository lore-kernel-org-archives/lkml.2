Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0FNSWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:22:16 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53912 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0FNSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:22:15 -0400
Date: Mon, 14 Jun 2010 20:22:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
Message-ID: <20100614182212.GA14747@merkur.ravnborg.org>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 01:38:28PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matthew.fleming@imgtec.com>
> 
> Many architectures collect text sections beginning with '.text.' in
> their .text section, so move this pattern into TEXT_TEXT to stop them
> all having to duplicate the pattern in their arch/ linker scripts.
> 
> Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
> ---
>  include/asm-generic/vmlinux.lds.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 48c5299..08f4680 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -369,6 +369,7 @@
>  		ALIGN_FUNCTION();					\
>  		*(.text.hot)						\
>  		*(.text)						\
> +		*(.text.*)						\
>  		*(.ref.text)						\
>  	DEV_KEEP(init.text)						\
>  	DEV_KEEP(exit.text)						\

This will break ia64.
>From their vmlinux.lds.h:

        TEXT_TEXT
        SCHED_TEXT
        LOCK_TEXT
        KPROBES_TEXT
        *(.gnu.linkonce.t*)
    }
  .text2 : AT(ADDR(.text2) - LOAD_OFFSET)
        { *(.text2) }
#ifdef CONFIG_SMP
  .text..lock : AT(ADDR(.text..lock) - LOAD_OFFSET)
        { *(.text..lock) }
#endif

The patch above we would match the section ".text.*" too soon and
add the .text..lock section at the wrong place.

Browsing the vmlinux.lds files other archs will be impacted too.

If you feel tempted to clean up the linker script one place to start
would be to introduce consistent indention / layout.
If you use arch/sparc/kernel/vmlinux.lds.h as a template then you
have a good start.

The above mentioned ia64 vmlinux.lds.h would be a good place to start.

	Sam
