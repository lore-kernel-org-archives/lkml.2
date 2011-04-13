Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab1DMROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1DMROu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:14:50 -0400
Message-ID: <4DA5D9FB.1010503@redhat.com>
Date: Wed, 13 Apr 2011 13:14:35 -0400
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
Subject: Re: [PATCH -v2] x86, MCE: Drop default decoding notifier
References: <20110413132409.GB1900@gere.osrc.amd.com> <1302701810-2471-2-git-send-email-bp@amd64.org> <4DA5ACB2.1070505@redhat.com> <20110413141829.GE1987@aftab> <4DA5B1B1.5090905@redhat.com> <20110413142648.GB2791@aftab> <20110413143642.GC2791@aftab> <4DA5D6CC.9090500@redhat.com>
In-Reply-To: <4DA5D6CC.9090500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/13/2011 01:01 PM, Prarit Bhargava wrote:
>   
>> @@ -239,7 +227,9 @@ static void print_mce(struct mce *m)
>>  	 * Print out human-readable details about the MCE error,
>>  	 * (if the CPU has an implementation for that)
>>  	 */
>> -	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
>> +	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
>> +	if (ret != NOTIFY_STOP)
>> +		pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' to decode.\n");
>>  }
>>   
>>     
> Borislav,
>
>   

Oops.  Let me *carefully* rephrase that so it is clear what I'm
complaining about.

> I still think you need the check for UC here.  When an UC occurs and
> mce_panic() is called the output will include:
>
> [Hardware Error]:  Run the above through 'mcelog --ascii' to decode.
>
> potentially many, many times

for _all_ unreported *correctable* errors.

> .  The problem still is that there is no
> output to decode (in the default case).
>
>   

ie) (sorry for the cut-and-paste)

        /* First print corrected ones that are still unlogged */
        for (i = 0; i < MCE_LOG_LEN; i++) {
                struct mce *m = &mcelog.entry[i];
                if (!(m->status & MCI_STATUS_VAL))
                        continue;
                if (!(m->status & MCI_STATUS_UC)) {
                        print_mce(m);
                        if (!apei_err)
                                apei_err = apei_write_mce(m);
                }
        }

will potentially result in many bogus messages during a time at which we
definitely do not want bogus messages.

P.

