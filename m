Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2EUPfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab2EUPaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:07 -0400
Message-ID: <4FBA5F59.5000604@redhat.com>
Date: Mon, 21 May 2012 12:29:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory controller
 events
References: <4FB62BAB.90808@redhat.com> <20120518124338.GJ20215@aftab.osrc.amd.com> <4FB64D5B.1030301@redhat.com> <20120518140521.GM20215@aftab.osrc.amd.com> <4FB65D52.9060108@redhat.com> <20120518164014.GX20215@aftab.osrc.amd.com> <4FB6866E.7090503@redhat.com> <20120518185258.GE20215@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com> <20120518211211.GA26464@aftab.osrc.amd.com> <20120519092618.GC29991@aftab.osrc.amd.com>
In-Reply-To: <20120519092618.GC29991@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-05-2012 06:26, Borislav Petkov escreveu:
> On Fri, May 18, 2012 at 11:12:11PM +0200, Borislav Petkov wrote:
>> On Fri, May 18, 2012 at 07:10:42PM +0000, Luck, Tony wrote:
>>>> That's why _each_ _driver_ will have its format and the userspace tools
>>>> parsing it will know about it!
>>>
>>> Sounds like a full employment program for parser writers.
>>>
>>> There are some interesting fields that should be common to all
>>> drivers ... so have twenty parsers that can handle:
>>>
>>> 	paddr: 0x1234
>>> 	PADDR: 0x1234
>>> 	Paddr = 0x1234
>>> 	Phys = 1234
>>> 	addr: 0x1234
>>> 	Address: 0x000000001234
>>>
>>> looks like a lot of make-work ... when the OS can standardize in the ABI
>>> that there is a 64-bit binary value that is the physical address of the
>>> error (and another 64-bit mask saying which, if any, bits are valid).

The EDAC API works with the address/address mask as 3 values: address page,
address offset inside the page and grain.

The values for address page/offset/grain and syndrome are mandatory on the EDAC
error calls. Drivers that can't obtain that fill with zero. EDAC prints those
values via the current API.

So, passing those values for the tracepoint makes sense.

In order to use a cleaner API, we may add a flags bitfield there, and add a few
flags to mark if the address (page, offset, grain) is valid and if the syndrome
is valid.

>>
>> Makes sense, I gotta say :)
>>
>>> So we should be looking for the set of always relevant values that
>>> can be kept explicitly separate in fields in TP_PROTO, and per-driver
>>> specific stuff (grain/syndrome??) bits that will have to go into the
>>> "details" string and require some driver specific user-mode parsing to
>>> use.
>>
>> How about we put all the values which are globally valid for all drivers
>> in separate fields and leave the "(...)" brackets for details where each
>> driver can put its own relevant stuff?

You're again concerned about the printk formatting, and not about the fields.
I don't care that much about that. Whatever you/Tony wants for the printk
is fine for me.

The TP_printk logic can change on newer patches, as printk output is not
stable in Linux Kernel.

>>
>> For the record, I very much like this reasoning :).
> 
> On a second thought, filtering out the globally valid fields for all
> drivers might require a lot of careful driver auditing.

If you want to explode the driver details, then yes, but the address and
syndrome are part of the EDAC internal ABI.

Most drivers are capable of getting address and syndrome, for CE.
For UE, syndrome is generally not calculated.

Anyway, on _all_ internal ABI calls, when syndrome or address aren't
calculated, the drivers pass a value of 0 for them.

So, it is easy to add a logic inside the code that will rise a flag to
indicate userspace when those fields are filled or not. All the EDAC
core needs to do is to check if the value is 0 or not.

> What would be better and easier is to add those single fields to the
> tracepoint which are relevant to the user (and which are more or less
> globally valid for all drivers by inferrence) and leave the rest lumped
> together in a single char *.

Address and syndrome can be relevant for a proper edac handling daemon, as
some advanced error check mechanism could use those values to be able
to filter out some random interference from an error that is occurring at
the same memory grain, e. g. if a machine is producing an error (even being
very sparsed in time) at the same DRAM, and no errors outside it,
it is very likely that such DRAM chip is damaged.

> 
> Which is basically what I'm suggesting for a couple of days now :-)
> 
>        TP_PROTO(const unsigned int err_type,
>                 const unsigned int mc_index,
>                 const char *error_msg,
>                 const char *label,
>                 const char *location,
>                 const char *detail)
>
> and I'm really not sure about err_type - this is an edac-specific define
> and it means nothing outside the kernel so its string representation
> could very well could be merged with error_msg and we can drop the ( ? :
> ) ugliness in the tracepoint definition itself.

All error management systems use a mandatory field for the error severity.
On all implementations I know, this is the first field at the management 
base, and, together with the error message, the most important one.

Btw, even the Linux Kernel printk logic starts with severity (error level).

Regards,
Mauro
