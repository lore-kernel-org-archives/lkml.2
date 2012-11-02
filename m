Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2KBQSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:18:47 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61689 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab2KBQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:18:45 -0400
Message-ID: <5093F262.6000301@suse.cz>
Date: Fri, 02 Nov 2012 17:18:42 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz> <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz> <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com> <5091448D.3@suse.cz> <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com> <5093EC1B.2050800@suse.cz> <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com>
In-Reply-To: <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/mixed;
 boundary="------------010406010004010400080408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010406010004010400080408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/02/2012 05:07 PM, Sasha Levin wrote:
> On Fri, Nov 2, 2012 at 11:51 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 10/31/2012 04:59 PM, Sasha Levin wrote:
>>> So you probably want a lot more than 100k syscalls, why limit it at
>>> all actually?
>>
>> I unset the limit but I still can't reproduce...
>>
>>> I've attached my .config for the guest kernel as reference.
>>
>> Even using this config does not help to reproduce that.
>>
>> Do you use some special trinity params?
> 
> Not really:
> 
>     ./trinity -m --quiet --dangerous -l off

Oh, you run that as root??

> Can I add something to my kernel to provide more info when it happens?

Maybe the attached patch can tell us more...

-- 
js
suse labs

--------------010406010004010400080408
Content-Type: text/x-patch;
 name="0001-tty-BUF-DEBUG.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-tty-BUF-DEBUG.patch"

>From 36ad8f281846ef395e1969fc2af324c5edb13043 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Sun, 28 Oct 2012 21:42:02 +0100
Subject: [PATCH] tty BUF DEBUG

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 45d9161..c70274b 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -371,6 +371,7 @@ void tty_schedule_flip(struct tty_struct *tty)
 	if (buf->tail != NULL)
 		buf->tail->commit = buf->tail->used;
 	spin_unlock_irqrestore(&buf->lock, flags);
+	WARN_RATELIMIT(tty->port->itty == NULL, "HUH\n");
 	schedule_work(&buf->work);
 }
 EXPORT_SYMBOL(tty_schedule_flip);
@@ -566,6 +567,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
 		buf->tail->commit = buf->tail->used;
 	spin_unlock_irqrestore(&buf->lock, flags);
 
+	WARN_RATELIMIT(tty->port->itty == NULL, "HUH\n");
 	if (tty->low_latency)
 		flush_to_ldisc(&buf->work);
 	else
-- 
1.8.0


--------------010406010004010400080408--
