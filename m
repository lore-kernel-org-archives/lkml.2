Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab2BJUei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:34:38 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:36443 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139Ab2BJUeg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:34:36 -0500
From: Philip Rakity <prakity@marvell.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Pierre Ossman <pierre@ossman.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "arindam.nath@amd.com" <arindam.nath@amd.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>
Date: Fri, 10 Feb 2012 12:28:10 -0800
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
Thread-Topic: mmc sdhci mmcblk0: error -110 sending status command, retrying
Thread-Index: AczoMoIQTtFjI1iOQgiiuHI0eARKQw==
Message-ID: <4B11A480-8122-4A0B-A0EE-E1E95477F985@marvell.com>
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
 <m2pqdr2tyq.fsf@bob.laptop.org>
 <CAAJw_Zv4Hk_kfc33xsVcdi-0_C6tsf_FD3sUx1JPDX_fZZMzeQ@mail.gmail.com>
 <4F30E19B.9020503@intel.com>
 <CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
 <4F310529.4020101@intel.com>
 <CAAJw_ZsHwdvXuw+edXUfyGOSMOu5oUw3zX8nUryxJJiiZXzXKQ@mail.gmail.com>
 <CAAJw_Zup7Wg7FO95Z63e_sniu21gyzdCjcBNgsS0aw6MguDwLw@mail.gmail.com>
 <CAAJw_Zv6HkLLqEzNKRCfQ7EbMNEVe_hzbW+mHOnDAWLidOhMBQ@mail.gmail.com>
 <CAAJw_Zs7aET=vdy033bzuHwW==uS8AW78NSvD2L_hjU+Mzp-_w@mail.gmail.com>
 <4F31B789.9020509@samsung.com>
 <CAAJw_ZtnWYxGCm5Vm5CQ1GBLc=GU7AGiQKe_-9LJsbMW+YG-GQ@mail.gmail.com>
 <15D4F59C-7AFA-456E-8A5F-9E11EE9B9717@marvell.com>
 <CAAJw_Zs+Jz9WiJd6254Zkj+Y76w9W3CqZTgGrLYRRsjuxnqTyw@mail.gmail.com>
In-Reply-To: <CAAJw_Zs+Jz9WiJd6254Zkj+Y76w9W3CqZTgGrLYRRsjuxnqTyw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10, 2012, at 8:18 AM, Jeff Chua wrote:

> On Thu, Feb 9, 2012 at 3:09 AM, Philip Rakity <prakity@marvell.com> wrote:
>> 
>> 
>> Jeff,
>> 
>> I think the sdhci.c clock setting code was changed a while ago.   Maybe revert that mod and see what happens.
>> 
>> The card is a 24MHz which is rather slow so I would be surprised if that was it.
>> The other option is the force enable the High Speed bit in the  controller (used when speed is 25MHz or faster).  Will give the system more time (in theory) to work.
> 
> That's a good point to start looking. I poked around and by setting
> host->ios.clock to 10000000 instead of 25000000, read from a 16GB card
> is no longer giving any error.
> 
> I still don't dare to do any write. Already burn one 16GB SD and not
> ready to trash another. I asked earlier but haven't got any reply as
> to how to recover an SD that says "No medium found". Any chance of
> recovering it?
> 
> Here's what I did. If set too low (1000000) or too high (25000000),
> random errors appeared.
> 
> --- linux/drivers/mmc/core/core.c.org   2012-02-10 23:57:49.000000000 +0800
> +++ linux/drivers/mmc/core/core.c       2012-02-10 23:53:59.000000000 +0800
> @@ -881,7 +881,7 @@
>        if (hz > host->f_max)
>                hz = host->f_max;
> 
> -       host->ios.clock = hz;
> +       host->ios.clock = 10000000;
>        mmc_set_ios(host);
> }
> 
> 

good news.  The other possibility but unlikely is that the timeout is too low for the card.

There is a quirk for this.

SDHCI_BROKEN_TIMEOUT_VAL

my guess is that you will need to measure the clk pin and see if it matches the frequency being programmed.  (could be less).

a simple hack is to add a printk to set_ios() or set_clock() and print out the clock rate clock register (divider) and see if they match what you should be seeing.
It is possible the bug is NOT in this area but in the platform code where an incorrect base freq is being setup for the controller.

Philip

> 
> Thanks,
> Jeff

