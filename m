Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab1DNPo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:44:28 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:32859 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1DNPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:44:27 -0400
Date: Thu, 14 Apr 2011 17:44:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH -v3] x86, MCE: Drop the default decoding notifier
Message-ID: <20110414154405.GK10080@aftab>
References: <4DA5B1B1.5090905@redhat.com>
 <20110413142648.GB2791@aftab>
 <20110413143642.GC2791@aftab>
 <4DA5D6CC.9090500@redhat.com>
 <4DA5D9FB.1010503@redhat.com>
 <20110413173705.GJ2791@aftab>
 <20110414150036.GG10080@aftab>
 <4DA70D0B.3080407@redhat.com>
 <20110414151621.GI10080@aftab>
 <4DA71158.6020302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA71158.6020302@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:23:04AM -0400, Prarit Bhargava wrote:
> Oops ... I may have confused you because what I did was subtle.  I
> really should have explicitly pointed out what I did.  Sorry, my bad.
> 
> From my patch (sorry for the cut-and-paste):
> 
> @@ -239,7 +227,10 @@ static void print_mce(struct mce *m)
>          * Print out human-readable details about the MCE error,
>          * (if the CPU has an implementation for that)
>          */
> -       atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> +       ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> +       if (ret != NOTIFY_STOP && (m->status & MCI_STATUS_UC))
> +               pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' "
> +                        "to decode.\n");
>  }
>  
> This, of course, only outputs during UCs.
> 
> and
> 
> @@ -289,6 +280,8 @@ static void mce_panic(char *msg, struct mce *final,
> char *exp)
>                         continue;
>                 if (!(m->status & MCI_STATUS_UC)) {
>                         print_mce(m);
> +                       printk_once(KERN_EMERG HW_ERR "MCE Corrected
> Error(s) "
> +                                   "detected.");
>                         if (!apei_err)
>                                 apei_err = apei_write_mce(m);
>                 }
> 
> so we'll print "MCE Corrected Error(s)" _once_ if we go through this
> path.  Since there is no data to decode with mcelog, a nice little one
> time message is probably the way to go :).

Ok, first of all, see the print_mce(m) call above? Yes, we're dumping
full CE MCE info in this case because they were unlogged and as such,
that info can be decoded.

But this whole point is moot since those errors can be only 32 max _and_
on the _panic_ path. And I don't think this path matters because it is
_very_ seldom. I bet you don't hit it on any of your machines.

And we don't want to fix that - we want to fix the case with the
occasional CE MCEs which get detected in the polling path but none of
their MCA regs get dumped for decoding so the decoding hint there is
out of place. And we fixed that at least partially so that it doesn't
flood the logs. If you're not fine with the default ratelimit of 10 msgs
per 5 seconds we can always raise the ratelimit but tweaking an almost
hypothetical case is just not worth it.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
