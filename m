Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1AUEQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 23:16:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59415 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1AUEQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 23:16:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=amXCGj9V7q0zGQOq3bHiCeR91wRQKPQqE04wWbFiBkZUKUtiDNGlIWpC/D5bgCIZ9L
         iq1fjIMklwiJ1qdJCFeyJBIXRRnu//wSU/tWm8VPcfoZDktyiuWSKf7XbmW4upvqLSV+
         uRlHUJYoFZfnxGe46VlFCH2hhmvpjxvRZSQJg=
Subject: Re: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight
 cannot be adjusted
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1295583107.2613.45.camel@edumazet-laptop>
References: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
	 <1295583107.2613.45.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 05:16:34 +0100
Message-ID: <1295583394.2613.47.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 21 janvier 2011 à 05:11 +0100, Eric Dumazet a écrit :
> Le vendredi 21 janvier 2011 à 10:55 +0900, Norbert Preining a écrit :
> > Hi everyone,
> > 
> > (please Cc)
> > 
> > going to 2.6.38-rc1 I see the following regression: After reboot I
> > can easily adjust the backlight with the keys on my keyboard, but 
> > after a suspend-to-ram this does not work anymore.
> > 
> > This is a Sony laptop, and backlight is controlled by the video
> > acpi driver AFAIR.
> > 
> 
> Hi Norbert
> 
> Maybe this is the problem Linus had to bisect, you could try his patch :
> 
> http://marc.info/?l=linux-netdev&m=129556877919576&w=2
> 
> Thanks !
> 

Or just pull linux-2.6, since patch is now committed

commit 28e58ee8ce1f0e69c207f747b7b9054b071e328d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jan 20 16:21:59 2011 -0800

    Fix broken "pipe: use event aware wakeups" optimization
    
    Commit e462c448fdc8 ("pipe: use event aware wakeups") optimized the pipe
    event wakeup calls to avoid wakeups if the events do not match the
    requested set.
    
    However, the optimization was buggy, in that it didn't actually use the
    correct sets for the events: when we make room for more data to be
    written, the pipe poll() routine will return both the POLLOUT _and_
    POLLWRNORM bits.  Similarly for read.
    
    And most critically, when a pipe is released, that will potentially
    result in POLLHUP|POLLERR (depending on whether it was the last reader
    or writer), not just the regular POLLIN|POLLOUT.
    
    This bug showed itself as a hung gnome-screensaver-dialog process, stuck
    forever (or at least until it was poked by a signal or by being traced)
    in a poll() system call.
    
    Cc: Davide Libenzi <davidel@xmailserver.org>
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


