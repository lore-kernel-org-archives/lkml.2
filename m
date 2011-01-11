Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1AKDMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:12:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61048 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1AKDMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:12:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=opxmqWMdD/7TxKcFEunkChHGYO6Bk8WRot6DKl6nCFJlGMsC6alv7rjJmOIV6AcbR6
         dl4Ovsz8cRbWP2+QF41LNiYIM38jcJOlZQSUq/JFapgrDux7qG1J0zibQsZo33i4derf
         yHJ9x9YrxELoav0FJoicvbeP3s5avLVuM3EpA=
MIME-Version: 1.0
In-Reply-To: <1294713837-4929-1-git-send-email-vapier@gentoo.org>
References: <1294713837-4929-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 10 Jan 2011 22:08:48 -0500
X-Google-Sender-Auth: T1Z4ZmiENbxOQSw7ri60omAH7Kg
Message-ID: <AANLkTinnuxvx9+eNvCqjK2GW2XQPn4LjK4WfMj=f20Xw@mail.gmail.com>
Subject: Re: [PATCH] drivers: char: hvc: add Blackfin JTAG console support
To: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 21:43, Mike Frysinger wrote:
> This converts the existing bfin_jtag_comm TTY driver to the HVC layer so
> that the common HVC code can worry about all of the TTY/polling crap and
> leave the Blackfin code to worry about the Blackfin bits.

ive noticed a few downsides of converting to this ...

hvc cant be built as a module.  but not that big of a deal i guess.

throughput seems to be a bit lower.  the Blackfin JTAG hardware has
basically a 4 byte fifo that is filled/consumed in a single shot.  and
the Blackfin can produce much faster than the host can consume.  so
atm, i have it send out 4 bytes, and the hvc layers take care of
calling back into me at some point.  if i add a busy loop to run a few
hundred milliseconds (like HZ/4), it runs much nicer.  but obviously
doesnt give anyone else time to run.  i cant schedule or anything as
the write layers are called with a spin_lock_irqsave.  any tips for
how to speed this up a bit ?  or is it a wash with hvc ?

the code size also increased a bit ... old driver added up to ~1.7KiB
while hvc stuff is like ~4KiB.  but hvc does a nice job of keeping the
Blackfin-specific piece small.  so i guess it's a wash.
-mike
