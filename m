Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1DNITT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:19:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38058 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1DNITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:19:17 -0400
Date: Thu, 14 Apr 2011 10:18:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [Stable-review] [56/74] x86, microcode, AMD: Extend ucode size
 verification
Message-ID: <20110414081854.GA9238@aftab>
References: <20110413155148.974006996@clark.kroah.org>
 <1302752223.5282.674.camel@localhost>
 <20110414074125.GA8575@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414074125.GA8575@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 03:41:25AM -0400, Borislav Petkov wrote:

[..]

> > > +static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
> > > +{
> > > +	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > > +	unsigned int max_size, actual_size;
> > > +
> > > +#define F1XH_MPB_MAX_SIZE 2048
> > > +#define F14H_MPB_MAX_SIZE 1824
> > > +#define F15H_MPB_MAX_SIZE 4096
> > > +
> > > +	switch (c->x86) {
> > > +	case 0x14:
> > > +		max_size = F14H_MPB_MAX_SIZE;
> > > +		break;
> > > +	case 0x15:
> > > +		max_size = F15H_MPB_MAX_SIZE;
> > > +		break;
> > > +	default:
> > > +		max_size = F1XH_MPB_MAX_SIZE;
> > > +		break;
> > > +	}
> > > +
> > > +	actual_size = buf[4] + (buf[5] << 8);
> > > +
> > > +	if (actual_size > size || actual_size > max_size) {
> > 
> > Surely:
> > 
> > 	if (actual_size + UCODE_CONTAINER_SECTION_HDR > size || ...
> 
> Well, not really because the UCODE_CONTAINER_SECTION_HDR is just 8 bytes
> of patch header before each ucode patch and we don't copy it. So the
> first part of the check is to see whether the ucode patch we're looking
> at is incomplete and the ucode file is truncated.
> 
> That's why we skip the 8 bytes when we do get_ucode_data() later.

Actually, scratch that. I think you're right - this is a bug in the
original code since the check there ignored those 8 bytes too:

        total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));

        printk(KERN_DEBUG "microcode: size %u, total_size %u\n",
               size, total_size);

        if (total_size > size || total_size > UCODE_MAX_SIZE) {
                printk(KERN_ERR "microcode: error: size mismatch\n");
                return NULL;
        }

Btw, while staring at it, I've found another discrepancy that needs to
be fixed, I'll whip up a patch soon.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
