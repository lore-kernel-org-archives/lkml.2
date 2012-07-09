Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2GIWKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:10:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62706 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2GIWKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <1341870165.6118.42.camel@joe2Laptop>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org>
 <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com>
 <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com>
 <16043.1341483625@neuling.org> <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
 <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org>
 <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com>
 <29711.1341545979@neuling.org> <30343.1341546469@neuling.org>
 <CAPXgP10JthGjZyqD6gqn2n1rPu1uP+=mem_T-iOritXAQMstRQ@mail.gmail.com>
 <21892.1341608647@neuling.org> <1341770155.1011.27.camel@mop> <1341870165.6118.42.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 10 Jul 2012 00:10:17 +0200
Message-ID: <CAPXgP11Qsj9yGM5nSbRJ_YPFZcr2Km6w4R8wPGU1AytyQChYXQ@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Joe Perches <joe@perches.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 11:42 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2012-07-08 at 19:55 +0200, Kay Sievers wrote:
>
>> At the same time the CPU#2 prints the same warning with a continuation
>> line, but the buffer from CPU#1 can not be flushed to the console, nor
>> can the continuation line printk()s from CPU#2 be merged at this point.
>> The consoles are still locked and busy with replaying the old log
>> messages, so the new continuation data is just stored away in the record
>> buffer as it is coming in.
>> If the console would be registered a bit earlier, or the warning would
>> happen a bit later, we would probably not see any of this.
>>
>> I can fake something like this just by holding the console semaphore
>> over a longer time and printing continuation lines with different CPUs
>> in a row.
>>
>> The patch below seems to work for me. It is also here:
>>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-merge-cont.patch;hb=HEAD
>>
>> It only applies cleanly on top of this patch:
>>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-syslog-1-byte-read.patch;hb=HEAD
>>
>
> Hi Kay.
>
> I just ran a test with what's in Greg's driver-core -for-linus branch.
>
> One of the differences in dmesg is timestamping of consecutive
>         pr_<level>("foo...)
> followed directly by
>         pr_cont("bar...")
>
> For instance: (dmesg is 3.4, dmesg.0 is 3.5-rc6+)
>
> # grep MAP /var/log/dm* -A1
> dmesg:[    0.781687] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> dmesg-[    0.781707] ata2: port disabled--ignoring
> --
> dmesg.0:[    0.948881] ata_piix 0000:00:1f.2: MAP [
> dmesg.0-[    0.948883]  P0 P2 P1 P3 ]
>
> These messages originate starting at
> drivers/ata/ata_piix.c:1354
>
> All the continuations are emitted with pr_cont.
>
> I think this output should still be coalesced without
> timestamp deltas.  Perhaps the timestamping code can
> still be reworked to avoid too small a delta producing
> a new timestamp and another dmesg line.

Hmm, I don't see that.

If I do:
  pr_info("[");
  for (i = 0; i < 4; i++)
       pr_cont("%i ", i);
  pr_cont("]\n");

I get:
  6,173,0;[0 1 2 3 ]

And if I fill the cont buffer and forcefully hold the console sem
during all that, and we can't merge anymore, I get:
  6,167,0;[
  4,168,0;0
  4,169,0;1
  4,170,0;2
  4,171,0;3
  4,172,0;]

But the output is still all fine for both lines:
  [    0.000000] [0 1 2 3 ]
  [    0.000000] [0 1 2 3 ]

What do I miss?

Kay
