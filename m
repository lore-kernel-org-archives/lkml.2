Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab1DMOW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab1DMOW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:22:56 -0400
Message-ID: <4DA5B1B1.5090905@redhat.com>
Date: Wed, 13 Apr 2011 10:22:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH 2/3] x86, MCE: Drop default decoding notifier
References: <20110413132409.GB1900@gere.osrc.amd.com> <1302701810-2471-2-git-send-email-bp@amd64.org> <4DA5ACB2.1070505@redhat.com> <20110413141829.GE1987@aftab>
In-Reply-To: <20110413141829.GE1987@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/13/2011 10:18 AM, Borislav Petkov wrote:
> On Wed, Apr 13, 2011 at 10:01:22AM -0400, Prarit Bhargava wrote:
>   
>> On 04/13/2011 09:36 AM, Borislav Petkov wrote:
>>     
>>> From: Borislav Petkov <borislav.petkov@amd.com>
>>>
>>> The default notifier doesn't make a lot of sense to call in the
>>> correctable errors case. Drop it and emit the mcelog decoding hint only
>>> in the uncorrectable errors case and when no notifier is registered.
>>>
>>> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>>> ---
>>>  arch/x86/include/asm/mce.h       |    4 ++--
>>>  arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++-----------------
>>>  2 files changed, 11 insertions(+), 19 deletions(-)
>>>
>>>       
>>   
>>     
>>> +extern atomic_t mce_decoders;
>>> +
>>>       
>> Boris,
>>
>> I don't think we need to do this.  I think we can use the existing notifier chain tools to do this check for us ... *untested and uncompiled* patch below.
>>
>>   	 * Print out human-readable details about the MCE error,
>>     
>>>  	 * (if the CPU has an implementation for that)
>>>  	 */
>>> -	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
>>> +	if (!atomic_read(&mce_decoders)) {
>>> +		pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
>>> +		pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' to decode.\n");
>>>       
>> I thought we didn't want these lines at all for CE errors?
>>     
> This is the UC only case - we call print_mce() before we panic.
>   

.. right ... but we would still see nonsensical messages before the
panic, which will confuse the end user.  IMO, dump the messages unless
it's UC.  And we shouldn't print out the human readable message at all.

I'm installing F14 on  a system that is known to generate CEs @
boot-time.  I'll test patches+latest upstream to here to see what happens...

P.

>
>   
