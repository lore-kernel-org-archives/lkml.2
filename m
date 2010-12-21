Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab0LUMkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:40:23 -0500
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:60871 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0LUMkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:40:19 -0500
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Dec 2010 07:40:19 EST
From: Arto Jantunen <viiru@debian.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slow disks.
References: <fa.C+PyZdFdHUxRFDJDF3KlrfaJASk@ifi.uio.no>
Date: Tue, 21 Dec 2010 14:29:47 +0200
In-Reply-To: <fa.C+PyZdFdHUxRFDJDF3KlrfaJASk@ifi.uio.no> (Rogier Wolff's message of "Mon\, 20 Dec 2010 14\:16\:01 UTC")
Message-ID: <871v5bnwas.fsf@viiru.iki.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:

> Hi,
>
> A friend of mine has a server in a datacenter somewhere. His machine
> is not working properly: most of his disks take 10-100 times longer
> to process each IO request than normal. 
>
> iostat -kx 10 output: 
> Device: rrqm/s wrqm/s r/s  w/s  rkB/s wkB/s avgrq-sz avgqu-sz await svctm %util
> sdd     0.30   0.00   0.40 1.20 2.80  1.10  4.88     0.43  271.50 271.44  43.43
>
> shows that in this 10 second period, the disk was busy for 4.3 seconds
> and serviced 15-16 requests during that time.
>
> Normal disks show "svctm" of around 10-20ms. 
>
> Now you might say: It's his disk that's broken.
> Well no: I don't believe that all four of his disks are broken. 
> (I just showed you output about one disk, but there are 4 disks in there
> all behaving similar, but some are worse than others.)
>
> Or you might say: It's his controller that's broken. So we thought
> too. We replaced the onboard sata controller with a 4-port sata
> card. Now they are running off the external sata card... Slightly
> better, but not by much.
>
> Or you might say: it's hardware. But suppose the disk doesn't properly
> transfer the data 9 times out of 10, wouldn't the driver tell us
> SOMETHING in the syslog that things are not fine and dandy? Moreover,
> In the case above, 12kb were transferred in 4.3 seconds. If CRC errors
> were happening, the interface would've been able to transfer over
> 400Mb during that time. So every transfer would need to be retried on
> average 30000 times... Not realistic. If that were the case, we'd
> surely hit a maximum retry limit every now and then?

I had something somewhat similar happen on an Areca RAID card with four disks
in RAID5. The first symptom was that the machine was extremely slow, that
tracked down to IO being slow. By looking at the IO pattern it became apparent
that it was very bursty, it did a few requests and then froze for about 30
seconds and then did a few requests again.

It was tracked down to one of the disks being faulty in a way that did not get
it dropped out of the array. In this case when the machine was frozen and not
doing any IO the activity led on the faulty disk was constantly on, when it
came off a burst of IO happened.

I'm not sure what kind of a disk failure this was caused by, but you could
test for it either by simply monitoring the activity leds (may not show
anything in all cases, I don't know) or removing the disks one by one and
testing if the problem disappears. I didn't get much log output in this case,
I think the Areca driver was occasionally complaining about timeouts while
communicating with the controller.

-- 
Arto Jantunen
