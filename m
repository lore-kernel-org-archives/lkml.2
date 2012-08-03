Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2HCAGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 20:06:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60282 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2HCAGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 20:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAFm5wm2yof+ePMAtueBJh+gKyih-9ohdCYFC6xLTqwjeOgWWog@mail.gmail.com>
References: <1343936764-6461-1-git-send-email-vikram.pandita@ti.com>
 <CAPXgP10fJj3SwDdCa=rzfjZM8TL1GsvbSwEnfomFQ+NrW2j15w@mail.gmail.com> <CAFm5wm2yof+ePMAtueBJh+gKyih-9ohdCYFC6xLTqwjeOgWWog@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 3 Aug 2012 02:06:09 +0200
Message-ID: <CAPXgP11x9UYm7QReMjqZHtv8ZVoMRzNsREe-bdNwNSoSA6TRfw@mail.gmail.com>
Subject: Re: [PATCH] printk: add option to print cpu id
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 1:50 AM, Pandita, Vikram <vikram.pandita@ti.com> wrote:
> On Thu, Aug 2, 2012 at 1:08 PM, Kay Sievers <kay@vrfy.org> wrote:

>> How is that supposed to be useful?
>>
>> The prefix is added while exporting data from the kmsg buffer, which
>> is just the CPU that *reads* the data from the buffer, not the one
>> that has *written* the data it into it.
>
> I don't think so.
> I can see the backtrace of the printk() call looks like follows:
>
> print_cpuid
>  print_prefix
>   msg_print_text
>    console_unlock
>     vprint_emit
>      printk
>
> Now this is a synchronous path, where in the buffer is getting filled
> with cpuid and timer info from the printk() calling context.
> So you should get the right CPU id with the trace - with the exception
> that i pointed out earlier for preemption.
>
>>
>> Do I miss anything here?
>
> This is my understanding of the printk framework.
> At least the print_time and print_cpuid seems to be happening
> synchronously wrt printk

Printk is a store-and-forward-model, and it always was. There is no
guarantee at all, that the data is immediately flushed to the console
by the same CPU, it just happens to be in most cases. It's pretty
common though, that a different task is doing that work when it gets
the console lock, and that is not a matter of preemption, it's normal
and expected operation. The data which CPU has emitted the text is
just not available. It would need to be stored in the records, for
this to work.

Your patch just prints the CPU that writes to the console, not
necessarily the one that has stored the data. I think the second one
is which is what you are looking for, but that is not what the patch
does.

Also dmesg and syslog uses the same logic and would put-out all
entirely wrong CPU information with it, because the original
information is long gone.

Kay
