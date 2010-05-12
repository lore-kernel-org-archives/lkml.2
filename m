Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0ELXTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:19:22 -0400
Received: from kroah.org ([198.145.64.141]:45642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab0ELXTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:19:20 -0400
Date: Wed, 12 May 2010 16:19:06 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Jiri Benc <jbenc@suse.cz>,
       Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [stable] [113/197] x86, cacheinfo: Calculate L3 indices
Message-ID: <20100512231906.GB3588@kroah.com>
References: <20100422190917.467545308@kvm.kroah.org>
 <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz>
 <20100505180228.GC15804@aftab>
 <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz>
 <20100506081721.GA20616@aftab>
 <alpine.LNX.2.00.1005061532390.9849@pobox.suse.cz>
 <20100506141358.GB20994@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506141358.GB20994@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 04:13:58PM +0200, Borislav Petkov wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Thu, May 06, 2010 at 09:46:21AM -0400
> 
> > Well, we have
> > 
> > 	#ifdef CONFIG_K8_NB
> > 	static inline struct pci_dev *node_to_k8_nb_misc(int node)
> > 	{
> > 		return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
> > 	}
> > 	#else
> > 	static inline struct pci_dev *node_to_k8_nb_misc(int node)
> > 	{
> > 		return NULL;
> > 	}
> > 	#endif
> > 
> > So it legitimately returns NULL in two cases:
> > 
> > 	1) if someone passes too large node
> > 	2) if CONFIG_K8_NB is unset
> > 
> > 1) Either we assume that node will always be in the range (i.e. 
> > amd_get_nb_id() will never go crazy return anything bogus), and then we 
> > could just drop the test completely. Or we want to check for such the 
> > possibility, and then node_to_k8_nb_misc() is going to return NULL in such 
> > cases, and so we want to check for it.
> 
> No, we want to check it since K8_NB has many users - not only L3.
> 
> > 2) is now moot, as all three in-tree callers are now under proper ifdefs 
> > (CONFIG_CPU_SUP_AMD, which depends on CONFIG_K8_NB after your patch has 
> > been applied). So I believe we could remove it, right?
> 
> I don't think I understand "remove it" here. Which "it" you're referring to?
> 
> > Either way, current state seems inconsistent. So either we should add the 
> > return value check to amd_calc_l3_indices() as well, or remove all the 
> > NULL magic altogether, i.e. the (untested) patch below.
> > 
> > What do you think?
> 
> Take a look at 
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=f2b20e41407fccfcfacf927ff91ec888832a37af
> 
> This does
> 
> +       if (num_k8_northbridges == 0)
> +               return;
> 
> in amd_check_l3_disable().
> 
> So if K8_NB has failed initializing for some reason, we never go near
> the pci devs and the node_to_k8_nb_misc() calls since we effectively
> disable the L3 functionality.
> 
> Thus the NULL pointer checks you remove in the patch below are
> superfluous, I agree, and I have already removed those in my tree along
> with the other improvements/fixes I'm working on right now.

So, was there ever a patch applied that fixed the bug that Jiri found in
the stable kernels with this original patch that I could apply?

thanks,

greg k-h
