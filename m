Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1DMHOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:14:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52741 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab1DMHOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:14:38 -0400
Date: Wed, 13 Apr 2011 09:14:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Russ Anderson <rja@sgi.com>
Cc: Prarit Bhargava <prarit@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>, rja@americas.sgi.com
Subject: Re: [PATCH]: mce: don't print "human readable" message for
 corrected errors
Message-ID: <20110413071432.GA22773@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Russ Anderson <rja@sgi.com>, Prarit Bhargava <prarit@redhat.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dzickus@redhat.com" <dzickus@redhat.com>,
	"mstowe@redhat.com" <mstowe@redhat.com>,
	"dnelson@redhat.com" <dnelson@redhat.com>, rja@americas.sgi.com
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
 <20110412185842.GB9891@liondog.tnic>
 <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
 <4DA4B2EA.5050303@redhat.com>
 <20110412202854.GA32200@liondog.tnic>
 <20110413030033.GB31652@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110413030033.GB31652@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:00:34PM -0500, Russ Anderson wrote:
> > I'm thinking remove the TAINT for CEs and don't call the default
> > notifier if it is the only notifier call registered. Maybe something like
> > 
> > 	if (num_notifiers(&x86_mce_decoder_chain) > 1)
> > 		atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
> > 
> > or since the notifiers are priority sorted, don't call notifiers with -1
> > prio.
> > 
> > Or something to that effect.
> 
> What is the point of having a default notifier if it doesn't get called?

Well, the thing is, we call the same notifier chain in the event of
both correctable and uncorrectable errors. But to be honest, if we shut
up the default pr_emerg() calls with "no human readable.." in the CEs'
case, then we don't really need it in the UEs' case either, IMO.

The only half-way sensible info we print is

	"Run the message through 'mcelog --ascii' to decode.\n"

on UE because there we print MCA regs to the console where mcelog can
actually decode them, and this should be a hint to the user to do so.

In the CEs case, no such info comes out and there's no need for those
printks to flood the logs.

So maybe we could drop the default notifier and do in print_mce():

	if (notifier_chain_empty(&x86_mce_decoder_chain))
		pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");

I think this could work, let me cook up something.

> Any consideration of adding thresholding (ie only log the first X number
> of corrected errors) as is done on IA64?  (see arch/ia64/kernel/mca.c)

Yep, this is in the works with a RAS daemon that should collect all
error info in userspace and do all policies there. We might even drop
the spitting in the system logs almost completely and I know this'll
make a lot of people happy :).

-- 
Regards/Gruss,
    Boris.
