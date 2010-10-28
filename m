Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0J1LSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:18:10 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:58751 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752730Ab0J1LSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:18:07 -0400
Message-ID: <4CC95BE8.3000909@panasas.com>
Date: Thu, 28 Oct 2010 13:18:00 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Anderson <andmike@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, julia@diku.dk
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
References: <20101021150840.GA24309@linux.vnet.ibm.com> <1288130914.5169.97.camel@haakon2.linux-iscsi.org> <1288132071.8283.689.camel@mulgrave.site> <1288132464.5169.112.camel@haakon2.linux-iscsi.org> <1288133450.8283.723.camel@mulgrave.site> <1288134048.5169.132.camel@haakon2.linux-iscsi.org> <1288134713.19649.11.camel@mulgrave.site> <1288135918.5169.149.camel@haakon2.linux-iscsi.org> <20101027075349.GA32585@gargoyle.fritz.box> <1288189658.4692.13.camel@mulgrave.site> <20101028091020.GA7906@gargoyle.fritz.box>
In-Reply-To: <20101028091020.GA7906@gargoyle.fritz.box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 11:18:06.0108 (UTC) FILETIME=[CB2A65C0:01CB7691]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 11:10 AM, Andi Kleen wrote:
> On Wed, Oct 27, 2010 at 09:27:38AM -0500, James Bottomley wrote:
>> On Wed, 2010-10-27 at 09:53 +0200, Andi Kleen wrote:
>>>> This sounds like a pretty reasonable compromise that I think is slightly
>>>> less risky for the LLDs with the ghosts and cob-webs hanging off of
>>>> them.
>>>
>>> They won't get tested either next release cycle. Essentially
>>> near nobody uses them.
>>>
>>>>
>>>> What do you think..?
>>>
>>> Standard linux practice is to simply push the locks down. That's a pretty
>>> mechanical operation and shouldn't be too risky
>>>
>>> With some luck you could even do it with coccinelle.
>>
>> Precisely ... if we can do the push down now as a mechanical
>> transformation we can put it in the current merge window as a low risk
>> API change.  This gives us optimal exposure to the rc sequence to sort
>> out any problems that arise (or drivers that got missed) with the lowest
>> risk of such problems actually arising.  Given the corner cases and the
>> late arrival of fixes, the serial number changes are just too risky for
>> the current merge window.  Having an API that changes depending on a
>> flag is also a high risk process because it's prone to further sources
>> of error.
> 
> Here's a coccinelle script I came up with that does the push down.
> It still adds a bogus empty line in front of the irqflags declaration
> which I haven't managed to avoid yet. Other than the it seems
> to DTRT on the SCSI drivers I tried.
> 
> -Andi
> 
> 
> @ rule1 @
> struct scsi_host_template t;
> identifier qc;
> @@
> t.queuecommand = qc;
> 
> @ rule2 @
> identifier rule1.qc;
> identifier cmnd;
> expression E;
> statement S, S2;
> @@
> int qc(struct scsi_cmnd *cmnd, ...) 
> {
> 	... when != S
> +	unsigned long irqflags;
> 
> +	spin_lock_irqsave(&cmnd->device->host->hostlock, irqflags);
> 	S2
> 	...
> +	spin_unlock_irqrestore(&cmnd->device->host->hostlock, irqflags);
> 	return E;
> }
> 

I disagree with your approach this introduces a spin_unlock_irqrestore
call site at every return, in the usually huge queuecommand.

I'd say just do:
- Rename XXX_queuecommand => __XXX_queuecommand_unlocked
- Define new XXX_queuecommand

int qc(struct scsi_cmnd *cmnd, ...) 
{
	unsigned long irqflags;
	int ret;

	spin_lock_irqsave(&cmnd->device->host->hostlock, irqflags);
	ret = __XXX_queuecommand_unlocked(cmnd, ...)
	spin_unlock_irqrestore(&cmnd->device->host->hostlock, irqflags);
	return ret;
}

Then when the driver is manually converted the __queuecommand_unlocked
can be set into the scsi_host_template and the added function can
be dropped.

My $0.017
Boaz

