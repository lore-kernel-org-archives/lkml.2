Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab1D0ODn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:03:43 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52668 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab1D0ODi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:03:38 -0400
Date: Wed, 27 Apr 2011 16:03:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Message-ID: <20110427140307.GA1704@aftab>
References: <20110419171340.GE6640@elte.hu>
 <20110419173521.GA25374@aftab>
 <20110419174446.GA13616@elte.hu>
 <20110420102349.GB1361@aftab>
 <m1hb9mnmqs.fsf@fess.ebiederm.org>
 <20110426074238.GA22448@aftab>
 <m1y62wk9i8.fsf@fess.ebiederm.org>
 <20110426214755.GA28314@aftab>
 <m1oc3sir8n.fsf@fess.ebiederm.org>
 <987664A83D2D224EAE907B061CE93D5301C50FD34B@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301C50FD34B@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 07:44:35PM -0400, Luck, Tony wrote:
> > Sure.  Although any DIMM that is generating so many correctable errors
> > that you need to rate limit it in the kernel, won't likely to confine
> > itself to correctable errors.
> >
> > Still it can happen that things are so bad that you do need to rate
> > limit it in the kernel.  Still with those you start wondering "How did
> > this machine boot?"  So printk_ratelimit sounds like a fine idea.
> 
> 
> Perhaps we really want thresholds rather than rate limits (for corrected
> errors).  One corrected error shouldn't cause any but the most paranoid
> to worry.  A couple of errors from the same DIMM close together might be
> some cause for concern, but could just be happenstance. Enough errors that
> rate limiting looks useful, and you are into "something needs to be done"
> territory.

Right, but for thresholding you need to know to which DIMM the error
address belongs. And this is not trivial in all cases. It looks like we
need this error reporting thing dynamic:

As a sane default, we want to dump some _sensible_ info to syslog about
some errors happening. Then, all in-kernel decoding modules can enrich
that error info with more specific details. Those two reporting modes
should be ratelimited since doing thresholding in kernel could be tricky
and taking up precious resources.

Finally, you have the userspace daemon which datacenter people or
Google with small root partitions could use, which sends that info to a
centralized location instead of someone collecting it from each node. In
that case, no info goes out to syslog but is eaten up by the RAS daemon
which runs on every machine. And in userspace you can do all the cool
thresholding, rate limiting, policy applying, etc, your heart desires.

Makes sense?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
