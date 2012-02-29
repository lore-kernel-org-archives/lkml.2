Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2B2RqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:46:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab2B2RqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:46:03 -0500
Message-ID: <4F4E643F.7000204@redhat.com>
Date: Wed, 29 Feb 2012 14:45:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab> <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab> <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com> <20120229171626.GJ21224@aftab>
In-Reply-To: <20120229171626.GJ21224@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-02-2012 14:16, Borislav Petkov escreveu:
> On Wed, Feb 29, 2012 at 04:58:09PM +0000, Luck, Tony wrote:
>>> - severity: No real need for it. If the error is severe enough, the
>>> kernel handles automatically, i.e. memory poisoning and recovery. In all
>>> the other cases it is not severe enough.
>>
>> We'll never see fatal errors via the perf/tracepoint (no way the RAS daemon
>> will run to pull them).

With the current approach, that's true.

I remember you've mentioned an idea of storing fatal errors on an APEI
non-volatile memory for them to be sent to userspace after a machine 
reboot. If this is implemented some day, those type of errors could
also be reported via trace, depending on how such feature would be
implemented, as one possibility would be to just store there the contents
of the last dmesg content.

>> But we will see both corrected error chatter and
>> recovered uncorrectable errors. I would be able to tell these apart.
>> Corrected errors in small doses are normal and don't require any
>> action beyond logging so you can see whether there are enough to cross
>> a threshold and cause alarm. Recovered uncorrectable errors are going
>> to be much rarer, and I think deserve closer scrutiny - even when there
>> is just one of them.
>> If you drop the severity field, is there some other way to make this
>> distinction?
> 
> Err, MCi_STATUS bits like bit 55 (Action Required) and 56 (Signaled #MC)
> in your case...?

That would force all userspace tools that handle such errors to have
some MCA-specific logic inside, which is one of the things we're trying 
to avoid. Also, non-MCA drivers will have a severity that aren't present
at the MCA status.

Assuming that the same tool can work with both MCA and non-MCA drivers,
for API consistency, we should try to use the same way to describe
severity (and label/location) on both MCA and non-MCA cases.

With regards to Intel, as far as I know, there are some cpu-family
specific stuff for recovered uncorrectable errors.

>>> - silkscreen_label: <sarcasm> yeah, I'm getting a, say, a Data
>>> Cache error during an L1 linefill from L2, what the f*ck does the
>>> silkscreen label mean for such an error?! Well, nobody knows wtf it
>>> means!</sarcasm>
>>
>> Cache error should point to a cpu socket - I'd like to have a silk
>> screen label for that (are they numbered "0, 1, 2 ..." on the motherboard
>> or "1, 2, 3 ..."?)  No idea where we'd get that information from. dmidecode
>> shows "Socket Designation: CPU 1" (and "2") for my current Sandy Bridge
>> system. I'd have to pull the system apart to see if those are helpful
>> in identifying which physical cpu is which.
> 
> First of all, silkscreen label denotes DIMM slots in this context
> AFAICT.

No. I'm referring to the Silkscreen label (and the location) of the 
affected component, and not to just DIMMs.

> Concerning CPU sockets, I'm not aware of a method to read out
> the silkscreen labels at the CPU sockets, are you? Or am I missing
> something?

The same strategy used by edac can be used there: add a 'label' node to
	/sys/devices/system/cpu/cpu?/

To allow userspace to fill it/override it.

> IOW, we want to assume that cores 0, 1, 2 ... k-1 are on node 0; k, k+1
> ... 2k-1 belong to node 1, etc., where k is the number of cores on a
> socket and thus we have a regular core enumeration on the box.

Initially, the RAS code could fill the 'label' using the above criteria,
while allowing an userspace tool to get the labels from dmidecode and
use it there.

Regards,
Mauro
