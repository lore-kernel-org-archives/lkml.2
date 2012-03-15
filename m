Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896Ab2COMln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761877Ab2COMlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:41:12 -0400
Message-ID: <4F61E35B.9000906@redhat.com>
Date: Thu, 15 Mar 2012 09:40:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120313233217.GB31106@kroah.com> <4F60F2E4.7060707@redhat.com> <20120314204355.GA10187@kroah.com> <20120314223102.GA27602@aftab> <4F61496D.8030000@redhat.com> <20120315113115.GA32149@aftab>
In-Reply-To: <20120315113115.GA32149@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-03-2012 08:31, Borislav Petkov escreveu:
> On Wed, Mar 14, 2012 at 10:44:13PM -0300, Mauro Carvalho Chehab wrote:
>> As I said, that is easy to implement. The hard part would be what to do with
>> the per-csrow/per-branch error counters that exist currently at EDAC.
>>
>> From my side, I'm OK to remove them, but, as I said before, existing user tools
>> use them,
> 
> What are you talking about? Those per-rank counters should be the same
> as the per-csrow ch0 and ch1 counters...

Yes, but with your proposal, the per-csrow counters will not be added
(the equivalent of):
	/sys/devices/system/edac/mc/mc0/csrow0/ue_count
	/sys/devices/system/edac/mc/mc0/csrow0/ce_count

>> especially because UE errors aren't per-rank/per-dimm on the
>> typical case (128 bits cacheline).
> 
> It depends - if the 128 bit word comes from a single DIMM (unganged
> mode) then you have a per-rank UE.

True, and there are other types of ECC logic that would allow to identify
what DIMM/rank produced the error.

Yet, the typical case is to use two DIMMs for a 128-bits cacheline
on separate channels, due to performance improvements, and ECC chipkill
using the 128+16 bits, as it improves the probability of error correction.

>> Of course, the EDAC logic could increment multiple UE error counters
>> in such case, (meaning that an error happened on either one of the
>> affected DIMMs/Ranks) but this is a different behavior than the
>> current API.
> 
> Well, the API should be changed to accomodate such configurations.

True, but changing the propagation logic to propagate the error down
to the several DIMMs from where the error might have occurred is:

	- the opposite of the current propagation logic;

	- the opposite on how ITU-T TMN architecture and all EMS/NMS
	  implementations I'm aware with work.

So, using such propagation logic doesn't sound right to me. What I'm
saying is that, if all the driver can be sure is that the error happened
at the csrow level, it should not propagate the errors to the channel
level. 

So, I think that csrow-level counter is needed (and the equivalent
"group" counters for non-rank-based memory controllers).

Regards,
Mauro.
