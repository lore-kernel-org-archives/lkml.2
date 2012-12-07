Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2LGAJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:09:57 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59323 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2LGAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:09:55 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVPbpbb-PAJAweoLj8uec=KgoUKvybSey+R=L=oY16Ozbw@mail.gmail.com>
References: <20120524021429.GB12557@kroah.com>
	<Pine.LNX.4.44L0.1205241029260.1349-100000@iolanthe.rowland.org>
	<CACVXFVPu_nbVCVR_HTt9H764+4JKC3=GPyhsf8Lpsch4Fa=xqQ@mail.gmail.com>
	<CANeycqo8sFVeWVEeW3mdPPVRt35+kfkdUzenLB+YgNs4y-T7Cg@mail.gmail.com>
	<CACVXFVPbpbb-PAJAweoLj8uec=KgoUKvybSey+R=L=oY16Ozbw@mail.gmail.com>
Date: Thu, 6 Dec 2012 16:09:54 -0800
Message-ID: <CANeycqq177AzPdYfBr-VU+ksh+Jwd9i4aLpZo6VwxcO+Xx6ETg@mail.gmail.com>
Subject: Re: Race condition between driver_probe_device and device_shutdown
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have the setup anymore, I'll give it a shot if I ever get back it back.

I have a question though: why do we need to get a reference to the
parent? If the assumption is that the callee can release its reference
to the parent, then one may also expect callees to reassign
dev->parent (e.g., by calling device_move), so it wouldn't be safe to
later call device_unlock on the potentially different dev->parent.

If we expect dev->parent to remain unchanged, then there's no need to
get an extra reference to the parent as the device itself already
holds one (and we hold an extra one on the device).

What am I missing?

Thanks

On Thu, Dec 6, 2012 at 2:52 AM, Ming Lei <ming.lei@canonical.com> wrote:
> On Thu, Dec 6, 2012 at 5:11 PM, Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
>> [Sorry for taking so long to respond, after a week of silence I
>> assumed I wouldn't get any responses, plus I had moved on to other
>> things.]
>>
>> I happen to still have the logs, the relevant part is pasted at the end.
>>
>> Answering some of the questions: the driver is on the platform bus, in
>> fact, it's drivers/usb/host/ehci-tegra.c; after seeing the oops below,
>> I added printks when entering and exiting tegra_ehci_probe to try to
>> understand it better.
>>
>> Note that in the log we see some thread entering tegra_ehci_probe, but
>> nothing indicates that it has exited before we get the oops.
>
> The commit d1c6c030fcec6f860d9bb6c632a3ebe62e28440b(driver core:
> fix shutdown races with probe/remove(v3)) has been merged to v3.6, so
> device_shutdown will wait for completing of probe.
>
> Could you test kernel 3.6 or the latest kernel to see if the problem can be
> reproduced?
>
> Thanks,
> --
> Ming Lei
