Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3AFMrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 07:47:10 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:34967 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3AFMrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 07:47:07 -0500
Message-ID: <50E9722D.2090602@ahsoftware.de>
Date: Sun, 06 Jan 2013 13:46:37 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] fb: udlfb: fix scheduling while atomic.
References: <50E81166.6050605@ahsoftware.de> <1357386129-763-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1357386129-763-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.01.2013 12:42, schrieb Alexander Holler:
> The console functions are using spinlocks while calling fb-driver ops
> but udlfb waits for a semaphore in many ops. This results in the BUG
> "scheduling while atomic". One of those call flows is e.g.
>
> vt_console_print() (spinlock printing_lock)
> 	(...)
> 	dlfb_ops_imageblit()
>                          dlfb_handle_damage()
>                                  dlfb_get_urb()
> 					down_timeout(semaphore)
> BUG: scheduling while atomic
> (...)
> vt_console_print() (release spinlock printing_lock)
>
> Fix this through a workqueue for dlfb_handle_damage().
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>


Having had a second look at my patch for udlfb, I'm not sure it will 
work with more than one of those devices attached. I think my approach 
to just add one (static) workqueue might not work in such a case, at 
least it looks so to me. But I'm unable to test it, as I only have one 
of those devices.

Having had a look at udl, I wonder why udlfb still has to be around. But 
because udl currently doesn't work here too, I'm not sure what 
functionality udl misses which udlfb still has.

So to conclude, my patch works as a workaround if only one of those 
devices will be attached, but currently should not be included into the 
kernel.

I don't know if I will make another version of that patch, as I will 
first have a deeper look at udl (if I find the time).

Regards,

Alexander

