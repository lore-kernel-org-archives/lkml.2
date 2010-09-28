Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0I1A1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:27:47 -0400
Received: from claw.goop.org ([74.207.240.146]:33764 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760043Ab0I1A1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:27:46 -0400
Message-ID: <4CA1367F.7040106@goop.org>
Date: Mon, 27 Sep 2010 17:27:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: Powertop shows events/0 waking at high rate due to ptys
References: <4CA0D660.3010804@goop.org> <20100927191536.1de29492@lxorguk.ukuu.org.uk>
In-Reply-To: <20100927191536.1de29492@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/27/2010 11:15 AM, Alan Cox wrote:
> Really the line discipline should wake the work queue when it sets
> tty->receive_room non-zero, but while only n_tty currently uses that
> facility the existing code doesn't do it in any kind of race-free manner
> and sometimes is only saved by the polling picking it up.
>
> It's all really just a symptom of the fact that input and output buffers
> shouldn't be attached to the tty in the first place but to a struct
> representing the physical port. Fix that and the race conditions in
> serial output go away, as do the potential crashes and this wakeup stuff
> as well as a ton of locking in the irq/tx/rx paths. In several cases it
> also saves you an entire copy.
>
> Unfortunately while I got the tty port structures into lots of places
> needed the job never gone done.

OK, so it sounds like there's a basic design problem here which will
need some non-trivial work to fix.  In the meantime we'll need to look
at doing something to work around the issue, since it ends up consuming
a non-trivial amount of CPU in events/0.  I guess reducing HZ would be
the first, simplest thing to do, but changing xenconsoled to avoid
writing to readerless ptys might not be too hard.

Thanks,
    J
