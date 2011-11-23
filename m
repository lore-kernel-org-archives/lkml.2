Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1KWKML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:12:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1KWKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:12:09 -0500
Message-ID: <4ECCC6F3.8000403@suse.cz>
Date: Wed, 23 Nov 2011 11:12:03 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111114 Thunderbird/9.0
MIME-Version: 1.0
To: Havard Skinnemoen <hskinnemoen@google.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: tty related lockdep trace during bootup on 3.2-rc2
References: <20111123033850.GA11380@redhat.com> <CAFQmdRYTgQOb53kQOvk1jubZbvaOrfjVCq4aG1H0ceshw2vVPA@mail.gmail.com>
In-Reply-To: <CAFQmdRYTgQOb53kQOvk1jubZbvaOrfjVCq4aG1H0ceshw2vVPA@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 08:28 AM, Havard Skinnemoen wrote:
> On Tue, Nov 22, 2011 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
>> From Linus' current tree...
>>
>> related to 5dc2470c602da8851907ec18942cd876c3b4ecc1 maybe ?
> 
> Yes, probably. I did have a bad feeling about the locking, but it
> seemed to behave well during testing. Wonder why I didn't see this.
> 
> So what's happening is that tty_open() holds big_tty_mutex while
> calling acm_tty_open which takes open_lock, and acm_tty_close holds
> open_lock while calling tty_port_close_start which takes
> big_tty_mutex?
> 
> Not sure how to solve this. Not taking the lock before calling
> tty_port_close_start means the tty_port may get freed before it
> returns.

Oh, how it can be? You should vhangup the device on disconnect. Then you
will be sure all close calls were performed before freeing the port.
Then you can free the port, right?

Like:
* forbid further opens
* tty_vhangup
* stop the device
* free the device state

Also it looks like you have a leak in disconnect when there are users
still. If I am looking correctly?

thanks,
-- 
js
suse labs
