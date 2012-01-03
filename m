Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2ACI25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:28:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab2ACI2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:28:53 -0500
Date: Tue, 3 Jan 2012 09:26:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jack Stone <jwjstone@fastmail.fm>, Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20120103082627.GA13214@elte.hu>
References: <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org>
 <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org>
 <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
 <20120102222920.GA16160@srcf.ucam.org>
 <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
 <20120102230037.GA16458@srcf.ucam.org>
 <4F023E6B.2020307@fastmail.fm>
 <20120103001851.3530f99d@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103001851.3530f99d@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > You mensioned earlier about not being able to tell the 
> > difference between a device that needs firmware and one that 
> > needs flash (e.g. they use exactly the same ids). It doesn't 
> > really matter - we just assume that it might need firmware 
> > and load it anyway. It uses more memory but is robust.
> 
> We only need to do that for the devices where order and not 
> blocking matters. There are a few (and some are video) where 
> the firmware sizes is megabytes, which on an embedded 
> controlling device is not acceptable. I don't believe any of 
> them are things where simply delaying the restoration will 
> cause problems however - its video, and DVB and the like not 
> wireless or serial.

Here's the size histogram/analysis of all *.fw, *.bin, *.dat, 
*.ucode, etc. files in /lib/firmware on a fully populated 
distro:

 476 firmware blobs total

The toplist:

 -rw-r--r--. 1 root root 2786404 Jul 24  2010 ./bcm70012fw.bin
 -rw-r--r--. 1 root root 1781048 Feb  9  2011 ./phanfw.bin
 -rw-r--r--. 1 root root  864276 Jul 24  2010 ./bcm70015fw.bin
 -rw-r--r--. 1 root root  844980 Feb  8  2011 ./asihpi/dsp6200.bin
 -rw-r--r--. 1 root root  636980 Feb  8  2011 ./asihpi/dsp6600.bin
 -rw-r--r--. 1 root root  627696 Feb  8  2011 ./asihpi/dsp6400.bin
 -rw-r--r--. 1 root root  563592 Aug  4 22:04 ./myri10ge_rss_ethp_z8e.dat
 -rw-r--r--. 1 root root  553192 Aug  4 22:04 ./myri10ge_rss_eth_z8e.dat
 -rw-r--r--. 1 root root  504916 Feb  8  2011 ./asihpi/dsp8900.bin
 -rw-r--r--. 1 root root  498128 Sep  7 20:14 ./ct2fw.bin

 - 2% of them, i.e. just a tiny fraction is over 512 KB.
 - 80% of the firmware blobs are below 100K.
 - 50% of them are below 16K.

So loading them into RAM is the obviously right solution.

Those few devices that absolutely want to load the firmware blob 
dynamically on some weird low-RAM system can do so *BEFORE* 
suspending.

There is nothing that prevents a low-RAM system from loading the 
firmware blob in an early suspend callback and making sure it's 
there at resume time - and then unloading it from RAM after 
resume.

I.e. large blobs can manage their RAM usage just fine - but the 
obscenity of the 1% should not control the design and sanity of 
the 99% case ...

> [...]
> 
> The world is heading this way more and more. It's moving from 
> the old PC model of 'user closes lid, clunk for 15 seconds, 
> enter suspend, user opens lid, churn churn, video, churn 
> clunk. resume' to suspend/resume being so fast it happens 
> between keystrokes.

Exactly!

Thanks,

	Ingo
