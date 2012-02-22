Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2BVNcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:32:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab2BVNco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:32:44 -0500
Message-ID: <4F44EE60.8030400@redhat.com>
Date: Wed, 22 Feb 2012 11:32:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com> <20120221141231.GA15515@aftab> <1329835698.25686.60.camel@gandalf.stny.rr.com> <20120221145943.GB15515@aftab> <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com> <20120222104324.GA26845@aftab> <4F44D948.3000205@redhat.com> <20120222122555.GD26845@aftab>
In-Reply-To: <20120222122555.GD26845@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-02-2012 10:25, Borislav Petkov escreveu:
> On Wed, Feb 22, 2012 at 10:02:16AM -0200, Mauro Carvalho Chehab wrote:
>> Using the same concept I've adopted for my EDAC patches, I would map the 
>> above into 3 fields:
>>
>> 	CPU instance = 64
>> 	error message = Instruction Cache Error: L1 TLB multimatch.
>> 	detail = cache level: L1, tx: INSN
>> 	(or, maybe, detail = [-|CE|MiscV|PCC|-|CECC] cache level: L1, tx: INSN)
> 
> No, this is not going to fly the moment you decide to dump MCi_ADDR
> because it is relevant for a certain types of errors:
> 
> [ 1121.970020] [Hardware Error]: CPU:64   MC2_STATUS[Over|CE|-|-|AddrV|CECC]: 0xd400400000000813
> [ 1121.979039] [Hardware Error]:  MC2_ADDR: 0xbabedeaddeadbeef
> [ 1121.979042] [Hardware Error]: Bus Unit Error: RD/ECC error in data read from NB.
> [ 1121.979047] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: RD, part-proc: SRC (no timeout)

This could be mapped as:

	CPU instance = 64
	error message = Bus Unit Error: RD/ECC error in data read from NB
	detail = [Over|CE|-|-|AddrV|CECC] cache level: L3/GEN, mem/io: MEM, mem-tx: RD, part-proc: SRC (no timeout) address: 0xbabedeaddeadbeef

> The whole decoded thing above is a string and the MCA registers are
> passed on into the trace, _in_ _addition_.

The MCA registers are also there on their own fields, so there's no need 
to also store them at the decoded string. Yet, they could be there at the
detail.

What I'm proposing is that the "error message" should contain the most relevant
information for the end user, while additional technical details would be at
detail.

That makes easy for a RAS daemon to store and group similar errors. Messing
all information inside one string would be very hard for it to parse.

> IOW, for each tracepoint, the format should be a string which is
> possibly empty and describes the error message additionally, and the
> remaining register attributes, one per field. Mapping the hw error
> scheme to some memory error format you've come up with is a bad idea and
> a no-no.

The "remaining register attributes" is a no-no: such concept would assume that
the remaining information is inside a MCA register (or inside a well-known group
of registers). This is not always true.

As I said several times, the memory error location, on Sandy Bridge, is not
stored on any register. The driver has to use the MCA error address as a starting
point, and navigate into a tree of about 200+ registers, in order to get the
DIMM channel, rank and slot. 

Passing the values of all those 200+ registers to userspace wouldn't make any sense,
as only a few is used to parse the error. What it makes sense is to pass the memory
location to userspace.

To make things worse, when the memory controller is at mirror mode, or at lockstep
mode, Sandy Bridge won't provide a single location. Instead, it will provide a
channel mask, meaning that one of the two DIMMs (or four DIMMs, if both modes are
enabled) is the root cause of the error.

The same also applies to FB-DIMM drivers.

So, the error location has to be either a string or up to 3 integers to represent
the memory location, plus a mask, in order to represent lockstep and mirror modes.

Using a string makes it easier.

So, in other words, I think that the _best_ way to represent an MCA type of error
is to use an event with the following prototype:

	TP_PROTO(const unsigned int error_severity,
		 const unsigned int error_type,
		 const unsigned int instance,
		 const char *error_msg,
		 const char *silkscreen_label,
		 const char *location,
		 const char *detail,
		 const char *driver_detail,
 		 const struct mce *m),

Where the above fields are:

	- error_severity: corrected, uncorrected, fatal, ...;
	- error_type: memory error, PCI error, bus error, ...;
	- instance: an instance number to uniquelly identify the affected resource;
	- silkscreen_label: can be a memory slot, a bus slot, a cpu slot, ...,
			    depending on the error type;
	- location: "csrow 1 channel 0" for MC; "07:05.0" for PCI, 
		    "Bus 003 Device 001" for USB, ...
	- detail: some additional error_type-specific detail handled by the core;
	- driver_detail: some additional error_type-specific detail handled by the driver.


@Steven:

In a matter of fact, the error_severity and error_type should be enum's. We should not
use enum's on ioctl's, as enum size is not portable. Can it be used inside perf, or should
them be exported, on perf, via integer (like the above proposal)?


Regards,
Mauro.
