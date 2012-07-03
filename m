Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab2GCRIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:08:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43459 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2GCRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <1341323230.3292.10.camel@nayuki.kepstin.ca>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
 <1341323230.3292.10.camel@nayuki.kepstin.ca>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jul 2012 10:07:59 -0700
X-Google-Sender-Auth: 6zbfVVdJPw7pXFyEC753z4ozX1Q
Message-ID: <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 6:47 AM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
>
> I'm seeing the same issue, so I've given this a try. Here are the
> messages printed when floppy debugging is enabled:
>
> [    0.714318] floppy0: reschedule timeout lock fdc
> [   20.729798] floppy0: reschedule timeout do wakeup

Ok, that 20 s timeout is a hint.

20s is the floppy "max timeout" value, and it's used in various
places. HOWEVER. The "lock fdc" case absolutely should not be using
that timeout. It should use the floppy "UDP->timeout" value, which
should be just 3s. Which is still a long time, but not nearly as long
as that.

Can you add a DPRINT() to the lock_fdc() function just before calling
reschedule_timeout() to print out what the "drive" is? Something like
yhhis (whitespace-damaged due to cut-and-paste):

    diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
    index cce7df367b79..00b52cef9d22 100644
    --- a/drivers/block/floppy.c
    +++ b/drivers/block/floppy.c
    @@ -876,6 +876,7 @@ static int lock_fdc(int drive, bool interruptible)

     	command_status = FD_COMMAND_NONE;

    +	DPRINT("lock_fdc: %d (out of %d)\n", drive, N_DRIVE);
     	reschedule_timeout(drive, "lock fdc");
     	set_fdc(drive);
     	return 0;

because maybe the 'drive' variable is crap there. In fact, add a

        WARN_ON_ONCE(dive < 0 || drive >= N_DRIVE);

in there too. Because if it is out of range, I'd want to see the call chain.

(And you still need floppy=debug to see that debug message, of course).

                Linus
