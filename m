Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab1D0Ugq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:36:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60577 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889Ab1D0Ugm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HGqUxa9yujiUMj9EkAs7AZ00XMOWYHiWs3i5yTsmPzyvozoKOo1Zo5C91xobaJ5yea
         2XhMccywQG+q/7xUfjxhnTxzGRaoQPdZtcnAA6eiR3JqhlyvREORQjXdA+L4eYSFyHib
         2oZ7RCxJyOY1fW0AogXOXmOsG9OGsEzSaf89A=
MIME-Version: 1.0
In-Reply-To: <1303935518.2583.27.camel@mulgrave.site>
References: <1303935518.2583.27.camel@mulgrave.site>
Date: Wed, 27 Apr 2011 22:36:40 +0200
X-Google-Sender-Auth: kX7nwT9G-9NfOT4nC5bgkZQbzj4
Message-ID: <BANLkTimPzRuGqjxXqe7tn-C52suTVE9+ig@mail.gmail.com>
Subject: Re: [GIT PULL] parisc fixes for 2.6.39-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 22:18, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> These two fixes contain the agreed fix for our slub panic (agreed with
> the mm folks that we'll define SLUB broken in the !NUMA && DISCONTIGMEM
> case, which should fix m86k as well) and another buglet that turned up
> examining the parisc discontigmem code.

Do we still need to mark SLUB broken?
On m68k, the issue seems to have been fixed by setting the N_NORMAL_MEMORY flag
(pull request scheduled after one more linux-next build cycle).

Or do you plan to unmark it broken once every affected arch sets the
N_NORMAL_MEMORY flag?

> The patches are here:
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#fixes
>
> The short changelog is:
>
> David Rientjes (1):
>      [PARISC] set memory ranges in N_NORMAL_MEMORY when onlined
>
> James Bottomley (1):
>      [PARISC] slub: fix panic with DISCONTIGMEM
>
> The diffstat is:
>
>  arch/parisc/mm/init.c |    4 +++-
>  init/Kconfig          |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)
>
> And the full diff are below.
>
> James
>
> ---
>
> diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> index b7ed8d7..b1d1262 100644
> --- a/arch/parisc/mm/init.c
> +++ b/arch/parisc/mm/init.c
> @@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
>        }
>        memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
>
> -       for (i = 0; i < npmem_ranges; i++)
> +       for (i = 0; i < npmem_ranges; i++) {
> +               node_set_state(i, N_NORMAL_MEMORY);
>                node_set_online(i);
> +       }
>  #endif
>
>        /*
> diff --git a/init/Kconfig b/init/Kconfig
> index 56240e7..a7ad8fb 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1226,6 +1226,7 @@ config SLAB
>          per cpu and per node queues.
>
>  config SLUB
> +       depends on BROKEN || NUMA || !DISCONTIGMEM
>        bool "SLUB (Unqueued Allocator)"
>        help
>           SLUB is a slab allocator that minimizes cache line usage

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
