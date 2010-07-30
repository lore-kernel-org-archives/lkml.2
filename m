Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0G3Vpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 17:45:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36109 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0G3Vpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 17:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cxgbfRU/XA0LkfYWDUbMZX0m4jHEbi2UZmSvdTzHAFXBAwRyphjWZmU/a240iFOYfV
         Q47iFxi/vP918LTFe+Acse7NHGum9bz73y9gHC01baXzSVUIu/IlJIYHzQzJAqIorsZL
         LDswjeqkb8FjL58bb8WEkFmK7Cu5Dn5f+IGmo=
Date: Fri, 30 Jul 2010 22:45:23 +0100
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: efault@gmx.de, a.p.zijlstra@hello.nl, tglx@linuxtronix.de,
        linux-kernel@vger.kernel.org
Subject: Regression (bisected): Lots of wakeups when using battery
Message-ID: <20100730214523.GA5571@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, testing 2.6.35-rc5 I noticed that when my laptop is on battery,
there are bursts of wakeups (they seem random, but usually happens once
each 5 sec. or so; they cause some audible noise). If the laptop is plugged
it behaves well. In single user mode, there are usually 2 wakeups/sec with
the system idle, but on battery an with the bug, it goes to more than 100 w/s.

Bisection points to:

commit 3310d4d38fbc514e7b18bd3b1eea8effdd63b5aa
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Jun 17 18:02:37 2010 +0200

    nohz: Fix nohz ratelimit
    
    Chris Wedgwood reports that 39c0cbe (sched: Rate-limit nohz) causes a
    serial console regression, unresponsiveness, and indeed it does. The
    reason is that the nohz code is skipped even when the tick was already
    stopped before the nohz_ratelimit(cpu) condition changed.
    
    Move the nohz_ratelimit() check to the other conditions which prevent
    long idle sleeps.

Reverting said commit seems to fix the issue.

Regards
