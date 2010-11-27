Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0K0PLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:11:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53189 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab0K0PLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:11:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=DLgAGcm1bDcVdrlOk3G/ju4x9h1XtY8fdlETR/zijOkUsSrlv9cP07RKLlCTQl9isJ
         6dxnpdb6ZOYO0RAS+CuMykvxWGgELf0xS6GddFxU4XBLC1Cpmoc/T+AQDdeK7EzLyvxS
         SvIZhq0k4N6fv/C6zTdA1Gh8wLeZAPjOad0zA=
Message-ID: <4CF11F8A.1050200@suse.cz>
Date: Sat, 27 Nov 2010 16:11:06 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
CC: Kyle McMartin <kyle@mcmartin.ca>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
References: <4CEE93FF.3040507@suse.cz> <1290705383-6608-1-git-send-email-jslaby@suse.cz> <20101126002840.GL22651@bombadil.infradead.org> <4CEF65CA.9020403@suse.cz> <20101127025954.GA15818@bombadil.infradead.org> <4CF0C65E.2010104@suse.cz> <4CF0D2DA.20105@suse.cz>
In-Reply-To: <4CF0D2DA.20105@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------050803090105000409000007"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050803090105000409000007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/27/2010 10:43 AM, Jiri Slaby wrote:
> On 11/27/2010 09:50 AM, Jiri Slaby wrote:
>> On 11/27/2010 03:59 AM, Kyle McMartin wrote:
>>> I'm poking around to see, I think maybe something might be dropping
>>> locks in the callchain that gives us a window where this might be
>>> possible...
>>
>> Of course, that's the case:
>>         clear_bit(TTY_LDISC, &tty->flags);
>>         tty_unlock();
>>         cancel_delayed_work_sync(&tty->buf.work);
>>         mutex_unlock(&tty->ldisc_mutex);
>>
>>         tty_lock();
>>         mutex_lock(&tty->ldisc_mutex);
>>
>> in tty_ldisc_hangup. Hence my point 1) from previous posts doesn't hold too:
>> 1) __tty_hangup from tty_ldisc_hangup to tty_ldisc_enable. During this
>> section tty_lock is held.
>>
>> I will check, how to fix this.
> 
> Reproducible with 2 running processes from the attachment.

Is it fixed with the attached proof-of-concept patch?

So you need:
THIS ONE
TTY: don't allow reopen when ldisc is changing
TTY: ldisc, fix open flag handling
Char: TTY, restore tty_ldisc_wait_idle

The last one is in 2.6.37-rc2 already.

thanks,
-- 
js
suse labs

--------------050803090105000409000007
Content-Type: text/x-patch;
 name="0001-TTY-open-hangup-race-fixup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-TTY-open-hangup-race-fixup.patch"

>From 9e88e8b9915b5e067507a087437d80e6a133d612 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Sat, 27 Nov 2010 16:06:46 +0100
Subject: [PATCH 1/1] TTY: open/hangup race fixup


Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c |   10 +++++++++-
 include/linux/tty.h  |    1 +
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 878f6d6..35480dd 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -559,6 +559,9 @@ void __tty_hangup(struct tty_struct *tty)
 
 	tty_lock();
 
+	/* some functions below drop BTM, so we need this bit */
+	set_bit(TTY_HUPPING, &tty->flags);
+
 	/* inuse_filps is protected by the single tty lock,
 	   this really needs to change if we want to flush the
 	   workqueue with the lock held */
@@ -578,6 +581,10 @@ void __tty_hangup(struct tty_struct *tty)
 	}
 	spin_unlock(&tty_files_lock);
 
+	/*
+	 * it drops BTM and thus races with reopen
+	 * we protect the race by TTY_HUPPING
+	 */
 	tty_ldisc_hangup(tty);
 
 	read_lock(&tasklist_lock);
@@ -615,7 +622,6 @@ void __tty_hangup(struct tty_struct *tty)
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
-	set_bit(TTY_HUPPED, &tty->flags);
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 
 	/* Account for the p->signal references we killed */
@@ -641,6 +647,7 @@ void __tty_hangup(struct tty_struct *tty)
 	 * can't yet guarantee all that.
 	 */
 	set_bit(TTY_HUPPED, &tty->flags);
+	clear_bit(TTY_HUPPING, &tty->flags);
 	tty_ldisc_enable(tty);
 
 	tty_unlock();
@@ -1311,6 +1318,7 @@ static int tty_reopen(struct tty_struct *tty)
 	struct tty_driver *driver = tty->driver;
 
 	if (test_bit(TTY_CLOSING, &tty->flags) ||
+			test_bit(TTY_HUPPING, &tty->flags) ||
 			test_bit(TTY_LDISC_CHANGING, &tty->flags))
 		return -EIO;
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 032d79f..54e4eaa 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -366,6 +366,7 @@ struct tty_file_private {
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
 #define TTY_FLUSHING		19	/* Flushing to ldisc in progress */
 #define TTY_FLUSHPENDING	20	/* Queued buffer flush pending */
+#define TTY_HUPPING 		21	/* ->hangup() in progress */
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
-- 
1.7.3.1


--------------050803090105000409000007--
