Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2HCCTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 22:19:54 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:46535 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab2HCCTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 22:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP11x9UYm7QReMjqZHtv8ZVoMRzNsREe-bdNwNSoSA6TRfw@mail.gmail.com>
References: <1343936764-6461-1-git-send-email-vikram.pandita@ti.com>
 <CAPXgP10fJj3SwDdCa=rzfjZM8TL1GsvbSwEnfomFQ+NrW2j15w@mail.gmail.com>
 <CAFm5wm2yof+ePMAtueBJh+gKyih-9ohdCYFC6xLTqwjeOgWWog@mail.gmail.com> <CAPXgP11x9UYm7QReMjqZHtv8ZVoMRzNsREe-bdNwNSoSA6TRfw@mail.gmail.com>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Thu, 2 Aug 2012 19:19:31 -0700
Message-ID: <CAFm5wm3w_QXzuScz7qOQpUabNS1tRcH_fJmR0rmqAvXzCSJxzA@mail.gmail.com>
Subject: Re: [PATCH] printk: add option to print cpu id
To: Kay Sievers <kay@vrfy.org>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay

On Thu, Aug 2, 2012 at 5:06 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Fri, Aug 3, 2012 at 1:50 AM, Pandita, Vikram <vikram.pandita@ti.com> wrote:
>> On Thu, Aug 2, 2012 at 1:08 PM, Kay Sievers <kay@vrfy.org> wrote:
>
>>> How is that supposed to be useful?
>>>
>>> The prefix is added while exporting data from the kmsg buffer, which
>>> is just the CPU that *reads* the data from the buffer, not the one
>>> that has *written* the data it into it.
>>
>> I don't think so.
>> I can see the backtrace of the printk() call looks like follows:
>>
>> print_cpuid
>>  print_prefix
>>   msg_print_text
>>    console_unlock
>>     vprint_emit
>>      printk
>>
>> Now this is a synchronous path, where in the buffer is getting filled
>> with cpuid and timer info from the printk() calling context.
>> So you should get the right CPU id with the trace - with the exception
>> that i pointed out earlier for preemption.
>>
>>>
>>> Do I miss anything here?
>>
>> This is my understanding of the printk framework.
>> At least the print_time and print_cpuid seems to be happening
>> synchronously wrt printk
>
> Printk is a store-and-forward-model, and it always was. There is no
> guarantee at all, that the data is immediately flushed to the console
> by the same CPU, it just happens to be in most cases. It's pretty
> common though, that a different task is doing that work when it gets
> the console lock, and that is not a matter of preemption, it's normal
> and expected operation. The data which CPU has emitted the text is
> just not available. It would need to be stored in the records, for
> this to work.
>
> Your patch just prints the CPU that writes to the console, not
> necessarily the one that has stored the data. I think the second one
> is which is what you are looking for, but that is not what the patch
> does.
>

I did not understand well the complexity of the console layer. Thanks
for enlightenment :-)
Would be nice if you have any suggestion to get this done the right way.

First look i could guess this would do, but need to study further:

@@ -1550,6 +1550,9 @@ asmlinkage int vprintk_emit(int facility, int level,
                          NULL, 0, recursion_msg, printed_len);
        }

+       text_len = print_cpuid(text);
+       text += text_len;
+
        /*
         * The printf needs to come first; we need the syslog
         * prefix which might be passed-in as a parameter.
@@ -1582,6 +1585,13 @@ asmlinkage int vprintk_emit(int facility, int level,
                }
        }

+       /* Adjust for cpu-id string */
+       if (printk_cpuid) {
+               strncpy(text - 4, textbuf, 4);
+               text -= 4;
+               text_len += 4;
+       }
+
        if (level == -1)
                level = default_message_loglevel;



> Also dmesg and syslog uses the same logic and would put-out all
> entirely wrong CPU information with it, because the original
> information is long gone.
>
> Kay
