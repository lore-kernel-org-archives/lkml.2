Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab1JNQf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:35:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63791 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1JNQf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <1318604775.1546.418.camel@vkoul-udesk3>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	<CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
	<CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
	<1318599079.1546.395.camel@vkoul-udesk3>
	<CAGsJ_4zSKwSm-En0TCacMTPhRG_YCaOC=aWcxF7rXWq26JcKuQ@mail.gmail.com>
	<1318604775.1546.418.camel@vkoul-udesk3>
Date: Fri, 14 Oct 2011 22:05:55 +0530
Message-ID: <CAJe_ZheL9EFNvPAU+shAjQG+mhOYQwXkdi1WpZ=kjn+0jWnuaw@mail.gmail.com>
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2011 20:36, Vinod Koul <vinod.koul@intel.com> wrote:
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
>
My proposed 'frm_irq' and 'cyclic' flags are for such requirements.

Consider a 5.1chan I2S controller that employs 3 dma-channels
each transferring 2 audio-channels to 3 three FIFOs. And the
pcm-dma driver supports SNDRV_PCM_INFO_INTERLEAVED.
While I worked with simple single fifo 5.1chan I2S controllers, I don't
think such 3-fifo controllers can't exist.
