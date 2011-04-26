Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab1DZVs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:48:29 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50177 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab1DZVs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:48:27 -0400
Date: Tue, 26 Apr 2011 23:47:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Message-ID: <20110426214755.GA28314@aftab>
References: <1303135222-17118-2-git-send-email-bp@amd64.org>
 <20110419171340.GE6640@elte.hu>
 <20110419173521.GA25374@aftab>
 <20110419174446.GA13616@elte.hu>
 <20110420102349.GB1361@aftab>
 <m1hb9mnmqs.fsf@fess.ebiederm.org>
 <20110426074238.GA22448@aftab>
 <m1y62wk9i8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y62wk9i8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 05:06:39PM -0400, Eric W. Biederman wrote:
> Borislav Petkov <bp@amd64.org> writes:
> 
> > On Mon, Apr 25, 2011 at 03:40:11PM -0400, Eric W. Biederman wrote:
> >> > From: Borislav Petkov <borislav.petkov@amd.com>
> >> > Date: Wed, 13 Apr 2011 14:32:06 +0200
> >> > Subject: [PATCH -v2.1 2/2] x86, MCE: Drop the default decoding notifier
> >> >
> >> > The default notifier doesn't make a lot of sense to call in the
> >> > correctable errors case. Drop it and emit the mcelog decoding hint only
> >> > in the uncorrectable errors case and when no notifier is registered.
> >> > Also, limit issuing the "mcelog --ascii" message in the rare case when
> >> > we dump unreported CEs before panicking.
> >> >
> >> > While at it, remove unused old x86_mce_decode_callback from the
> >> > header.
> >> 
> >> Can we please print something if we please log something in the
> >> case of a correctable error, when we only report it via mcelog?
> >> 
> >> I have a stupid recent intel cpu here that hits that case and without
> >> the default x86_mce_decode_callback I wouldn't have even known that I am
> >> getting something like 50 correctable errors an hour on one of my
> >> machines.  In particular I am it hits so often I am seeing:
> >> "mce_notify_irq: 2 callbacks suppressed".  I need to get those dimms
> >> replaced soon because in a new product I simply can't imagine that many
> >> correctable errors.
> >
> > Isn't there a mcelog daemon or something that polls /dev/mcelog and
> > tells you about those DRAM ECCs in some log file where you're supposed
> > to look? :)
> 
> On fedora 14 there is a cron job that writes to /var/log/mcelog, and
> does not go through syslog.  But you have to be proactive and look
> there.  If the people who work on this code can't even remember
> where to look I can't imagine how anyone else can remember.

Ha!

I'm working exactly in the opposite direction actually - drop mcelog and
make RAS much more user friendly. As a first step, this is why we have
all that MCE decoding code for AMD hw and when you get an error, you
can't miss it:

Apr 20 21:08:24 kepek kernel: [  300.816122] [Hardware Error]: MC4_STATUS[Over|CE|MiscV|-|AddrV|CECC]: 0xdc00c000c6080a13
Apr 20 21:08:24 kepek kernel: [  300.825156] [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
Apr 20 21:08:24 kepek kernel: [  300.825167] EDAC amd64 MC0: CE ERROR_ADDRESS= 0x4171fe380
Apr 20 21:08:24 kepek kernel: [  300.825257] EDAC MC0: CE page 0x4171fe, offset 0x380, grain 0, syndrome 0xc601, row 3, channel 0, label "": amd64_
edac

or this:

Apr 15 16:54:17 kepek kernel: [72187.027059] [Hardware Error]: MC0_STATUS[-|UE|-|-|AddrV|UECC]: 0xb400210000010016
Apr 15 16:54:17 kepek kernel: [72187.027059] [Hardware Error]: Data Cache Error: L2 TLB multimatch.
Apr 15 16:54:17 kepek kernel: [72187.027059] [Hardware Error]: cache level: L2, tx: DATA


There's also this RAS daemon I'm hacking on which uses perf to carry
error information to userspace and do more than reporting it. For
example, server farm guys don't want to scan syslog for every CECC error
but rather have it collected somewhere on one machine, maybe over the
network, etc, etc.

So now is the time to speak up and let me know how you would like to get
the error reported? In general, what should be done differently in Linux
wrt to RAS.

> Which is why I object to the removal of the one printk that told
> me something was broken on my machine.

I dunno, maybe it's time we moved the MCE decoding functionality which
is shared by most of x86 into core code. Ingo, Peter, Thomas, what do
you guys think?

This'll at least put something in the logs that is sensible instead
of useless strings which tell the users what to do next. Also, we can
ratelimit it so that DIMMs generating too many CECCs don't flood them
too much. Hmm...

> So far from what I have seen /dev/mcelog and the userspace mcelog is
> over complicated and near useless.  It seems to focused around the
> notion that "This is not a software problem, please do not bug
> Andi Kleen about it"

;-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
