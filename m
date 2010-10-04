Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0JDIb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:31:59 -0400
Received: from tuxonice.net ([74.207.252.127]:54101 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab0JDIb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:31:58 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CA990FA.2070005@tuxonice.net>
Date: Mon, 04 Oct 2010 19:31:54 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-pm@lists.linux-foundation.org,
        Nigel Cunningham <nigelc@hera.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] Swsusp patches applied to suspend-2.6#linux-next
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>	<201010021849.54682.Martin@lichtvoll.de>	(sfid-20101002_195937_024324_44E143FB) <201010041000.33653.Martin@lichtvoll.de>
In-Reply-To: <201010041000.33653.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin.

On 04/10/10 19:00, Martin Steigerwald wrote:
> Am Samstag 02 Oktober 2010 schrieb Martin Steigerwald:
>> Am Montag 27 September 2010 schrieb Nigel Cunningham:
>>> Hi again Rafael.
>>
>> Hi Nigel and Rafael,
>>
>>> As discussed, here are the patches, modified to apply against your
>>> current linux-next tree. A new first patch splits compression support
>>> out into its own file, removing the need to have two versions of the
>>> load_image and save_image routines, minimising the changes to the
>>> remainder of the patches and making things cleaner than would
>>> otherwise be the case.
>>>
>>> On my laptop, single-threaded compression actually slows writing down
>>> from 175MB/s to around 100-120MB/s (depending on how well the image
>>> compresses). Reading speed improves from 218MB/s to around 245MB/s. I
>>> expect that multithreaded writing would bring the writing (and
>>> reading) speeds back up. It's on my swsusp to do list :)
>>
>> Testing this now
>> (2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069- dirty).
>
> Two times I had the rather strange issue that the machine booted freshly
> instead of resuming! First I thought I maybe didn't wait until the image
> was saved, before turning the laptop off. But now it happened a second time
> and also the ThinkPad T42 has a battery in it, thus it should always be
> able to complete writing the image.
>
> For resuming I found this in the syslog:
>
> Oct  4 09:19:10 shambhala kernel: end_request: I/O error, dev fd0, sector
> 0
> Oct  4 09:19:10 shambhala kernel: PM: Starting manual resume from disk
> Oct  4 09:19:10 shambhala kernel: PM: Resume from partition 8:2
> Oct  4 09:19:10 shambhala kernel: PM: Checking hibernation image.
> Oct  4 09:19:10 shambhala kernel: PM: Error -22 checking image file
> Oct  4 09:19:10 shambhala kernel: PM: Resume from disk failed.
> Oct  4 09:19:10 shambhala kernel: PM: Marking nosave pages:
> 000000000009f000 - 0000000000100000
> Oct  4 09:19:10 shambhala kernel: PM: Basic memory bitmaps created
> Oct  4 09:19:10 shambhala kernel: PM: Basic memory bitmaps freed
>
> What does error -22 mean?

-22 is -EINVAL. There are a few reasons that it could occur, but rather 
than chasing our tails, how about if I just tell you that I've been 
working on a new version of the patches that will provide more detailed 
debugging of issues like this (printks that can be enabled/disabled at 
run time) - and hopefully address your issue so it won't happen anyway.

> For hibernating:
>
> Oct  4 00:13:09 shambhala ifplugd(eth0)[15127]: Link beat lost.
> Oct  4 00:13:10 shambhala NetworkManager[2146]:<info>  (eth0): carrier now
> OFF (device state 1)
> Oct  4 00:13:12 shambhala ifplugd(eth0)[15127]: Exiting.
> Oct  4 00:13:14 shambhala postfix/master[2589]: reload -- version 2.7.1,
> configuration /etc/postfix
> Oct  4 00:13:14 shambhala dhclient: Internet Systems Consortium DHCP
> Client 4.1.1-P1
> Oct  4 00:13:14 shambhala dhclient: Copyright 2004-2010 Internet Systems
> Consortium.
> Oct  4 00:13:14 shambhala dhclient: All rights reserved.
> Oct  4 00:13:14 shambhala dhclient: For info, please visit
> https://www.isc.org/software/dhcp/
> Oct  4 00:13:14 shambhala dhclient:
> Oct  4 00:13:14 shambhala dhclient: Listening on
> LPF/eth0/00:11:25:46:ec:a5
> Oct  4 00:13:14 shambhala dhclient: Sending on
> LPF/eth0/00:11:25:46:ec:a5
> Oct  4 00:13:14 shambhala dhclient: Sending on   Socket/fallback
> Oct  4 00:13:15 shambhala dhclient: DHCPRELEASE on eth0 to 10.0.0.9 port
> 67
> Oct  4 00:13:18 shambhala kernel: PM: Marking nosave pages:
> 000000000009f000 - 0000000000100000
> Oct  4 00:13:18 shambhala kernel: PM: Basic memory bitmaps created
> Oct  4 00:13:18 shambhala kernel: PM: Syncing filesystems ... done.
> Oct  4 09:19:10 shambhala kernel: imklog 4.6.4, log source = /proc/kmsg
> started.
> Oct  4 09:19:10 shambhala rsyslogd: [origin software="rsyslogd"
> swVersion="4.6.4" x-pid="1964" x-info="http://www.rsyslog.com"] (re)start
> Oct  4 09:19:10 shambhala kernel: r hub
> Oct  4 09:19:10 shambhala kernel: usbcore: registered new device driver
> usb
>
> Which is not complete. It seems the last log messages prior to hibernating
> have not fully been written by rsyslog.

That's not unusual - after we do the atomic copy, nothing gets logged.

> Whats going on there? I didn't see this with Nigel's patches without the
> readahead patch. But then now I am testing suspend next + his patches,
> which may well contain other patches, as far as I understand.
>
> Any change to test with some newer state of suspend-next?
>
> Rafael did you integrate Nigel's patches in your tree?

We agreed not to yet - I'm splitting the compression support out 
properly, and will then post another version.

Regards,

Nigel
