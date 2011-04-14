Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab1DNHlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:41:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51678 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1DNHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:41:48 -0400
Date: Thu, 14 Apr 2011 09:41:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [Stable-review] [56/74] x86, microcode, AMD: Extend ucode size
 verification
Message-ID: <20110414074125.GA8575@aftab>
References: <20110413155148.974006996@clark.kroah.org>
 <1302752223.5282.674.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302752223.5282.674.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

I appreciate the review, thanks.

On Wed, Apr 13, 2011 at 11:37:03PM -0400, Ben Hutchings wrote:
> On Wed, 2011-04-13 at 08:51 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > 
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Upstream commit: 44d60c0f5c58c2168f31df9a481761451840eb54
> > 
> > The different families have a different max size for the ucode patch,
> > adjust size checking to the family we're running on. Also, do not
> > vzalloc the max size of the ucode but only the actual size that is
> > passed on from the firmware loader.
> [...]
> > @@ -125,6 +124,37 @@ static int get_matching_microcode(int cp
> >  	return 1;
> >  }
> >  
> > +static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
> > +{
> > +	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > +	unsigned int max_size, actual_size;
> > +
> > +#define F1XH_MPB_MAX_SIZE 2048
> > +#define F14H_MPB_MAX_SIZE 1824
> > +#define F15H_MPB_MAX_SIZE 4096
> > +
> > +	switch (c->x86) {
> > +	case 0x14:
> > +		max_size = F14H_MPB_MAX_SIZE;
> > +		break;
> > +	case 0x15:
> > +		max_size = F15H_MPB_MAX_SIZE;
> > +		break;
> > +	default:
> > +		max_size = F1XH_MPB_MAX_SIZE;
> > +		break;
> > +	}
> > +
> > +	actual_size = buf[4] + (buf[5] << 8);
> > +
> > +	if (actual_size > size || actual_size > max_size) {
> 
> Surely:
> 
> 	if (actual_size + UCODE_CONTAINER_SECTION_HDR > size || ...

Well, not really because the UCODE_CONTAINER_SECTION_HDR is just 8 bytes
of patch header before each ucode patch and we don't copy it. So the
first part of the check is to see whether the ucode patch we're looking
at is incomplete and the ucode file is truncated.

That's why we skip the 8 bytes when we do get_ucode_data() later.

> > +		pr_err("section size mismatch\n");
> > +		return 0;
> > +	}
> > +
> > +	return actual_size;
> > +}
> > +
> >  static int apply_microcode_amd(int cpu)
> >  {
> >  	u32 rev, dummy;
> > @@ -164,11 +194,11 @@ static int get_ucode_data(void *to, cons
> >  }
> >  
> >  static void *
> > -get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
> > +get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
> >  {
> > -	unsigned int total_size;
> > +	unsigned int actual_size = 0;
> >  	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
> > -	void *mc;
> > +	void *mc = NULL;
> 
> Dummy initialisations mean the compiler won't warn if you fail to
> properly initialise them later.

I don't see why that matters here since we write into it the vmalloc()
allocation result and check its validity after the vmalloc too.

> 
> >  	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
> >  		return NULL;
> > @@ -179,23 +209,18 @@ get_next_ucode(const u8 *buf, unsigned i
> >  		return NULL;
> >  	}
> >  
> > -	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
> > +	actual_size = verify_ucode_size(cpu, buf, size);
> > +	if (!actual_size)
> > +		return NULL;
> >  
> > -	if (total_size > size || total_size > UCODE_MAX_SIZE) {
> > -		printk(KERN_ERR "microcode: error: size mismatch\n");
> > +	mc = vmalloc(actual_size);
> > +	if (!mc)
> >  		return NULL;
> > -	}
> >  
> > -	mc = vmalloc(UCODE_MAX_SIZE);
> > -	if (mc) {
> > -		memset(mc, 0, UCODE_MAX_SIZE);
> > -		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
> > -				   total_size)) {
> > -			vfree(mc);
> > -			mc = NULL;
> > -		} else
> > -			*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
> > -	}
> > +	memset(mc, 0, actual_size);
> > +	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
> [...]
> 
> So I wondered why the result of get_ucode_data() is no longer being
> checked.  And the answer is: because it's a trivial wrapper for
> memcpy(), but with a 'return 0'.  So the memset() is redundant.

Fair enough. Upstream was converted to vzalloc some time ago so it
should be converted back to vmalloc since we overwrite the buffer right
afterwards and we could save us the __GFP_ZERO memset :)

> Good thing nothing important depends on this validation, oh wait...

Oh wait, please don't tell me that you really think that the CPU relies
completely on software to do its ucode validation and accepts the "good"
ucode binary patch blindly...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
