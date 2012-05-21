Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2EUQA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:00:59 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:39656 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383Ab2EUQA4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:00:56 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zzc89bh936eK146fI1432N98dKzz1202hzzz2dh668h839h93fhd25hf0ah)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M4DR4I-02-IKS-02
X-M-MSG: 
Date: Mon, 21 May 2012 18:00:41 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120521160041.GJ3334@aftab.osrc.amd.com>
References: <4FB64D5B.1030301@redhat.com>
 <20120518140521.GM20215@aftab.osrc.amd.com>
 <4FB65D52.9060108@redhat.com>
 <20120518164014.GX20215@aftab.osrc.amd.com>
 <4FB6866E.7090503@redhat.com>
 <20120518185258.GE20215@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com>
 <20120518211211.GA26464@aftab.osrc.amd.com>
 <20120519092618.GC29991@aftab.osrc.amd.com>
 <4FBA5F59.5000604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4FBA5F59.5000604@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 12:29:29PM -0300, Mauro Carvalho Chehab wrote:
> Em 19-05-2012 06:26, Borislav Petkov escreveu:
> > On Fri, May 18, 2012 at 11:12:11PM +0200, Borislav Petkov wrote:
> >> On Fri, May 18, 2012 at 07:10:42PM +0000, Luck, Tony wrote:
> >>>> That's why _each_ _driver_ will have its format and the userspace tools
> >>>> parsing it will know about it!
> >>>
> >>> Sounds like a full employment program for parser writers.
> >>>
> >>> There are some interesting fields that should be common to all
> >>> drivers ... so have twenty parsers that can handle:
> >>>
> >>> 	paddr: 0x1234
> >>> 	PADDR: 0x1234
> >>> 	Paddr = 0x1234
> >>> 	Phys = 1234
> >>> 	addr: 0x1234
> >>> 	Address: 0x000000001234
> >>>
> >>> looks like a lot of make-work ... when the OS can standardize in the ABI
> >>> that there is a 64-bit binary value that is the physical address of the
> >>> error (and another 64-bit mask saying which, if any, bits are valid).
> 
> The EDAC API works with the address/address mask as 3 values: address page,
> address offset inside the page and grain.
> 
> The values for address page/offset/grain and syndrome are mandatory on the EDAC
> error calls. Drivers that can't obtain that fill with zero. EDAC prints those
> values via the current API.
> 
> So, passing those values for the tracepoint makes sense.
> 
> In order to use a cleaner API, we may add a flags bitfield there, and add a few
> flags to mark if the address (page, offset, grain) is valid and if the syndrome
> is valid.

This is exactly the issue - we don't want to overcomplicate the
tracepoint! Simply output the single address value and userspace can cut
and split and paste it however it wants.

<snip some bullshit which I'm tired of addressing everytime>

> >> For the record, I very much like this reasoning :).
> > 
> > On a second thought, filtering out the globally valid fields for all
> > drivers might require a lot of careful driver auditing.
> 
> If you want to explode the driver details, then yes, but the address and
> syndrome are part of the EDAC internal ABI.
>
> Most drivers are capable of getting address and syndrome, for CE.
> For UE, syndrome is generally not calculated.
> 
> Anyway, on _all_ internal ABI calls, when syndrome or address aren't
> calculated, the drivers pass a value of 0 for them.
> 
> So, it is easy to add a logic inside the code that will rise a flag to
> indicate userspace when those fields are filled or not. All the EDAC
> core needs to do is to check if the value is 0 or not.

No, we're not going to do that! Adding a bit about the validity of a bit
is wrong design and is screaming B0RKED.

We're going to have single fields for EDAC-global valid values and leave
the driver-specific stuff lumped in one char * string.

Then, if a driver cannot specify sindrome or whatever, it simply DOESN'T
PUT IT IN THE STRING instead of adding validity bits.

[ … ]

> > Which is basically what I'm suggesting for a couple of days now :-)
> > 
> >        TP_PROTO(const unsigned int err_type,
> >                 const unsigned int mc_index,
> >                 const char *error_msg,
> >                 const char *label,
> >                 const char *location,
> >                 const char *detail)
> >
> > and I'm really not sure about err_type - this is an edac-specific define
> > and it means nothing outside the kernel so its string representation
> > could very well could be merged with error_msg and we can drop the ( ? :
> > ) ugliness in the tracepoint definition itself.
> 
> All error management systems use a mandatory field for the error severity.

... I'm pretty sure the defines you're exporting are not the same as
your error management systems require. So some kind of mapping is
still needed. Which shows that you're going to need to massage that
information in userspace after all.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

