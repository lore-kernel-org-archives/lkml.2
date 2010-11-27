Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0K0Iuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:50:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43302 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0K0Iun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:50:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Dp7Z+kl8ozU6IQ9ADNqVyQlKHlDuIiwNlhzVDFOTzNv7zAYN4XgdA2NEYDpyrGT4JO
         9E7YSB1nRpCdJ9sMQOZFy46caZcImHn81UqjFfKXSx33RoC7Gaa/LC0dXlK6yklUKlS2
         ZLP+Y6MVpuhZW0pzBb6kLOKnORgs67htbbwpA=
Message-ID: <4CF0C65E.2010104@suse.cz>
Date: Sat, 27 Nov 2010 09:50:38 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
References: <4CEE93FF.3040507@suse.cz> <1290705383-6608-1-git-send-email-jslaby@suse.cz> <20101126002840.GL22651@bombadil.infradead.org> <4CEF65CA.9020403@suse.cz> <20101127025954.GA15818@bombadil.infradead.org>
In-Reply-To: <20101127025954.GA15818@bombadil.infradead.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2010 03:59 AM, Kyle McMartin wrote:
> I'm poking around to see, I think maybe something might be dropping
> locks in the callchain that gives us a window where this might be
> possible...

Of course, that's the case:
        clear_bit(TTY_LDISC, &tty->flags);
        tty_unlock();
        cancel_delayed_work_sync(&tty->buf.work);
        mutex_unlock(&tty->ldisc_mutex);

        tty_lock();
        mutex_lock(&tty->ldisc_mutex);

in tty_ldisc_hangup. Hence my point 1) from previous posts doesn't hold too:
1) __tty_hangup from tty_ldisc_hangup to tty_ldisc_enable. During this
section tty_lock is held.

I will check, how to fix this.

thanks,
-- 
js
suse labs
