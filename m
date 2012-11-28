Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2K1PVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:21:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab2K1PVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:21:13 -0500
Date: Wed, 28 Nov 2012 10:22:38 -0500
From: Don Zickus <dzickus@redhat.com>
To: Prasad Koya <prasad.koya@gmail.com>
Cc: aarcange@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: vmalloc_sync_all(), 64bit kernel, patches
 9c48f1c629ecfa114850c03f875c6691003214de,
 a79e53d85683c6dd9f99c90511028adc2043031f
Message-ID: <20121128152238.GQ14805@redhat.com>
References: <CAGXD9OfAMUmrdFBap3aOYXOhXE6=i8qL7=+SsJYnrdEr3kyMKw@mail.gmail.com>
 <20121127145505.GA14805@redhat.com>
 <CAGXD9OeokxUx_2WdpkYthyrYc52SCvne=H9vi45p_6ovo6EGpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXD9OeokxUx_2WdpkYthyrYc52SCvne=H9vi45p_6ovo6EGpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:20:11PM -0800, Prasad Koya wrote:
> I'm definitely seeing above lockup with 2.6.38.8. In 3.2 and up kernel
> nmi_shootdown_cpus() replaced register_die_notifier() with
> register_nmi_handler() which doesn't call vmalloc_sync_all. If I patch
> my 2.6.38.8 so it behaves as 3.2 in this regard ie., skip
> vmalloc_sync_all, I don't see any issue.

I don't know what vmalloc_sync_all really does (or sync_global_pgds for
that matter), but it seems like it is trying to sync up all the processors
by flush tlbs.  If that is the case then that is going to cause issues
with NMI or at least your use of lkdtm.

The reason why is with NMIs and your use of lkdtm, IPIs are blocked (nmi
has higher priority and lkdtm disabled interrupts).  This usually causes
hangs with any mm flushing (tlbs, pgds, etc).

I think that is why Andrea put in one of his changelog that it is
forbidden to grab the page_lock with irqs disabled (namely IPIs blocked).

> 
> So my question is, is it safe to bypass calling vmalloc_sync_all() as
> part of setting up NMI handler? Maybe with a patch like below:
> 
> --- linux-2.6.38.orig/kernel/notifier.c
> +++ linux-2.6.38/kernel/notifier.c
> @@ -574,7 +574,8 @@ int notrace __kprobes notify_die(enum di
> 
>  int register_die_notifier(struct notifier_block *nb)
>  {
> -       vmalloc_sync_all();
> +       if (!oops_in_progress)
> +               vmalloc_sync_all();
>         return atomic_notifier_chain_register(&die_chain, nb);
>  }
>  EXPORT_SYMBOL_GPL(register_die_notifier);

You are dying anyway, so this patch is probably ok and will get you by for
now.  I am not sure how important sync'ing the pgds are at this point.

I wouldn't recommend this for 3.7 or anything, but if you want to use this
as a private patch I can't see anything wrong with it.  I think the only
caller that calls register_die_notifier within an oops is crash_kexec
anyway.

Cheers,
Don
