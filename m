Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1DLU3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:29:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40254 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab1DLU3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:29:00 -0400
Date: Tue, 12 Apr 2011 22:28:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>
Subject: Re: [PATCH]: mce: don't print "human readable" message for
 corrected errors
Message-ID: <20110412202854.GA32200@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Prarit Bhargava <prarit@redhat.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dzickus@redhat.com" <dzickus@redhat.com>,
	"mstowe@redhat.com" <mstowe@redhat.com>,
	"dnelson@redhat.com" <dnelson@redhat.com>
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
 <20110412185842.GB9891@liondog.tnic>
 <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
 <4DA4B2EA.5050303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DA4B2EA.5050303@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 04:15:38PM -0400, Prarit Bhargava wrote:
> 
> > We are also setting TAINT_MACHINE_CHECK for corrected errors - perhaps
> > this made sense when systems were small and machine checks were rare and
> > scary.  But I think we need to start working with the reality that
> > corrected errors are normal events.
> >
> >   
> 
> It still makes sense for small lt 1TB systems, IMO.  But ... maybe a
> flag of some sort is necessary to stop the TAINTing for systems larger
> than that.  The CEs may point to something going wrong on a system.  CEs
> in theory become UCEs eventually, right?
> 
> From a OS point of view, we would like to know that there is flaky HW on
> the system.
> 
> /me knows this is going to turn into a PFA discussion in 4 ... 3 ... 2
> ....   ;)

Yeah, there's the TAINT thing too, good point Tony. Well, we definitely
don't want to get tainted for correctable errors - they're too "normal"
to do so, IMHO.

I'm thinking remove the TAINT for CEs and don't call the default
notifier if it is the only notifier call registered. Maybe something like

	if (num_notifiers(&x86_mce_decoder_chain) > 1)
		atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);

or since the notifiers are priority sorted, don't call notifiers with -1
prio.

Or something to that effect.

-- 
Regards/Gruss,
    Boris.
