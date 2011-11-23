Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1KWVIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:08:37 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59846 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1KWVIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:08:35 -0500
MIME-Version: 1.0
In-Reply-To: <4ECD4FCD.7040602@suse.cz>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
	<1322074412-10873-1-git-send-email-hskinnemoen@google.com>
	<4ECD4FCD.7040602@suse.cz>
Date: Wed, 23 Nov 2011 13:08:34 -0800
Message-ID: <CAFQmdRbP3qXc2n_Qto0o3Lg1280gg7mPHVSY28S8nBT39YPPQQ@mail.gmail.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:55 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 11/23/2011 07:53 PM, Havard Skinnemoen wrote:
>> --- a/drivers/usb/class/cdc-acm.c
>> +++ b/drivers/usb/class/cdc-acm.c
> ...
>> @@ -567,19 +574,10 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
>>
>>       /* Perform the closing process and see if we need to do the hardware
>>          shutdown */
>> -     if (!acm)
>> -             return;
>> -
>> -     mutex_lock(&open_mutex);
>>       if (tty_port_close_start(&acm->port, tty, filp) == 0) {
>
> Note that port->count is protected by port->lock usually. Till now it
> used to be protected by open_mutex in your driver. As of now it is not
> protected by anything. (Well, BTM is still there to save you, but...)

tty_port_close_start() takes port->lock, so if we try to do that,
we'll turn a potential deadlock into a real one. Or did you mean
something else?

I think I'll try to follow Alan's advice and use tty_port_close()
instead of the split functions. it shouldn't be too hard once we get
the lifecycle issues out of the way.

Havard
