Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2CERMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:12:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58465 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2CERMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:12:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.34.20 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F54F3E8.1070404@suse.cz>
Date: Mon, 05 Mar 2012 18:12:08 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net
Subject: Re: [PATCH 67/68] TTY: isdn/gigaset, do not set tty->driver_data
 to NULL
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz> <1330955575-26641-68-git-send-email-jslaby@suse.cz> <4F54F270.8030108@imap.cc>
In-Reply-To: <4F54F270.8030108@imap.cc>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 06:05 PM, Tilman Schmidt wrote:
> Am 05.03.2012 14:52, schrieb Jiri Slaby:
>> Close the window in open where driver_data is reset to NULL on
>> each open. It could cause other processes to get invalid retval
>> from the tty->ops operations because of the checks all over the
>> code.
> 
>> With this change we may do other cleanups. Now, the only valid
>> check for tty->driver_data != NULL is in close. This can happen
>> only if open fails at gigaset_get_cs_by_tty or try_module_get.
>> The rest of checks in various tty->ops->* are invalid as
>> driver_data cannot be NULL there. The same holds for
>> cs->open_count. So remove them.
> 
> Thanks for that nice cleanup. It's most welcome. Just one question
> and a small nit:
> 
>> --- a/drivers/isdn/gigaset/interface.c +++
>> b/drivers/isdn/gigaset/interface.c
> [...]
>> @@ -178,12 +176,11 @@ static int if_open(struct tty_struct *tty,
>> struct file *filp)
> 
>> static void if_close(struct tty_struct *tty, struct file *filp) 
>> { -	struct cardstate *cs; +	struct cardstate *cs =
>> tty->driver_data; unsigned long flags;
> 
>> -	cs = (struct cardstate *) tty->driver_data; -	if (!cs) { -
>> pr_err("%s: no cardstate\n", __func__); +	if (!cs) { /* happens
>> if we didn't find cs in open */ +		printk(KERN_DEBUG "%s: no
>> cardstate\n", __func__); return; }
> 
> 
> Why are you downgrading the error message from KERN_ERR to
> KERN_DEBUG here? I would think that condition would warrant a
> message with KERN_ERR severity. Also, the driver does KERN_DEBUG
> output uniformly through the gig_dbg macro, so if you are sure it
> should be turned into a debug message then please write it as
> 
> gig_dbg(DEBUG_IF, "%s: no cardstate", __func__);
> 
> like four lines later.

<citing myself from the commit log>
Now, the only valid check for tty->driver_data != NULL is in close.
This can happen only if open fails at gigaset_get_cs_by_tty or
try_module_get.
</citing>

I.e. when the module behind the device is going away, driver_data can
be NULL. In that case we don't want to threaten the user by ERR messages.

You are maybe right, that we should switch it to gig_dbg or remove the
print completely (as it is a legitimate path). I'll wait until the
patches settles down a bit and fix it. If I, by a chance, forget to do
so, poke me or feel free to do it yourself ;).

thanks,
-- 
js
suse labs
