Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab0CXQP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:15:59 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:60091 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab0CXQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aBVsg8ZyZCdbUiaiXtzqtLZkkyJsJ/jWbP7/U2OlMRSs3qbXpem9W6d5IKyRqfbCRJ
         +gnH6MyEnMPHf3XvxwzDcTpTDx8sooUhglmFOkzg+QYCOVf9U+/2XecaLKXOMpndfIpX
         W4lmkCEy+SiiVTXLIxCXr3IvTHG/xSVIDeR+M=
MIME-Version: 1.0
Date: Wed, 24 Mar 2010 11:15:56 -0500
Message-ID: <84621a61003240915p2a4ce6bbjd0c6bfb02ab05ba8@mail.gmail.com>
Subject: behavior of recvmmsg() on blocking sockets
From: Brandon Black <blblack@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Not on the list, please CC responses]

Currently, my application code uses blocking UDP sockets and is
basically structured like this:

while(1) {
    recvmsg(fd, ...);
    // do some work on the packet
    sendmsg(fd, ...);
}

It uses a thread-per-socket model, and the "do some work" code is very
fast, and so this turns out to be more efficient than non-blocking
techniques for my use case.  Today I started playing with 2.6.33's new
recvmmsg(), hoping to convert my code like so (still on blocking
sockets):

while(1) {
    recvmmsg(fd, ...);
    // do some work on up to N packets
    // loop over sendmsg() foreach packet to be sent
    //   (or sendmmsg() if/when that interface becomes available)
}

The catch I ran into is that on a blocking socket, recvmmsg() will
block until *all* vlen packets have been received.  The behavior I'd
prefer for my use case would be for it to only block until at least
one packet is available, not until all are available.  Or in code
terms, the first internal call to recvmsg should use the supplied
flags, and the rest of the recvmsg calls should use flags &
MSG_DONTWAIT.  It's not clear to me which is the better default
behavior, but I feel like at the very least there should be a flag
that can switch behavior between the two possible interpretations of
"blocking".

Obviously, I can also work around this at the user level by simply
switching to a non-blocking socket and using select/poll before
recvmmsg, but then under any conditions where only 1 packet is
available (probably fairly common) I'm issuing two syscalls per packet
when only one should be necessary (and only one is necessary when
using recvmsg()).  This seems inefficient and antithetical to one of
the design goals of recvmmsg (cut down the syscalls:packets ratio).

Thoughts on this?

Thanks,
-- Brandon
