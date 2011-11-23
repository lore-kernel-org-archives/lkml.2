Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1KWVTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:19:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61828 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1KWVTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:19:53 -0500
Message-ID: <4ECD6375.5050404@suse.cz>
Date: Wed, 23 Nov 2011 22:19:49 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111114 Thunderbird/9.0
MIME-Version: 1.0
To: Havard Skinnemoen <hskinnemoen@google.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com> <1322074412-10873-1-git-send-email-hskinnemoen@google.com> <4ECD4FCD.7040602@suse.cz> <CAFQmdRbP3qXc2n_Qto0o3Lg1280gg7mPHVSY28S8nBT39YPPQQ@mail.gmail.com> <4ECD6198.20309@suse.cz>
In-Reply-To: <4ECD6198.20309@suse.cz>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 10:11 PM, Jiri Slaby wrote:
> On 11/23/2011 10:08 PM, Havard Skinnemoen wrote:
>> tty_port_close_start() takes port->lock, so if we try to do that,
>> we'll turn a potential deadlock into a real one. Or did you mean
>> something else?
> 
> I mean the other uses of port->count in your driver.
> 
>> I think I'll try to follow Alan's advice and use tty_port_close()
>> instead of the split functions.
> 
> Yes, that's indeed the best approach. However you have to use them all:
> tty_port_open, tty_port_hangup, tty_port_close. OR you would have to do
> the locking of count properly.

And I see now that the driver uses tty_port_hangup (count under
port->lock) and tty_port_close_start (count under open_mutex and
port->lock). But doesn't use tty_port_open (count under open_mutex and
acm->mutex). Hence there was always a race hangup vs. open wrt. port
counting.

thanks,
-- 
js
suse labs
