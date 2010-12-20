Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0LTJiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:38:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab0LTJiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:38:22 -0500
Message-ID: <4D0F2524.5030407@suse.de>
Date: Mon, 20 Dec 2010 10:43:00 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
Cc: dgilbert@interlog.com, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Penokie, George" <George.Penokie@lsi.com>, mkp@mkp.net
Subject: Re: RFC: short reads on block devices
References: <4D0B945C.2060309@interlog.com> <1292618194.2820.90.camel@mulgrave.site>
In-Reply-To: <1292618194.2820.90.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 09:36 PM, James Bottomley wrote:
> On Fri, 2010-12-17 at 11:48 -0500, Douglas Gilbert wrote:
>> Recently while testing with the scsi_debug driver
>> I was able to trick the block layer into reading
>> random data which the block layer thought was
>> valid ***.
>>
>> Best to start with an example, say LBA ** 4660 has
>> an unrecoverable error (aka medium error) and
>> the block layer fires off a SCSI READ for 8
>> blocks (512 byte variety) at LBA 4656. The response
>> will be a medium error with the sense buffer info
>> field indicating LBA 4660. Now are the 4 blocks
>> that precede it (i.e. LBA 4656 to 4659) possibly
>> sitting in the data-in buffer and valid??
>>
>> The block layer thinks they are. This is what my
>> term "short read" in the title alludes to. So I put
>> this question to the T10 reflector:
>>     http://www.t10.org/t10r.htm
>> titled "sbc: reading blocks prior to a medium error".
>> And the answers were pretty clear. And the one from
>> George Penokie of LSI is interesting because Linux's
>> block layer assumption breaks some of LSI's equipment.
> 
> Well, unsurprisingly, I was aware of the issue via Novell customer
> interactions.  Since you've outed LSI, we can discuss it openly.
> 
> The fact is that for medium errors, every other array returns valid data
> up to the erroring sector.
> 
>> On the other hand, big array vendors and database vendors
>> want exactly what the block layer is doing at the moment.
>> So those guys don't want a change. [Please correct me
>> if that is too sweeping.] Also I'm informed some other
>> OSes do this as well.
> 
> Plus all disk devices transfer up to the error sector.  Additionally,
> Martin Petersen uses the same code for DIF and he's secured external
> agreement from the DIF based arrays that nothwithstanding the ambiguity
> in the SCSI standards, all DIF arrays return valid data up to the sector
> with the DIF error.
> 
>> I would like to propose a solution, at least in the SCSI
>> subsystem context. The 'resid' field was added 11 years
>> ago and is used by a HBA driver to indicate how many bytes
>> less than requested were placed in the scatter gather
>> list (i.e. the data-in buffer). It defaults to zero
>> (meaning all requested bytes have been read). Usually
>> for a medium error one would not bother setting resid
>> (so resid would remain 0). Somewhat surprisingly the
>> block layer has always ignored resid. I propose in the
>> case of a short read caused by a MEDIUM ERROR the block
>> layer checks resid. And if resid equals the requested
>> number of bytes then that means no data in the scatter
>> gather list is valid. So the block layer should act on
>> this information.
>>
>> To this end I propose to change the scsi_debug driver
>> to set resid equal to bufflen when it simulates a
>> medium error.
>>
>> Changes in the block layer and drivers from vendors who
>> want the strict "T10" handling of medium errors would
>> also be required. Maybe the USB mass storage (and UAS)
>> folks might also check if this impacts them.
> 
> OK, so I checked, and I think all of the major in-use HBA drivers today
> do set the residue, so I'd be reasonably happy with a modification like
> the following.  It basically believes the lower of either the
> transferred data or the listed error (assuming the listed error is
> valid ... if it's invalid, we still assume we can't trust anything).
> This should mean that HBA drivers that set the residue work for all
> arrays and those that don't work as they do today.
> 
Okay, having been part of the discussion (and the resulting
specification digging) I'm not quite convinced that this minimal
patch does entirely the right thing.

After all, T10 said we should consider the buffer as invalid in the
face of read or write errors, despite the fact that some bits in
there _may_ be valid.

So the correct approach here would be to retry the command
with a short read up to the size indicated in the sense code;
that should avoid the error and the buffer would be filled with
correct data.

And with that approach we would be keeping everyone happy.

Hmm. Someone should do a patch here :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
