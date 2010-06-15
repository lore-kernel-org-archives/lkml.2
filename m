Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0FOIah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:30:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52588 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0FOIaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=O749+Rpnl0lmwfb7TnoLhWdntlow9DY142kybUZP9smf+OvhHtuu3YecEeZUbS4HyH
         GcVOrqA91oTPh+BRLeUDmqYuHFNOK6bhOt8HYUTkzH40CvcKZk3DU/oMd6uNYhu2BIqn
         /NbAv4RyQjjDtuAIdaFeVLZp1sHdUM77FEpV0=
Message-ID: <4C173A38.7060405@gmail.com>
Date: Tue, 15 Jun 2010 01:30:48 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       Peter Stuge <peter@stuge.se>, tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but	not
 used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost> <4C16E18F.9050901@gmail.com> <9275.1276573789@localhost> <4C16F9FC.2080905@gmail.com> <20100615052944.7746.qmail@stuge.se> <4C17169F.4060205@gmail.com> <4C17244D.7010806@s5r6.in-berlin.de> <4C172B73.6090609@gmail.com> <4C173216.3040007@s5r6.in-berlin.de>
In-Reply-To: <4C173216.3040007@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 12:56 AM, Stefan Richter wrote:
> (adding Cc: tpm maintainers, after I had cut the Cc list earlier...)
>
> Justin P. Mattock wrote:
>> On 06/14/2010 11:57 PM, Stefan Richter wrote:
>>> Justin P. Mattock wrote:
>>>> On 06/14/2010 10:29 PM, Peter Stuge wrote:
>>>>> Justin P. Mattock wrote:
>>>>>> I have no manual in front of me. Did a quick google, but came up with
>>>>>> (no hits) info on what that function does. grep showed too many
>>>>>> entries
>>>>>> to really see why/what this is.
>>>>>
>>>>> Check out the tool cscope. (Or kscope, if you prefer a GUI.)
>>>>
>>>> thanks for this tool.. I think this is what I need.. running around not
>>>> knowing what/where the manual is for a call is a bit daunting.
>>>
>>> Similar to cscope/kscope but online:
>>> http://lxr.free-electrons.com/
>>> http://lxr.linux.no/linux
>>>
>>> E.g. http://lxr.free-electrons.com/ident?i=transmit_cmd
>>
>> hmm.. yeah I use those guys a lot.. with grep also.. I think what might
>> throw me off is things like def.orig = def.new then def.orig gets lost
>> in the mix(or it's there, but the grep becomes gigantic in code
>> results.) main thing I look for is googling "somedefinition linux man"
>> for some idea of what that function does.
>>
>> Justin P. Mattock
>
> I'm afraid that even if there was inline documentation of the function,
> it would still be near impossible to guess what to do with unused return
> codes if one is not familiar with the hardware and with the driver.
>
> To quote your original patch again:
>
>> Im getting this warning when compiling:
>>   CC      drivers/char/tpm/tpm.o
>> drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
>> drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used
>>
>> The below patch gets rid of the warning,
>> but I'm not sure if it's the best solution.
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/char/tpm/tpm.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
>> index 05ad4a1..3d685dc 100644
>> --- a/drivers/char/tpm/tpm.c
>> +++ b/drivers/char/tpm/tpm.c
>> @@ -514,6 +514,8 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
>>
>>   	rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>>   			"attempting to determine the timeouts");
>> +	if (!rc)
>> +		rc = 0;
>>   }
>>   EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
>
> So, void tpm_gen_interrupt() itself clearly is not prepared to do
> anything about an error return from transmit_cmd.  The question is, is
> this OK and can the "rc = " simply be removed, or should
> tpm_gen_interrupt gain some error handling, or should tpm_gen_interrupt
> be changed to a non-void function and its callers check for errors in
> tpm_gen_interrupt?
>

still not sure what that mechanism is doing..

I was going by the warning message i.g.  set but not used
so as soon as it was being used even by adding printk, gcc was happy.
But shutting it off seemed a better approach why? because at the time I 
knew it would work, or fixed it temporarily until somebody who's code 
this is can look at it and send out a better solution(hence what you did).

> It could very well be that there is really no need or no possibility for
> error handling.  But until somebody familiar with the matter has figured
> this out, it is in fact better to leave the compiler warning in place.
>

yep.. I agree..

> Just silencing the compiler if the possibility exists that there is an
> actual flaw here is not the way to go.  Still, good that you reported it
> even with an RFC patch, since the authors were obviously unaware of such
> a warning until now.

I did not like the idea of silencing it.. due to the fact that it can be 
forgotten(or lost in the sands of time per-see)
best I just file a bug report then..in these types of cases.

In any case I still have more warnings..(and that's just my .config)
who knows how many more there are.. If you guys like I can go ahead in 
the next few days and send out another set(minus the rc = 0; thing that 
I did) then go from there.

keep in mind I'm just tackling the ones I think are easy.. ones with 
double variables I left until later down the line..

Justin P. Mattock
