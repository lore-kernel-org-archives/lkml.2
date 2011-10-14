Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab1JNPis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:38:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63347 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab1JNPiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <1318604775.1546.418.camel@vkoul-udesk3>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
 <1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
 <CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
 <CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
 <1318599079.1546.395.camel@vkoul-udesk3> <CAGsJ_4zSKwSm-En0TCacMTPhRG_YCaOC=aWcxF7rXWq26JcKuQ@mail.gmail.com>
 <1318604775.1546.418.camel@vkoul-udesk3>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 14 Oct 2011 23:38:25 +0800
Message-ID: <CAGsJ_4y5m8G9MTi4q=CnpjtF4cyJWOVa6Xf-J+JQYo6MLHhUKQ@mail.gmail.com>
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
To: Vinod Koul <vinod.koul@intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Vinod Koul <vinod.koul@intel.com>:
> On Fri, 2011-10-14 at 22:55 +0800, Barry Song wrote:
>> Hi Vinod,
>>
>> 2011/10/14 Vinod Koul <vinod.koul@intel.com>:
>> > On Fri, 2011-10-14 at 17:21 +0530, Jassi Brar wrote:
>> >> On 14 October 2011 13:02, Barry Song <21cnbao@gmail.com> wrote:
>> >> >
>> >> > what if i want a cyclic interleaved transfer? i think the cyclic
>> >> > interleaved transfer is what i want for audio dma.
>> >> >
>> >> ... we need to restore 'bool frm_irq' and add new 'bool cyclic' that
>> >> would replay the transfer(i.e, reset dma-pointers to src_start & dst_start)
>> >> after 'numf' frames have been transferred.
>> > I was thinking more on lines to have this conveyed thru a flag.
>> >
>> > Anyway I plan to work on merging device_prep_slave_sg and
>> > device_prep_cyclic to single API. Think more of device_prep_cyclic as
>> > special case with sg length one and flag to tell dmac its cyclic.
>> >
>> > Similarly here we could use/define this flag to say this transfer is
>> > also cyclic in nature and dmac then reloads the list again.
>> > That way any prep can be made cyclic in nature by just using this flag.
>> >
>> > @Barry: Why would you need to use interleaved API for audio?
>>
>> At first, audio dma is typically cyclic. if no underflow and overflow
>> happens, it will always be running. underflow and overflow will
>> trigger the cyclic dma termination.
> Yes and you terminate dma. Then prepare will be called again and you
> setup DMA again and on trigger start you start DMA again.
> No need for interleaving in this case.
>>
>> in case audio PCM data is interleaved and saved in dma buffer  as below:
>>
>> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
>> left (2B)  right (2B)
>> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
>> left (2B)  right (2B)
>> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
>> left (2B)  right (2B)
>> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
>> left (2B)  right (2B)
>> ,,,,
>>
>> and some hardwares need two seperate dma channels to tranfer left and
>> right audio channel.
>>
>> For 1st and 2nd dma channel, they want dma address increases 4bytes
>> and transfer 2bytes every line.
>> so it looks to me like a cyclic interleaved dma.
> Hmmm, do we have sound cards which use this?
> Nevertheless for this kind of transfers we would need interleaved cyclic
> DMA as well, Do you have such usage? Can you tell me which codec
> requires this?

Vinod, actually it is not decided by codec. it is only related with
the hardware of pcm, i2s or AC'97 controllers in SoC. i did remember
some people  once licensed a TDM tranfer enginee from synopsys and IC
guys bound one TDM slot, which has a seperate  dma channel, to one
audio channel then organize several TDM slots into a AC97 controller.

i am on holiday now and i can't give you more information until next week.

Still i saw most other chips binding multi-channels of an I2S/PCM/AC97
audio controller in a dma channel, then it doesn't need interleaved
dma api as its dma address will increase continuously. dma will
transfer left+right together but not one left and one right.

>
>
> --
> ~Vinod

-barry
