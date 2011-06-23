Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab1FWUGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:06:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53858 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab1FWUGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:06:03 -0400
Message-ID: <4E039C95.3070907@linux.vnet.ibm.com>
Date: Thu, 23 Jun 2011 15:05:41 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@us.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        wayneb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, mbizon@freebox.fr, jgarzik@pobox.com,
        Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [PATCH] libata/sas: only set FROZEN flag if new EH is supported
References: <20110615191747.GA6324@us.ibm.com> <4DF90FCA.1040706@linux.vnet.ibm.com> <20110615233417.GB6324@us.ibm.com> <20110616075114.GH8141@htj.dyndns.org> <4DFA0507.3090609@linux.vnet.ibm.com> <20110616152836.GA15268@us.ibm.com> <20110621160714.GA14174@us.ibm.com> <4E00FF58.7070802@linux.vnet.ibm.com> <1308803461.32158.191.camel@pasglop> <1308804120.32158.202.camel@pasglop> <20110623171502.GA11855@us.ibm.com>
In-Reply-To: <20110623171502.GA11855@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 12:15 PM, Nishanth Aravamudan wrote:
> On 23.06.2011 [14:42:00 +1000], Benjamin Herrenschmidt wrote:
>> On Thu, 2011-06-23 at 14:31 +1000, Benjamin Herrenschmidt wrote:
>>> On Tue, 2011-06-21 at 15:30 -0500, Brian King wrote:
>>>> Looks good to me. Jeff/Tejun - any issues with merging this?
>>>
>>> BTW. Current upstream with that patch applied on a machine here leads to
>>> several oddities, I don't know at this point whether any of that is
>>> actually a regression :
>>
>> Ooops... pressed "send" too quickly. Here's a log excerpt with some
>> comments:
> 
> Hrm, I didn't see any of this on my box, which I thought was the same as
> yours :)
> 
>> ipr: IBM Power RAID SCSI Device Driver version: 2.5.2 (April 27, 2011)
>> ipr 0000:04:00.0: Found IOA with IRQ: 129
>> ipr 0000:04:00.0: Initializing IOA.
>> ipr 0000:04:00.0: Starting IOA initialization sequence.
>> ipr 0000:04:00.0: Adapter firmware version: 04220029
>> ipr 0000:04:00.0: IOA initialized.
>> scsi0 : IBM 2B4C Storage Adapter
>> scsi 0:0:4:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
>> scsi scan: INQUIRY result too short (5), using 36
>>
>> -> Are these odd INQUIRY results expected ?

Looking at the log, my guess is that we are dealing with a zero buffer. If we were
to get an all zero buffer on the Inquiry, we would think it was a Direct-Access
device with an inquiry response buffer of 5 bytes in length.

>> scsi 0:0:5:0: Direct-Access                                    PQ: 0 ANSI: 0
>> scsi 0:0:6:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
>> scsi 0:0:7:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
>> scsi scan: INQUIRY result too short (5), using 36
>> scsi 0:0:18:0: Direct-Access                                    PQ: 0 ANSI: 0

I'm guessing this should really be an Enclosure device here rather than a disk,
which would be symptomatic of the all zero inquiry buffer.

>> scsi 0:2:18:0: Enclosure         IBM      PSBPD6E4A  3GSAS 0109 PQ: 0 ANSI: 4
>> scsi: unknown device type 31
>> scsi 0:255:255:255: No Device         IBM      2B4C001SISIOA    0150 PQ: 0 ANSI: 0
>>
>> -> The above looks odd, not sure what it means
> 
> The "unknown device type"? I see it all the time on lots of different
> machines.

That is normal and expected on an ipr adapter. The unknown device seen on every ipr
adapter at SCSI bus/target/lun 255:255:255 is the adapter itself. It is used by
the RAID management tools in Linux to do things like RAID configuration via SG_IO.

