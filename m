Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab1DZW0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:26:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43510 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab1DZW0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:26:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
References: <1303135222-17118-2-git-send-email-bp@amd64.org>
	<20110419171340.GE6640@elte.hu> <20110419173521.GA25374@aftab>
	<20110419174446.GA13616@elte.hu> <20110420102349.GB1361@aftab>
	<m1hb9mnmqs.fsf@fess.ebiederm.org> <20110426074238.GA22448@aftab>
	<m1y62wk9i8.fsf@fess.ebiederm.org> <20110426214755.GA28314@aftab>
Date: Tue, 26 Apr 2011 15:26:32 -0700
In-Reply-To: <20110426214755.GA28314@aftab> (Borislav Petkov's message of
	"Tue, 26 Apr 2011 23:47:55 +0200")
Message-ID: <m1oc3sir8n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/MBaXPtYZnDoiAX6/Mzp+OVwu2iR8x3jA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@amd64.org> writes:

> On Tue, Apr 26, 2011 at 05:06:39PM -0400, Eric W. Biederman wrote:
>
> Ha!
>
> I'm working exactly in the opposite direction actually - drop mcelog and
> make RAS much more user friendly. As a first step, this is why we have
> all that MCE decoding code for AMD hw and when you get an error, you
> can't miss it:

I have no problem with having mcelog go away.

When we are on a system where we can't decode the mce, (aka the hardware
is newer than the kernel) we need some kind of sensible fallback that
prints something into syslog even if we don't have the full decode.

> Apr 20 21:08:24 kepek kernel: [  300.816122] [Hardware Error]: MC4_STATUS[Over|CE|MiscV|-|AddrV|CECC]: 0xdc00c000c6080a13
> Apr 20 21:08:24 kepek kernel: [  300.825156] [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
> Apr 20 21:08:24 kepek kernel: [  300.825167] EDAC amd64 MC0: CE ERROR_ADDRESS= 0x4171fe380
> Apr 20 21:08:24 kepek kernel: [  300.825257] EDAC MC0: CE page 0x4171fe, offset 0x380, grain 0, syndrome 0xc601, row 3, channel 0, label "": amd64_
> edac
>
> or this:
>
> Apr 15 16:54:17 kepek kernel: [72187.027059] [Hardware Error]: MC0_STATUS[-|UE|-|-|AddrV|UECC]: 0xb400210000010016
> Apr 15 16:54:17 kepek kernel: [72187.027059] [Hardware Error]: Data Cache Error: L2 TLB multimatch.
> Apr 15 16:54:17 kepek kernel: [72187.027059] [Hardware Error]: cache level: L2, tx: DATA
>
>
> There's also this RAS daemon I'm hacking on which uses perf to carry
> error information to userspace and do more than reporting it. For
> example, server farm guys don't want to scan syslog for every CECC error
> but rather have it collected somewhere on one machine, maybe over the
> network, etc, etc.

Collected somewhere on one machine sounds remarkably like syslog.

I expect what the big server farm guys object to most is errors that
are hard to parse and hard to deal with in automation.  And I can't
say that I blame them.

> So now is the time to speak up and let me know how you would like to get
> the error reported? In general, what should be done differently in Linux
> wrt to RAS.

>> Which is why I object to the removal of the one printk that told
>> me something was broken on my machine.
>
> I dunno, maybe it's time we moved the MCE decoding functionality which
> is shared by most of x86 into core code. Ingo, Peter, Thomas, what do
> you guys think?
>
> This'll at least put something in the logs that is sensible instead
> of useless strings which tell the users what to do next. Also, we can
> ratelimit it so that DIMMs generating too many CECCs don't flood them
> too much. Hmm...

Sure.  Although any DIMM that is generating so many correctable errors
that you need to rate limit it in the kernel, won't likely to confine
itself to correctable errors.

Still it can happen that things are so bad that you do need to rate
limit it in the kernel.  Still with those you start wondering "How did
this machine boot?"  So printk_ratelimit sounds like a fine idea.

In the casual use situation where I have not yet bothered on my small
number of machines to set up sophisticated logging infrastructure
I just want something that adds an annoying message to syslog so
people who are logged in can say what was that, and downtime can be
scheduled.

Eric
