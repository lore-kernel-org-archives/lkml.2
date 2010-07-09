Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab0GIF3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 01:29:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63634 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0GIF3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 01:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P5ZclccEN85FDoo8M/a0k0qlIH9iyu3DWNgPxokVm8ZZFCQG6btny8u/BhjGbI2cXK
         Cng2VtanoKmeK9SfbD83w+POab/yPnpFsGfoOKoGhsSf5GibPC0FB9xJ5qJoi6UWrjY5
         iYrJp3TxVSWKFadVXPAxO6HLAIhaYhIJs7Hf8=
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org, kaber@trash.net,
       jengelh@medozas.de, casteyde.christian@free.fr
In-Reply-To: <20100708.213420.112614033.davem@davemloft.net>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
	 <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
	 <20100708.213420.112614033.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 07:28:54 +0200
Message-ID: <1278653334.2435.196.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 juillet 2010 à 21:34 -0700, David Miller a écrit :
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 8 Jul 2010 18:34:25 -0700
> 
> > On Thu, Jul 8, 2010 at 4:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16187
> >> Subject         : Carrier detection failed in dhcpcd when link is up
> >> Submitter       : Christian Casteyde <casteyde.christian@free.fr>
> >> Date            : 2010-06-12 15:15 (27 days old)
> >> First-Bad-Commit: http://git.kernel.org/linus/10708f37ae729baba9b67bd134c3720709d4ae62
> >> Handled-By      : Andrew Morton <akpm@linux-foundation.org>
> > 
> > David? This bisects to a networking commit. Doesn't look sensible, but
> > what do I know?
> 
> My suspicion is that dhcpd uses netlink to dump the info of the
> available links, and due to some bug gets confused with the new 64-bit
> statistic netlink attribute being there now.
> a second to have a look at this.

It could be a dhcpcd bug because of extended size of answer

According to strace, dhcpcd tries a recvmsg() call with
a 256 bytes buffer to hold answer.

Looking at current dhcpcd source, I confirm it cannot realloc its buffer

static int
get_netlink(int fd, int flags,
    int (*callback)(struct nlmsghdr *))
{
        char *buffer = NULL;
        ssize_t bytes;
        struct nlmsghdr *nlm;
        int r = -1;

        buffer = xzalloc(sizeof(char) * BUFFERLEN);
        for (;;) {
                bytes = recv(fd, buffer, BUFFERLEN, flags);
                if (bytes == -1) {
                        if (errno == EAGAIN) {
                                r = 0;
                                goto eexit;
                        }
                        if (errno == EINTR)
                                continue;
                        goto eexit;
                }


This program needs to fix this.


