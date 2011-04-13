Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1DMO1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:27:11 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34316 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1DMO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:27:10 -0400
Date: Wed, 13 Apr 2011 16:26:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH 2/3] x86, MCE: Drop default decoding notifier
Message-ID: <20110413142648.GB2791@aftab>
References: <20110413132409.GB1900@gere.osrc.amd.com>
 <1302701810-2471-2-git-send-email-bp@amd64.org>
 <4DA5ACB2.1070505@redhat.com>
 <20110413141829.GE1987@aftab>
 <4DA5B1B1.5090905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5B1B1.5090905@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:22:41AM -0400, Prarit Bhargava wrote:
> 
> 
> On 04/13/2011 10:18 AM, Borislav Petkov wrote:
> > On Wed, Apr 13, 2011 at 10:01:22AM -0400, Prarit Bhargava wrote:
> >   
> >> On 04/13/2011 09:36 AM, Borislav Petkov wrote:
> >>     
> >>> From: Borislav Petkov <borislav.petkov@amd.com>
> >>>
> >>> The default notifier doesn't make a lot of sense to call in the
> >>> correctable errors case. Drop it and emit the mcelog decoding hint only
> >>> in the uncorrectable errors case and when no notifier is registered.
> >>>
> >>> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> >>> ---
> >>>  arch/x86/include/asm/mce.h       |    4 ++--
> >>>  arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++-----------------
> >>>  2 files changed, 11 insertions(+), 19 deletions(-)
> >>>
> >>>       
> >>   
> >>     
> >>> +extern atomic_t mce_decoders;
> >>> +
> >>>       
> >> Boris,
> >>
> >> I don't think we need to do this.  I think we can use the existing notifier chain tools to do this check for us ... *untested and uncompiled* patch below.
> >>
> >>   	 * Print out human-readable details about the MCE error,
> >>     
> >>>  	 * (if the CPU has an implementation for that)
> >>>  	 */
> >>> -	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> >>> +	if (!atomic_read(&mce_decoders)) {
> >>> +		pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
> >>> +		pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' to decode.\n");
> >>>       
> >> I thought we didn't want these lines at all for CE errors?
> >>     
> > This is the UC only case - we call print_mce() before we panic.
> >   
> 
> .. right ... but we would still see nonsensical messages before the
> panic, which will confuse the end user.  IMO, dump the messages unless
> it's UC.  And we shouldn't print out the human readable message at all.

I'd still leave the "mcelog ... " line though as a hint.

> I'm installing F14 on  a system that is known to generate CEs @
> boot-time.  I'll test patches+latest upstream to here to see what happens...

Cool.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
