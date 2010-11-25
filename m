Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0KYQpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:45:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44357 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0KYQoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:44:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IKt0WLMPwBA1jj9MYGCGRbsoeJCm19aH748mXrggqLhCx9IPuA7utl3731I6Ci3qWp
         veNyVxF81A5cr/Hza+Z1a/+VD7I8D5UJ/RlRGxi+WKZAtKWSvIg5huy9lq1p2J0qVeJZ
         P4tNvGDU0LIet0i+X5IQcJ6tTvGsL32dgZhDU=
Message-ID: <4CEE9280.9050504@suse.cz>
Date: Thu, 25 Nov 2010 17:44:48 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: Re: mmotm 2010-11-23 - WARNING: at drivers/tty/tty_io.c:1331
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org> <5747.1290574539@localhost> <20101125151436.GG22651@bombadil.infradead.org>
In-Reply-To: <20101125151436.GG22651@bombadil.infradead.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 04:14 PM, Kyle McMartin wrote:
> On Tue, Nov 23, 2010 at 11:55:39PM -0500, Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 23 Nov 2010 16:13:06 PST, akpm@linux-foundation.org said:
>>> The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> Seen during boot:
>>
>> [   23.015448] Modules linked in:
>> [   23.015453] Pid: 1207, comm: plymouthd Not tainted 2.6.37-rc3-mmotm1123 #3
>> [   23.015455] Call Trace:
> 
> I've been trying to figure this one out for a while, without much luck.
> (Users are seeing it in 2.6.36 as well.)
> 
> I *think* (I added a rawhide debugging patch to print the tty->name)
> that plymouth is always opening tty7 to cause this. My guess is the BKL
> removal has exposed some kind of race, but it's not obvious to me (and
> there's many other bugs to sort through too. :(
> 
> CC-ing Jiri since he seems to be the poor guy who's been poking this
> recently (there's a good few threads about this (though the others look
> like an ldisc attach race...)) I wouldn't think that's the case here
> since N_TTY is the default...

Ok, tty_reopen is called without TTY_LDISC set. For further
considerations, note tty_lock is held in tty_open. TTY_LDISC is cleared in:

1) __tty_hangup from tty_ldisc_hangup to tty_ldisc_enable. During this
section tty_lock is held.

2) tty_release via tty_ldisc_release till the end of tty existence. If
tty->count <= 1, tty_lock is taken, TTY_CLOSING bit set and then
tty_ldisc_release called. tty_reopen checks TTY_CLOSING before checking
TTY_LDISC.

3) tty_set_ldisc from tty_ldisc_halt to tty_ldisc_enable. We take
tty_lock, set TTY_LDISC_CHANGING, put tty_lock, do some other work, take
tty_lock, call tty_ldisc_enable, put tty_lock.

So the only option I see is 3) and we should do:
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1310,7 +1310,8 @@ static int tty_reopen(struct tty_struct *tty)
 {
        struct tty_driver *driver = tty->driver;

-       if (test_bit(TTY_CLOSING, &tty->flags))
+       if (test_bit(TTY_CLOSING, &tty->flags) ||
+                       test_bit(TTY_LDISC_CHANGING, &tty->flags))
                return -EIO;

        if (driver->type == TTY_DRIVER_TYPE_PTY &&

Alan, Greg?

thanks,
-- 
js
suse labs
