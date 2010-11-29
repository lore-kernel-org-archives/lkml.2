Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0K2Wlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:41:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63074 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0K2Wlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YiNEbfTC5rUlVhjulsdCIW8FIedKYU2mr72GNKiBTM61+QVPDQQjIjBtnxJLjDv83P
         pWMYlLiyxFTTb5klK0pF8Vn6xzt975+dLOzsyY4Y5XLRHdICDS0jxGX9Fdu3X72lBrtD
         iXV5h6kHo49x39HZ/L3r6R+JpNnklEcY9N6Hg=
Message-ID: <4CF42C29.4040702@suse.cz>
Date: Mon, 29 Nov 2010 23:41:45 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, slapin@ossfans.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 1/2] TTY: ldisc, fix open flag handling
References: <4CED9498.9080900@suse.cz> <1290641275-21726-1-git-send-email-jslaby@suse.cz> <20101129215030.GC9830@kroah.com>
In-Reply-To: <20101129215030.GC9830@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 10:50 PM, Greg KH wrote:
> On Thu, Nov 25, 2010 at 12:27:54AM +0100, Jiri Slaby wrote:
>> When a concrete ldisc open fails in tty_ldisc_open, we forget to clear
>> TTY_LDISC_OPEN. This causes a false warning on the next ldisc open:
>> WARNING: at drivers/char/tty_ldisc.c:445 tty_ldisc_open+0x26/0x38()
>> Hardware name: System Product Name
>> Modules linked in: ...
>> Pid: 5251, comm: a.out Tainted: G        W  2.6.32-5-686 #1
>> Call Trace:
>>  [<c1030321>] ? warn_slowpath_common+0x5e/0x8a
>>  [<c1030357>] ? warn_slowpath_null+0xa/0xc
>>  [<c119311c>] ? tty_ldisc_open+0x26/0x38
>>  [<c11936c5>] ? tty_set_ldisc+0x218/0x304
>> ...
>>
>> So clear the bit when failing...
>>
>> Introduced in c65c9bc3efa (tty: rewrite the ldisc locking) back in
>> 2.6.31-rc1.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Alan Cox <alan@linux.intel.com>
>> Reported-by: Sergey Lapin <slapin@ossfans.org>
>> Tested-by: Sergey Lapin <slapin@ossfans.org>
> 
> Is this still needed, or can I just use your:
> 	[PATCH v2 1/2] TTY: don't allow reopen when ldisc is changing
> patch instead?

This patch is still needed, it fixes a fail path.

Other than that there are 3 races in 2.6.36, one of them is introduced
in 2.6.36, the rest in 2.6.32. For each bug there is a single patch I sent:
* TTY: open/hangup race fixup
  - introduced in 2.6.36
  - open vs hangup race
* TTY: don't allow reopen when ldisc is changing
  - tiocsetd vs open race
* TTY: ldisc, fix open flag handling
  - this you are asking about
  - when ldisc->open fails, we blow up
* Char: TTY, restore tty_ldisc_wait_idle
  - this is in 37-rc2 already
  - multiple opens followed by tiocsetd blows the machine up

All of them are stable candidates (but I would give them some time in
HEAD to see if something breaks, since I opened a can of worms). The
first one is applicable only to 2.6.36 indeed.

thanks,
-- 
js
suse labs
