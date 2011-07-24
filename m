Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab1GXQNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 12:13:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:51076 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1GXQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 12:13:40 -0400
Date: Sun, 24 Jul 2011 18:13:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: [patch 3/3] x86: cache_info: Kill the atomic allocation in
 amd_init_l3_cache()
In-Reply-To: <20110724102734.GA17099@liondog.tnic>
Message-ID: <alpine.LFD.2.02.1107241812590.3136@ionos>
References: <20110723212603.517924252@linutronix.de> <20110723212626.688229918@linutronix.de> <20110724102734.GA17099@liondog.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011, Borislav Petkov wrote:
> On Sun, Jul 24, 2011 at 09:46:09AM -0000, Thomas Gleixner wrote:
> >  
> >  	/* only for L3, and not in virtualized environments */
> > -	if (index < 3 || amd_nb_num() == 0)
> > +	if (index < 3)
> >  		return;
> 
> AFAICT, we still need the "amd_nb_num() == 0" check for xen because it
> doesn't export NB PCI devices to the guest, see f2b20e41...
> 
> >  
> > -	/*
> > -	 * Strictly speaking, the amount in @size below is leaked since it is
> > -	 * never freed but this is done only on shutdown so it doesn't matter.
> > -	 */
> > -	if (!l3_caches) {
> > -		int size = amd_nb_num() * sizeof(struct amd_l3_cache);
> > -
> > -		l3_caches = kzalloc(size, GFP_ATOMIC);
> > -		if (!l3_caches)
> > -			return;
> > -	}
> > -
> >  	node = amd_get_nb_id(smp_processor_id());
> > -
> > -	if (!l3_caches[node].nb) {
> > -		l3_caches[node].nb = node_to_amd_nb(node);
> > -		amd_calc_l3_indices(&l3_caches[node]);
> > -	}
> > -
> > -	this_leaf->l3 = &l3_caches[node];
> > +	this_leaf->nb = node_to_amd_nb(node);
> 
> although, on a second thought, node_to_amd_nb(node) should return NULL
> since the AMD NB caching code shouldnt've enumerated any NB devices and
> 
> > +	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
> > +		amd_calc_l3_indices(this_leaf->nb);
> 
> this check should fail. Hm.

Right, that was my thought.
 
> Let me test the patchset on Monday to verify there are no other subtle
> interactions I haven't thought of right now.

Thanks,

	tglx
