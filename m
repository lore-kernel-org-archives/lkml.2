Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0JYVvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:51:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36985 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab0JYVvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:51:37 -0400
Date: Mon, 25 Oct 2010 23:51:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025215132.GA23427@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Borislav Petkov <petkovbb@googlemail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
 <20101025092557.GA11544@elte.hu>
 <AANLkTi=2SVT1M+nDZUB7EB05jh+tsuKcew_t66QORrwb@mail.gmail.com>
 <20101025202344.GC13652@liondog.tnic>
 <AANLkTi=DEmss+3uX_5uw=VJDY9+cFPayjQkCQHa+r+Ye@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=DEmss+3uX_5uw=VJDY9+cFPayjQkCQHa+r+Ye@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 02:23:12PM -0700, Tony Luck wrote:
> On Mon, Oct 25, 2010 at 1:23 PM, Borislav Petkov <bp@alien8.de> wrote:
> 
> > You may be right but what we actually want is a consistent RAS
> > infrastructure. Didn't you point out at the last edac meeting in Boston
> > that concerning RAS Linux were in the stone ages? (at least this is what
> > I remember reading).
> 
> That meeting was in San Francisco - but your recollection is correct.
> Right now we have ways to count errors, and to attribute them to
> specific hardware components (if we are lucky). This is only the
> beginning of the feature set that is needed to be "advanced RAS".

Yep.

> > What we should do is put all that post-system-reset error info, ECC
> > errors mapping to DRAM devices, L3 cache index manipulation based on
> > excessive errors - you name it - together and stick it in ras/ or
> > drivers/ras or whatever. And all with a nice and easy to use userspace
> > tool on top.
> 
> This is what we should be working towards.  I don't think we have
> a clear picture of what that high level infrastructure looks like. It
> needs to be very flexible to take input from all sorts of platform
> specific "driver" code that collects data.  The "perf events"
> mechanism looks plausible as a transport mechanism for
> reporting corrected (or otherwise non-fatal) events.

Also agreed.

> But the errors that didn't kill the system are only part of the RAS
> picture.

Concerning fatal errors, take a look at drivers/edac/mce_amd.(c|h)¹ -
this is not in arch/x86/ and still decodes MCEs in the kernel. And it
works fine - it even helped in several cases where people simply read
their serial console/dmesg and didn't have to collect it first and run
it through some tool to understand which functional unit in the CPU is
mchecking.

And I have an error injection module which can inject MCEs using 2
/sysfs files only. It is software injection only for now but still, you
can even inject in the shell.

So I think having RAS decoupled from x86 proper could work but it has to
be done smart. In the example above, I've hooked into the machine check
notifier chain. And yes, this is just an example but you get the idea
and where we want to go.

> > Now it looks like a wart on arch/x86/ which truly doesn't belong there.
> > And I don't buy all that crap that it can't be done right.
> 
> Of course it is a wart ... look up ACPI in any dictionary and you'll
> find a picture of a stereotypical Halloween witch :-)

LOL. Can I have the ACPI witch on a t-shirt please?

> I don't see other architectures lining up to support ACPI ... but
> we shouldn't just ignore it in x86. The APEI pieces that were added
> to ACPI 4.0 have some interesting and useful features.

Yeah, I like the error info after system reset thing using nvram.
This might make a lot of sense with certain critical errors where we
syncflood the ht links to prevent corrupted data propagation.

> Most of them are already implemented on shipping platforms because
> the APEI bits were simply documenting WHEA (Windows Hardware Error
> Architecture) features. Look for this stuff in dmesg:
>
> ACPI: HEST 000000007fb1c000 000A8 (v01 INTEL    SFC4UR 00000001 INTL 00000001)
> ACPI: BERT 000000007fb1b000 00030 (v01 INTEL    SFC4UR 00000001 INTL 00000001)
> ACPI: ERST 000000007fb1a000 00230 (v01 INTEL    SFC4UR 00000001 INTL 00000001)
> ACPI: EINJ 000000007fb19000 00130 (v01 INTEL    SFC4UR 00000001 INTL 00000001)

Yeah, I'm not saying we shouldn't have those - I'm just saying that we
should think up a good infrastructure design first and hook them into it
so that users can have the highest benefit.

And then have a single tool which talks to the high level interface and
all different arches implement whatever makes sense for them. Basically
what you said above about the flexible high level infrastructure.

Thanks.

¹in current git, in 2.6.36 the files were called edac_mce_amd(c|h).

-- 
Regards/Gruss,
    Boris.
