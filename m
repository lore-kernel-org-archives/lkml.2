Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab2DJIwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:52:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56458 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2DJIwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:52:10 -0400
Message-ID: <4F83F4B6.3090503@suse.cz>
Date: Tue, 10 Apr 2012 10:52:06 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>, Keith Packard <keithp@keithp.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        daniel@ffwll.ch, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952> <4F75A303.3030409@suse.cz> <1333110296_156038@CP5-2952> <4F7F60BF.9070500@suse.cz>
In-Reply-To: <4F7F60BF.9070500@suse.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 11:31 PM, Jiri Slaby wrote:
> On 03/30/2012 02:24 PM, Chris Wilson wrote:
>> On Fri, 30 Mar 2012 14:11:47 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
>>> On 03/30/2012 12:45 PM, Chris Wilson wrote:
>>>> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
>>>>> I don't know what to dump more, because iir is obviously zero too. What
>>>>> other sources of interrupts are on the (G33) chip?
>>>>
>>>> IIR is the master interrupt, with chained secondary interrupt statuses.
>>>> If IIR is 0, the interrupt wasn't raised by the GPU.
>>>
>>> This does not make sense, the handler does something different. Even if
>>> IIR is 0, it still takes a look at pipe stats.
>>
>> That was introduced in 05eff845a28499762075d3a72e238a31f4d2407c to close
>> a race where the pipestat triggered an interrupt after we processed the
>> secondary registers and before reseting the primary.
>>
>> But the basic premise that we should only enter the interrupt handler
>> with IIR!=0 holds (presuming non-shared interrupt lines such as MSI).
> 
> Ok, this behavior is definitely new. I get several "nobody cared" about
> this interrupt a week. This never used to happen. And something weird
> emerges in /proc/interrupts when this happens:
>  42:    1003292    1212890   PCI-MSI-edge      �s����:0000:00:02.0
> instead of
>  42:    1006715    1218472   PCI-MSI-edge      i915@pci:0000:00:02.0

See the difference of drm_device->devname:

Before:
20 34 32 3a 20 20 20 20  31 34 30 35 34 36 32 20  | 42:    1405462 |
20 20 20 31 37 32 38 33  30 32 20 20 20 50 43 49  |   1728302   PCI|
2d 4d 53 49 2d 65 64 67  65 20 20 20 20 20 20 69  |-MSI-edge      i|
39 31 35 40 70 63 69 3a  30 30 30 30 3a 30 30 3a  |915@pci:0000:00:|
30 32 2e 30 0a                                    |02.0.|

After:
20 34 32 3a 20 20 20 20  31 30 30 33 32 39 32 20  | 42:    1003292 |
20 20 20 31 32 31 32 38  39 30 20 20 20 50 43 49  |   1212890   PCI|
2d 4d 53 49 2d 65 64 67  65 20 20 20 20 20 20 ef  |-MSI-edge      .|
bf bd 73 ef bf bd ef bf  bd ef bf bd ef bf bd 3a  |..s............:|
30 30 30 30 3a 30 30 3a  30 32 2e 30 0a           |0000:00:02.0.|

Any idea what "ef bf bd" pattern could be? And who *shifts* the
"0000:00:02.0" string?

thanks,

-- 
js
suse labs

