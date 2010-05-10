Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0EJMHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0EJMHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:07:07 -0400
Message-ID: <4BE7F6D7.3060005@redhat.com>
Date: Mon, 10 May 2010 15:06:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: mtosatti@redhat.com, agraf@suse.de, yoshikawa.takuya@oss.ntt.co.jp,
       fernando@oss.ntt.co.jp, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
       kvm-ia64@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/12] KVM, x86, ppc, asm-generic: moving dirty bitmaps
 to user space
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 03:56 PM, Takuya Yoshikawa wrote:
> [Performance test]
>
> We measured the tsc needed to the ioctl()s for getting dirty logs in
> kernel.
>
> Test environment
>
>    AMD Phenom(tm) 9850 Quad-Core Processor with 8GB memory
>
>
> 1. GUI test (running Ubuntu guest in graphical mode)
>
>    sudo qemu-system-x86_64 -hda dirtylog_test.img -boot c -m 4192 -net ...
>
> We show a relatively stable part to compare how much time is needed
> for the basic parts of dirty log ioctl.
>
>                             get.org   get.opt  switch.opt
>
> slots[7].len=32768          278379     66398     64024
> slots[8].len=32768          181246       270       160
> slots[7].len=32768          263961     64673     64494
> slots[8].len=32768          181655       265       160
> slots[7].len=32768          263736     64701     64610
> slots[8].len=32768          182785       267       160
> slots[7].len=32768          260925     65360     65042
> slots[8].len=32768          182579       264       160
> slots[7].len=32768          267823     65915     65682
> slots[8].len=32768          186350       271       160
>
> At a glance, we know our optimization improved significantly compared
> to the original get dirty log ioctl. This is true for both get.opt and
> switch.opt. This has a really big impact for the personal KVM users who
> drive KVM in GUI mode on their usual PCs.
>
> Next, we notice that switch.opt improved a hundred nano seconds or so for
> these slots. Although this may sound a bit tiny improvement, we can feel
> this as a difference of GUI's responses like mouse reactions.
>    

100 ns... this is a bit on the low side (and if you can measure it 
interactively you have much better reflexes than I).

> To feel the difference, please try GUI on your PC with our patch series!
>    

No doubt get.org -> get.opt is measurable, but get.opt->switch.opt is 
problematic.  Have you tried profiling to see where the time is spent 
(well I can guess, clearing the write access from the sptes).

>
> 2. Live-migration test (4GB guest, write loop with 1GB buf)
>
> We also did a live-migration test.
>
>                             get.org   get.opt  switch.opt
>
> slots[0].len=655360         797383    261144    222181
> slots[1].len=3757047808    2186721   1965244   1842824
> slots[2].len=637534208     1433562   1012723   1031213
> slots[3].len=131072         216858       331       331
> slots[4].len=131072         121635       225       164
> slots[5].len=131072         120863       356       164
> slots[6].len=16777216       121746      1133       156
> slots[7].len=32768          120415       230       278
> slots[8].len=32768          120368       216       149
> slots[0].len=655360         806497    194710    223582
> slots[1].len=3757047808    2142922   1878025   1895369
> slots[2].len=637534208     1386512   1021309   1000345
> slots[3].len=131072         221118       459       296
> slots[4].len=131072         121516       272       166
> slots[5].len=131072         122652       244       173
> slots[6].len=16777216       123226     99185       149
> slots[7].len=32768          121803       457       505
> slots[8].len=32768          121586       216       155
> slots[0].len=655360         766113    211317    213179
> slots[1].len=3757047808    2155662   1974790   1842361
> slots[2].len=637534208     1481411   1020004   1031352
> slots[3].len=131072         223100       351       295
> slots[4].len=131072         122982       436       164
> slots[5].len=131072         122100       300       503
> slots[6].len=16777216       123653       779       151
> slots[7].len=32768          122617       284       157
> slots[8].len=32768          122737       253       149
>
> For slots other than 0,1,2 we can see the similar improvement.
>
> Considering the fact that switch.opt does not depend on the bitmap length
> except for kvm_mmu_slot_remove_write_access(), this is the cause of some
> usec to msec time consumption: there might be some context switches.
>
> But note that this was done with the workload which dirtied the memory
> endlessly during the live-migration.
>
> In usual workload, the number of dirty pages varies a lot for each iteration
> and we should gain really a lot for relatively clean cases.
>    

Can you post such a test, for an idle large guest?

-- 
error compiling committee.c: too many arguments to function

