Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1DMRh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:37:28 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54906 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1DMRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:37:26 -0400
Date: Wed, 13 Apr 2011 19:37:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH -v2] x86, MCE: Drop default decoding notifier
Message-ID: <20110413173705.GJ2791@aftab>
References: <20110413132409.GB1900@gere.osrc.amd.com>
 <1302701810-2471-2-git-send-email-bp@amd64.org>
 <4DA5ACB2.1070505@redhat.com>
 <20110413141829.GE1987@aftab>
 <4DA5B1B1.5090905@redhat.com>
 <20110413142648.GB2791@aftab>
 <20110413143642.GC2791@aftab>
 <4DA5D6CC.9090500@redhat.com>
 <4DA5D9FB.1010503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5D9FB.1010503@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 01:14:35PM -0400, Prarit Bhargava wrote:
> 
> 
> On 04/13/2011 01:01 PM, Prarit Bhargava wrote:
> >   
> >> @@ -239,7 +227,9 @@ static void print_mce(struct mce *m)
> >>  	 * Print out human-readable details about the MCE error,
> >>  	 * (if the CPU has an implementation for that)
> >>  	 */
> >> -	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> >> +	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> >> +	if (ret != NOTIFY_STOP)
> >> +		pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' to decode.\n");
> >>  }
> >>   
> >>     
> > Borislav,
> >
> >   
> 
> Oops.  Let me *carefully* rephrase that so it is clear what I'm
> complaining about.
> 
> > I still think you need the check for UC here.  When an UC occurs and
> > mce_panic() is called the output will include:
> >
> > [Hardware Error]:  Run the above through 'mcelog --ascii' to decode.
> >
> > potentially many, many times
> 
> for _all_ unreported *correctable* errors.
> 
> > .  The problem still is that there is no
> > output to decode (in the default case).
> >
> >   
> 
> ie) (sorry for the cut-and-paste)
> 
>         /* First print corrected ones that are still unlogged */
>         for (i = 0; i < MCE_LOG_LEN; i++) {
>                 struct mce *m = &mcelog.entry[i];
>                 if (!(m->status & MCI_STATUS_VAL))
>                         continue;
>                 if (!(m->status & MCI_STATUS_UC)) {
>                         print_mce(m);
>                         if (!apei_err)
>                                 apei_err = apei_write_mce(m);
>                 }
>         }
> 
> will potentially result in many bogus messages during a time at which we
> definitely do not want bogus messages.

I don't think that this is a problem. This is on the panic path and it
is supposed to dump only the _unreported_ CE MCEs queued in the mcelog
which can contain 32 MCEs max.

In the worst case, we will report 32 CEs before panicking. For that case
we either do printk_once as Tony suggested or we ratelimit it. I'll
update the patch.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
