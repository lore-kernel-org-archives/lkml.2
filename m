Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2ABXcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 18:32:05 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35002 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001Ab2ABXcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 18:32:02 -0500
X-Sasl-enc: TGZZmu9lbcz3MW1d2tNU1EReSSXosinkAy1G1HXCfFHj 1325547122
Message-ID: <4F023E6B.2020307@fastmail.fm>
Date: Mon, 02 Jan 2012 23:31:55 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com> <20120102211904.GA15316@srcf.ucam.org> <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com> <20120102215028.GA15701@srcf.ucam.org> <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com> <20120102221235.GA16012@srcf.ucam.org> <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com> <20120102222920.GA16160@srcf.ucam.org> <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com> <20120102230037.GA16458@srcf.ucam.org>
In-Reply-To: <20120102230037.GA16458@srcf.ucam.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/12 23:00, Matthew Garrett wrote:
> On Mon, Jan 02, 2012 at 02:46:56PM -0800, Linus Torvalds wrote:
> 
>> It's *trivial* to attach the firmware driver and load the firmware
>> even if the firmware isn't needed - because you know it *will* be
>> needed if somebody suspends. Why not just do that? Why make up these
>> horrible problems that are totally irrelevant?
> 
> It means adding complexity to drivers that don't currently care about 
> it, and carrying that cost even for hardware that doesn't need it. It 
> can certainly be made to work, but it's inelegant. We could avoid this 
> specific instance of the problem by just punting responsibility to 
> userland instead.
> 
> It's clear that we can solve this. All I'm saying is that just making 
> the firmware loader cache things isn't a solution in itself. In this 
> specific case, it means merging the isight_firmware driver into 
> uvcvideo, which is something the uvcvideo maintainer didn't seem keen on 
> a few years ago.
> 

Rather than merging the drivers we could make the uvcvideo (or any other
generic driver) driver expose a "subdriver" interface that allows
another module to bind to the specific ID and add extra handling to
certain events. We could then use that interface to provide a firmware
driver for each device that needs it. The firmware driver could bind to
the bootstrap device and to the uvcvideo subdriver interface and it
would then have all the lifetime info we need. [Credit to Linus for
suggesting this idea]

You mensioned earlier about not being able to tell the difference
between a device that needs firmware and one that needs flash (e.g. they
use exactly the same ids). It doesn't really matter - we just assume
that it might need firmware and load it anyway. It uses more memory but
is robust.

Also, as Linus mensioned, for some devices we just don't care. For
example, if we drop a video call over suspend it's not ideal but it
doesn't prevent the system from resuming. Lets concentrate on fixing all
the cases that could prevent resume (the "99%") and fix the other
devices later.

Thanks,

Jack
