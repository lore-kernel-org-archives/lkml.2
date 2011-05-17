Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1EQTE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:04:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab1EQTE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:04:57 -0400
Date: Tue, 17 May 2011 21:04:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: UV uv_tlb.c cleanup
Message-ID: <20110517190445.GB29574@elte.hu>
References: <E1QML7f-00070E-36@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QML7f-00070E-36@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, looks like some good first steps. I have a few more nits below, of things 
that occur still quite widely in the UV driver files:

* Cliff Wickman <cpw@sgi.com> wrote:

> +static void write_global_mmr_activation(int pnode, unsigned long mmr_image)
> +{
> +	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_ACTIVATION_CONTROL,
> +								mmr_image);

Please *never* break a line at the end line that just because checkpatch.pl 
complains.

Instead try to make uv_write_global_mmr64() shorter, it's used in quite a few 
places!

Something like:

	write_gmmr8()
	write_gmmr64()
	write_lmmr64()

would still be pretty obvious and is a lot shorter! I applied two tricks:

 - The 'MMR' is an UV specific term of art *anyway* which you have to know if
   you are reading this code, so making it 'LMMR' for local and 'GMMR' for 
   global MMRs is an obvious extension to the abbreviation you are using already.

 - You do not have to prefix everything with uv_() !! Only APIs you really need
   to export to other code like the infamous is_uv_system() flag. These 
   functions are used in files named uv_something.c anyway, and 'MMR' is an UV
   concept, so the uv_ prefix was absolutely unnecessary screen bloat.

Please propagate the uv_ removal to all other places - there's a lot of 
functions that have it needlessly.

Likewise, you can propagate these concepts to the naming of the other MMR 
handling functions as well - for example would turn into 
write_gmmr_activation() - which is nicer to read and type than 
write_global_mmr_activation().

I think with that and with your other cleanups you have already done the code 
will already be a lot more readable.

One more request, could you please make structure fields aligned vertically? 
I.e. use something like:

struct msg_desc {
	struct bau_payload_queue_entry	*msg;
	int				msg_slot;
	int				swack_slot;
	struct bau_payload_queue_entry	*va_queue_first;
	struct bau_payload_queue_entry	*va_queue_last;
};

Have a look at arch/x86/include/asm/processor.h for more examples.

Also, *please* notice and fix too long structure names like the 
bau_payload_queue_entry above. Commonly used names like that should be tightly 
named - so for example could it be 'struct bau_pq_entry'? If that's descriptive 
enough for you then it could be:

struct msg_desc {
	struct bau_pq_entry		*msg;
	int				msg_slot;
	int				swack_slot;
	struct bau_pq_entry		*va_queue_first;
	struct bau_pq_entry		*va_queue_last;
};

Also, what does the 'va_' prefix mean above? Virtual address? Why does 'msg' 
have no prefix?

Thanks,

	Ingo
