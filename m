Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab2J2KcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:32:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38985 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2J2KcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:32:21 -0400
Date: Mon, 29 Oct 2012 11:32:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <herrmann.der.user@gmail.com>
Subject: Re: [PATCH v3] Add support for AMD64 EDAC on multiple PCI domains
Message-ID: <20121029103217.GD4326@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Andreas Herrmann <herrmann.der.user@gmail.com>
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com>
 <20121025110353.GA2623@aftab.osrc.amd.com>
 <508E1F64.3080806@numascale-asia.com>
 <508E4463.3080503@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <508E4463.3080503@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Andreas.

Dude, look at this boot log below:

http://quora.org/2012/16-server-boot-2.txt

That's 192 F10h's!

On Mon, Oct 29, 2012 at 04:54:59PM +0800, Daniel J Blueman wrote:
> >A number of other callers lookup the PCI device based on index
> >0..amd_nb_num(), but we can't easily allocate contiguous northbridge IDs
> >from the PCI device in the first place.
> 
> >OTOH we can simply this code by changing amd_get_node_id to generate a
> >linear northbridge ID from the index of the matching entry in the
> >northbridge array.
> >
> >I'll get a patch together to see if there are any snags.

I suspected that after we have this nice approach, you guys would come
with non-contiguous node numbers. Maan, can't you build your systems so
that software people can have it easy at least for once??!

:-)

> This really is a lot less intrusive [1] and boots well on top of
> 3.7-rc3 on one of our 16-server/192-core/512GB systems [2].
> 
> If you're happy with this simpler approach for now, I'll present
> this and a separate patch cleaning up the inconsistent use of
> unsigned and u8 node ID variables to u16?

Sure, bring it on.

> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index b3341e9..b88fc7a 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -81,6 +81,18 @@ static inline struct amd_northbridge
> *node_to_amd_nb(int node)
>         return (node < amd_northbridges.num) ?
> &amd_northbridges.nb[node] : NULL;
>  }
> 
> +static inline u8 get_node_id(struct pci_dev *pdev)
> +{
> +       int i;
> +
> +       for (i = 0; i != amd_nb_num(); i++)
> +               if (pci_domain_nr(node_to_amd_nb(i)->misc->bus) ==
> pci_domain_nr(pdev->bus) &&
> +                   PCI_SLOT(node_to_amd_nb(i)->misc->devfn) ==
> PCI_SLOT(pdev->devfn))
> +                       return i;

Looks ok, can you send the whole patch please?

> +       BUG();

I'm not sure about this - maybe WARN()? Are we absolutely sure we
unconditionally should panic after not finding an NB descriptor?

> [2] http://quora.org/2012/16-server-boot-2.txt

That's just crazy:

[   45.987953] Brought up 192 CPUs

:-)

Btw, this shouldn't happen on those CPUs:

[   39.279131] TSC synchronization [CPU#0 -> CPU#12]:
[   39.287223] Measured 22750019569 cycles TSC warp between CPUs, turning off TSC clock.
[    0.030000] tsc: Marking TSC unstable due to check_tsc_sync_source failed

I guess TSCs are not starting at the same moment on all boards.

You definitely need ucode on those too:

[  113.392460] microcode: CPU0: patch_level=0x00000000

That's just crazy, hahahah.

Thanks.

-- 
Regards/Gruss,
    Boris.
