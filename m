Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2D3AQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:16:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55786 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2D3AQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:16:01 -0400
Message-ID: <4F9DD994.70202@zytor.com>
Date: Sun, 29 Apr 2012 17:15:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized
 pipe
References: <20120429205429.63CCD7C0064@ra.kernel.org>
In-Reply-To: <20120429205429.63CCD7C0064@ra.kernel.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 01:54 PM, Linux Kernel Mailing List wrote:
>     
>     With both automount and systemd doing a single read() system call, and
>     verifying that they get *exactly* the size they expect but using
>     different sizes, it seemed that fixing one of them inevitably seemed to
>     break the other.  At one point, a patch I seriously considered applying
>     from Michael Tokarev did a "strcmp()" to see if it was automount that
>     was doing the operation.  Ugly, ugly.
>     
>     However, a prettier solution exists now thanks to the packetized pipe
>     mode.  By marking the communication pipe as being packetized (by simply
>     setting the O_DIRECT flag), we can always just write the bigger packet
>     size, and if user-space does a smaller read, it will just get that
>     partial end result and the extra alignment padding will simply be thrown
>     away.
>     
>     This makes both automount and systemd happy, since they now get the size
>     they asked for, and the kernel side of autofs simply no longer needs to
>     care - it could pad out the packet arbitrarily.
>     
>     Of course, if there is some *other* user of autofs (please, please,
>     please tell me it ain't so - and we haven't heard of any) that tries to
>     read the packets with multiple writes, that other user will now be
>     broken - the whole point of the packetized mode is that one system call
>     gets exactly one packet, and you cannot read a packet in pieces.
>     

I just looked at am-utils; am-utils *does* use autofs v5, and *will*
loop back and read more data on a short read.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

