Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2BGJ6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:58:33 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36819 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2BGJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:58:32 -0500
Message-ID: <4F30F5C4.6030003@suse.cz>
Date: Tue, 07 Feb 2012 10:58:28 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why are not processes HUPped when they open /dev/console?
References: <4F207660.500@suse.cz> <20120125214522.7a49cf39@pyramind.ukuu.org.uk> <4F2151FD.4050101@suse.cz> <20120206192406.GB28687@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20120206192406.GB28687@atrey.karlin.mff.cuni.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 08:24 PM, Pavel Machek wrote:
>> On 01/25/2012 10:45 PM, Alan Cox wrote:
>>> On Wed, 25 Jan 2012 22:38:40 +0100
>>> Jiri Slaby <jslaby@suse.cz> wrote:
>>>
>>>> Hello,
>>>>
>>>> don't you remember by a chance the reason for this test in __tty_hangup:
>>>>   if (filp->f_op->write != tty_write)
>>>>
>>>> The logic there is not to HUP processes that have this tty open via
>>>> /dev/console.
>>>
>>> Because if you hang up the console the machine crashes ?
>>>
>>> At least that's what used to happen.
>>
>> It does not crash anymore. However the system (systemd more precisely)
>> is confused a bit (well, a huge). So I suppose the test has its meaning.
>>
>> The whole exercise was about how to fix the userspace issue introduced
>> by the added infinite timeout.
> 
>> I think the proper solution here is just not to call vhangup in
>> userspace for the device which is /dev/console. It never worked anyway.
>> Because the HUP signal was never sent and it always timed out.
> 
> Perhaps the "infinite timeout" should be reverted, then? It sounds
> like a regression...

It *is* a regression in the shutdown path, yes. The point is that
previously it silently proceeded and freed the structures. This was
causing crashes. And it also misbehaved as it was supposed to wait for
all to vanish.

OTOH now it (possibly infinitely) waits for all of them. With the code
as it stands now, I cannot think of any other easy way to fix that. Do
what you have to. Revert, if you think occasional (nearly exceptional)
crashes are better than the regression...

thanks,
-- 
js
suse labs
