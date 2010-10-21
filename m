Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab0JUVGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:06:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48984 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab0JUVF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KoXh0MBr8dXVrbs/JPztkREkhPJKc6AQIMgmZ6IL5fHKJcC7QGhCTobLT+Dgu3rZI3
         E4xeTHnT+QzV7DMyHUz+KLDx6XOKpAVanE0XoMBaXOqtYh1pi00uDWOdmJ2MYwdgg946
         LlTGagZS9LU/4Q0A5mpZQo/3QijWX0DmWFbog=
Message-ID: <4CC0AB32.1080609@gmail.com>
Date: Thu, 21 Oct 2010 23:05:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 1/1] Char: TTY, restore tty_ldisc_wait_idle
References: <1287669539-22644-1-git-send-email-jslaby@suse.cz> <AANLkTinZNekvQHn4FYm-aJqGziV_zeUkdwtWWDb09ofm@mail.gmail.com>
In-Reply-To: <AANLkTinZNekvQHn4FYm-aJqGziV_zeUkdwtWWDb09ofm@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 04:17 PM, Linus Torvalds wrote:
> On Thu, Oct 21, 2010 at 6:58 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> It was removed in 65b770468e98 (tty-ldisc: turn ldisc user count into
>> a proper refcount), but we need to wait for last user to quit the
>> ldisc before we close it in tty_set_ldisc.
>>
>> Otherwise weird things start to happen. There might be processes
>> waiting in tty_read->n_tty_read on tty->read_wait for input to appear
>> and at that moment, a change of ldisc is fatal. n_tty_close is called,
>> it frees read_buf and the waiting process is still in the middle of
>> reading and goes nuts after it is woken.
> 
> Hmm. Looks reasonable. And the waiting is outside the lock, so there
> aren't any of the problem cases that caused the original changes. And
> we don't need the lock, because the TTY_LDISC_CHANGING bit will
> protect against anything new coming in, so we don't have races with
> the count going up afterwards.
> 
> And you're right about the lockless approach being reasonable inside
> the testing code too - it's atomic as you say, and we don't touch/care
> about anything else.
> 
> So I don't have any objections, apart from thinking that the ldisc
> code is apparently still too fragile if this is needed.  But the ldisc
> change is so special that I don't think this is a unreasonable hack.
> Even if it _is_ a bit of a hack still.

Actually the fail path handling should be more than in the patch.
Otherwise I get warnings here and there (TTY_LDISC is not set in
tty_open). Something like the diff below.

> So feel free to add an acked-by: from me. Whoever saw the problem
> should probably test the patch first, though.

Ok, thanks for the review, I fwded to people who hit the bug.





---
@@ -654,14 +659,16 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	flush_scheduled_work();

 	retval = tty_ldisc_wait_idle(tty);
+
+	tty_lock();
+	mutex_lock(&tty->ldisc_mutex);
+
+	/* handle wait idle failure locked */
 	if (retval) {
-		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 		tty_ldisc_put(new_ldisc);
-		return retval;
+		goto enable;
 	}

-	tty_lock();
-	mutex_lock(&tty->ldisc_mutex);
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
@@ -695,6 +702,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)

 	tty_ldisc_put(o_ldisc);

+enable:
 	/*
 	 *	Allow ldisc referencing to occur again
 	 */


thanks,
-- 
js