> 
>> ipr 0000:05:00.0: Found IOA with IRQ: 130
>> ipr 0000:05:00.0: Initializing IOA.
>> scsi 0:254:0:0: Processor         IBM      57CB001SISIOA    0150 PQ: 0 ANSI: 0
>> ipr 0000:05:00.0: Starting IOA initialization sequence.
>> ipr 0000:05:00.0: Adapter firmware version: 04220029
>> ipr 0000:05:00.0: IOA initialized.
>> scsi1 : IBM 57CB Storage Adapter
>> scsi scan: INQUIRY result too short (5), using 36
>> scsi 1:0:4:0: Direct-Access                                    PQ: 0 ANSI: 0
>> scsi 1:0:5:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
>> scsi scan: INQUIRY result too short (5), using 36
>> scsi 1:0:6:0: Direct-Access                                    PQ: 0 ANSI: 0
>> scsi 1:0:7:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
>> scsi 1:0:18:0: Enclosure         IBM      PSBPD6E4A  3GSAS 0109 PQ: 0 ANSI: 4
>> scsi: On host 1 channel 0 id 18 only 511 (max_scsi_report_luns) of 402653184 luns reported, try increasing max_scsi_report_luns.
>> scsi: host 1 channel 0 id 18 lun 0xc0000007f01e810f has a LUN larger than currently supported.
>>
>> -> Now that looks horribly wrong... that LUN number looks like a kernel pointer
> 
> Yeah, that's weird.
> 
>> scsi scan: INQUIRY result too short (5), using 36
>> scsi 1:2:18:0: Direct-Access                                    PQ: 0 ANSI: 0
>> ata1.00: ATAPI: IBM     RMBO0040532, SA61, max UDMA/100
>> ata1.00: failed to IDENTIFY (device reports invalid type, err_mask=0x0)
>> ata1.00: revalidation failed (errno=-22)
>> ata1.00: disabled
>>
>> -> So SATA works "better" with the patch but doesn't actually work properly :-)
>>
>> scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
>>
>> -> That error could give us more info... not sure what it means, we do have plenty of 
>> memory...
> 
> That message is sort of strange. It's not necessarily referring to
> memory allocation failing, but the port allocation failing in the SCSI
> code. And that just means an error, like the failed to IDENTIFY above,
> is occurring in the allocation path. It *can* also mean memory
> allocation failure, I think, just not in this case.
> 
> I don't know much about the following errors, though, sorry.
> 
> -Nish
> 
>> scsi 1:8:0:0: Enclosure         IBM      VSBPD6E4B  3GSAS   01 PQ: 0 ANSI: 2
>> scsi: unknown device type 31
>> scsi 1:255:255:255: No Device         IBM      57CB001SISIOA    0150 PQ: 0 ANSI: 0
>> work_for_cpu used greatest stack depth: 9520 bytes left
>> st: Version 20101219, fixed bufsize 32768, s/g segs 256
>> sd 0:0:4:0: [sda] 585937500 512-byte logical blocks: (300 GB/279 GiB)
>> sd 0:0:5:0: [sdb] 585937500 512-byte logical blocks: (300 GB/279 GiB)
>> sd 0:0:6:0: [sdc] 585937500 512-byte logical blocks: (300 GB/279 GiB)
>> sd 0:0:7:0: [sdd] 585937500 512-byte logical blocks: (300 GB/279 GiB)
>> sd 0:0:18:0: [sde] READ CAPACITY failed
>> sd 0:0:18:0: [sde]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> sd 0:0:18:0: [sde]  Sense Key : Illegal Request [current] 
>> sd 0:0:18:0: [sde]  Add. Sense: Invalid command operation code
>>
>> -> Any idea what's up with that guy ?

If this guy is really an enclosure, this is the response you would get
on a Read Capacity.

>>
>> sd 0:0:4:0: Attached scsi generic sg0 type 0
>> sd 0:0:5:0: [sdb] Write Protect is off
>> sd 0:0:5:0: Attached scsi generic sg1 type 0
>> sd 0:0:18:0: [sde] Test WP failed, assume Write Enabled
>> sd 0:0:6:0: Attached scsi generic sg2 type 0
>> sd 0:0:18:0: [sde] Asking for cache data failed
>> sd 0:0:7:0: Attached scsi generic sg3 type 0
>> sd 0:0:18:0: [sde] Assuming drive cache: write through
>> sd 1:2:18:0: [sdj] READ CAPACITY failed
>> sd 1:2:18:0: [sdj]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> sd 1:2:18:0: [sdj]  Sense Key : Illegal Request [current] 
>> sd 1:2:18:0: [sdj]  Add. Sense: Invalid command operation code
>>
>> -> And this one ?

Same here.

When did this last work on this system? It seems like this is completely
separate from the libata issue.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


