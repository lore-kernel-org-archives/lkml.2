Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2ISLwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:52:21 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56158 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2ISLwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:52:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120918140213.GA27463@arwen.pp.htv.fi>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
	<20120918140213.GA27463@arwen.pp.htv.fi>
Date: Wed, 19 Sep 2012 14:52:18 +0300
Message-ID: <CANOLnONC1oDN3yu=ipao2A6MfuSkZfROVPewWLLEM5fNTKipxQ@mail.gmail.com>
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not suspended.
From: Grazvydas Ignotas <notasas@gmail.com>
To: balbi@ti.com
Cc: Sourav Poddar <sourav.poddar@ti.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, tony@atomide.com, khilman@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, paul@pwsan.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Sep 18, 2012 at 06:10:50PM +0530, Sourav Poddar wrote:
>> Greg's tty-next is not booting on 2420 based N800. The failure is
>> observed at serial init itself. The reason might be that n800 tries to
>> resume even though it is not suspended before.
>>
>> Reported-by: Paul Walmsley <paul@pwsan.com>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>
> FWIW:
>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
>
> Paul does this fix the issue for you ? Note that it depends on a
> previous patch Sourav sent [1]
>
> [1] http://marc.info/?l=linux-omap&m=134796819607889&w=2
>
> There's one thing that gets my attention, though, why only n800 would
> fail here ?
>
> I wonder if we should be using:
>
> pm_runtime_set_active(dev);
> pm_runtime_get_enable(dev);
>
> to prevent our runtime_resume() to be called from probe, but Sourav
> tested and it doesn't work on BeagleBoard, but it works on PandaBoard.
>
> Does it ring any bell ??

Well I guess it's normal resume callback is called during probe as
pm_runtime_get_sync() is called there, and according to documentation
[1], devices are assumed to be suspended before probe is called.

According to [1], pm_runtime_set_active() should be called before
pm_runtime_enable() to indicate to the core that device is active
during probe if that's the case, I guess this means
pm_runtime_get_sync() is not needed in that case, but I'm not sure
what's the actual serial state during probe nowadays.

[1] chapter 5 of Documentation/power/runtime_pm.txt:
The initial runtime PM status of all devices is 'suspended', but it
need not reflect the actual physical state of the device. Thus, if the
device is initially active (i.e. it is able to process I/O), its
runtime PM status must be changed to 'active', with the help of
pm_runtime_set_active(), before pm_runtime_enable() is called for the
device.

-- 
Gražvydas
