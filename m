Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2KCRye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 13:54:34 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47769 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2KCRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 13:54:33 -0400
Message-ID: <50953E8D.9000504@suse.cz>
Date: Sat, 03 Nov 2012 16:55:57 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz> <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz> <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com> <5091448D.3@suse.cz> <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com> <5093EC1B.2050800@suse.cz> <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com> <5093F262.6000301@suse.cz> <50947B7B.8080601@gmail.com>
In-Reply-To: <50947B7B.8080601@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/mixed;
 boundary="------------090000070301080804040707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090000070301080804040707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/03/2012 03:03 AM, Sasha Levin wrote:
> On 11/02/2012 12:18 PM, Jiri Slaby wrote:
>> On 11/02/2012 05:07 PM, Sasha Levin wrote:
>>> On Fri, Nov 2, 2012 at 11:51 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>> On 10/31/2012 04:59 PM, Sasha Levin wrote:
>>>>> So you probably want a lot more than 100k syscalls, why limit it at
>>>>> all actually?
>>>>
>>>> I unset the limit but I still can't reproduce...
>>>>
>>>>> I've attached my .config for the guest kernel as reference.
>>>>
>>>> Even using this config does not help to reproduce that.
>>>>
>>>> Do you use some special trinity params?
>>>
>>> Not really:
>>>
>>>     ./trinity -m --quiet --dangerous -l off
>>
>> Oh, you run that as root??
>>
>>> Can I add something to my kernel to provide more info when it happens?
>>
>> Maybe the attached patch can tell us more...
>>
> 
> Nope, I see the warnings mentioned before, without the new 'HUH' warnings.

Actually it does. It is exactly as you wrote some time earlier. The work
is scheduled after is was cancelled and should not trigger anymore. Or,
it is scheduled before it is supposed to do. Could you try the attached
patch and report what happens with that patch?

PS I can't reproduce by whatever I tried.

thanks,
-- 
js
suse labs

--------------090000070301080804040707
Content-Type: text/x-patch;
 name="0001-tty-debug-part-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-tty-debug-part-2.patch"

>From eeffa986dfd4ffcca1ed3332ffd3ff4645a4cf1d Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Sat, 3 Nov 2012 16:49:29 +0100
Subject: [PATCH] tty debug part 2

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c        | 2 +-
 drivers/tty/tty_buffer.c | 2 +-
 drivers/tty/tty_io.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 4219f04..7438589 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -372,7 +372,7 @@ static void pty_unix98_shutdown(struct tty_struct *tty)
 
 static void pty_cleanup(struct tty_struct *tty)
 {
-	tty->port->itty = NULL;
+	tty->port->itty = ERR_PTR(-2);
 	kfree(tty->port);
 }
 
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index ef020e2..a672f67 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -471,7 +471,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	struct tty_ldisc *disc;
 
 	tty = port->itty;
-	if (WARN_RATELIMIT(tty == NULL, "tty is NULL"))
+	if (WARN_RATELIMIT(IS_ERR_OR_NULL(tty), "tty is bad=%ld ops=%ps", PTR_ERR(tty), port->ops))
 		return;
 
 	disc = tty_ldisc_ref(tty);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index a3eba7f..d06b978 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1553,7 +1553,7 @@ static void release_tty(struct tty_struct *tty, int idx)
 		tty->ops->shutdown(tty);
 	tty_free_termios(tty);
 	tty_driver_remove_tty(tty->driver, tty);
-	tty->port->itty = NULL;
+	tty->port->itty = ERR_PTR(-1);
 
 	if (tty->link)
 		tty_kref_put(tty->link);
-- 
1.8.0


--------------090000070301080804040707--
