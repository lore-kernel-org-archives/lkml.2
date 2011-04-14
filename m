Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab1DNPX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710Ab1DNPXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:23:24 -0400
Message-ID: <4DA71158.6020302@redhat.com>
Date: Thu, 14 Apr 2011 11:23:04 -0400
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
Subject: Re: [PATCH -v3] x86, MCE: Drop the default decoding notifier
References: <4DA5ACB2.1070505@redhat.com> <20110413141829.GE1987@aftab> <4DA5B1B1.5090905@redhat.com> <20110413142648.GB2791@aftab> <20110413143642.GC2791@aftab> <4DA5D6CC.9090500@redhat.com> <4DA5D9FB.1010503@redhat.com> <20110413173705.GJ2791@aftab> <20110414150036.GG10080@aftab> <4DA70D0B.3080407@redhat.com> <20110414151621.GI10080@aftab>
In-Reply-To: <20110414151621.GI10080@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/14/2011 11:16 AM, Borislav Petkov wrote:
> On Thu, Apr 14, 2011 at 11:04:43AM -0400, Prarit Bhargava wrote:
>   
>>
>> On 04/14/2011 11:00 AM, Borislav Petkov wrote:
>>     
>>> On Wed, Apr 13, 2011 at 01:37:05PM -0400, Borislav Petkov wrote:
>>>   
>>>       
>>>> In the worst case, we will report 32 CEs before panicking. For that case
>>>> we either do printk_once as Tony suggested or we ratelimit it. I'll
>>>> update the patch.
>>>>     
>>>>         
>>> Ok, how about the following, I ratelimit the printk to the default of 10
>>> messages per 5 seconds. I've also got the hardware MCE injection patches
>>> ready and will do some testing with them.
>>>   
>>>       
>> See my previous email ;)  I think just putting in a printk_once after
>> the CE call to print_mce() in mce_panic() might be better?  At least
>> that way we get the --ascii message for *EVERY* UC which IMO would be
>> nice...
>>     
> Are you sure? printk_once() is, as its name says, a one-time thing and
> it is implemented that way - a static bool counter which is once set and
> that's it. I.e., the "--ascii" message will be printed only once for the
> system's lifetime.
>   

Oops ... I may have confused you because what I did was subtle.  I
really should have explicitly pointed out what I did.  Sorry, my bad.

>From my patch (sorry for the cut-and-paste):

@@ -239,7 +227,10 @@ static void print_mce(struct mce *m)
         * Print out human-readable details about the MCE error,
         * (if the CPU has an implementation for that)
         */
-       atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+       ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+       if (ret != NOTIFY_STOP && (m->status & MCI_STATUS_UC))
+               pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' "
+                        "to decode.\n");
 }
 
This, of course, only outputs during UCs.

and

@@ -289,6 +280,8 @@ static void mce_panic(char *msg, struct mce *final,
char *exp)
                        continue;
                if (!(m->status & MCI_STATUS_UC)) {
                        print_mce(m);
+                       printk_once(KERN_EMERG HW_ERR "MCE Corrected
Error(s) "
+                                   "detected.");
                        if (!apei_err)
                                apei_err = apei_write_mce(m);
                }

so we'll print "MCE Corrected Error(s)" _once_ if we go through this
path.  Since there is no data to decode with mcelog, a nice little one
time message is probably the way to go :).

P.
