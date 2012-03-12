Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2CLVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:09:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35540 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753551Ab2CLVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:09:27 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18ecFAyaPUeaEh7lCj3KebmogpAOGpjJqiN4x2Wn3
	wCJBA7178oyEbw
Message-ID: <4F5E6600.2070806@gmx.de>
Date: Mon, 12 Mar 2012 22:09:20 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Octavian Purdila <opurdila@ixiacom.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frank Danapfel <fdanapfe@redhat.com>, Laszlo Ersek <lersek@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: [PATCH] enhance usability of /proc/sys/net/ipv4/ip_local_reserved_ports
References: <4F5BE563.9050506@gmx.de> <1331523759.1932.13.camel@cr0>
In-Reply-To: <1331523759.1932.13.camel@cr0>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 04:42 AM, Cong Wang wrote:
> On Sun, 2012-03-11 at 00:36 +0100, Helge Deller wrote:
>> When writing to the ip_local_reserved_ports proc file it will currently clear
>> all previously reserved ports and update the current list with the one given
>> in the input.
>>
>> This behaviour makes it's usage quite hard, for example:
>> a) The generic proc filesystem limitation of only handle up to PAGE_SIZE-1
>>     characters at maximum may not be sufficient to provide all your wished-to-
>>     be-reserved ports at once.
>
> Yes, this should be extended IMHO.

Yes, known problem and not easy to fix.

>> b) There is no easy way to disable specific given ports, you always need to
>>     give the full port list at once. This makes shell scripting hard, since
>>     you need to parse everything yourself.
>> c) There is no easy way to just add specific ports or port ranges. Again,
>>     this would be useful for shell scripts.
>>
>
> These could be calculated in user-space, although it maybe not as easy
> as you want.

Right.

>> The following patch solves this problem by simply extending the parser
>> in proc_do_large_bitmap() to accept the keywords "add" and "release" in front
>> of given ports or port ranges and to either add or drop the given ports
>> from the already existing list.
>
> This looks a little odd, because we do "magic" things with a sysctl
> file, which is supposed to be plain text file. Do we have existing
> examples?

I don't think the networking sysctl has such tunables.
Overall, ip_local_reserved_ports is the only user of the
large_bitmap function and as such you can't compare the
input/output of this file with other sysctl files which
operate on a limited number of integers/booleans/strings only.
Furthermore my patch does not remove the "plain text"
behaviour of this file. You can still echo plain ports or
port lists into it and a "cat" gives you the same output
as before. It just extends the interface to add/remove
ports more easily if you want.

One somewhat comparable proc file which comes to my mind in this
regard is /proc/scsi/scsi where you can echo commands like
"scsi report-devs 1" and which then reacts. A user of this
interface is e.g. the known rescan-scsi-bus shell script:
http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh-1.25

> BTW, as David mentioned, please Cc netdev next time.

Sure. I'll send an updated patch tomorrow and will CC netdev.

Thanks,
Helge
