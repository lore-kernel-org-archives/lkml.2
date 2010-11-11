Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab0KKNt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:49:58 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64828 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0KKNt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ku2VVtzzRshBpOx3R4wWdEF0V4w0ddwOTSeDBnqPXEzcFPY/Us4bBoIKhr3LHUpzfh
         kZaUfOWSn2Y7It1tlFmDMua97Y1r7iQVJXrW6WOCAZSL5mdSlChwKMLmAca35cXpq2d7
         SU43F/CxtZC52UschItrvN8iBVWVjX3ZjqBNk=
MIME-Version: 1.0
Date: Thu, 11 Nov 2010 21:49:56 +0800
Message-ID: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
Subject: Kernel rwlock design, Multicore and IGMP
From: Cypher Wu <cypher.w@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using TILEPro and its rwlock in kernel is a liitle different than
other platforms. It have a priority for write lock that when tried it
will block the following read lock even if read lock is hold by
others. Its code can be read in Linux Kernel 2.6.36 in
arch/tile/lib/spinlock_32.c.

That different could cause a deadlock in kernel if we join/leave
Multicast Group simultaneous and frequently on mutlicores. IGMP
message is sent by

igmp_ifc_timer_expire() -> igmpv3_send_cr() -> igmpv3_sendpack()

in timer interrupt, igmpv3_send_cr() will generate the sk_buff for
IGMP message with mc_list_lock read locked and then call
igmpv3_sendpack() with it unlocked.
But if we have so many join/leave messages have to generate and it
can't be sent in one sk_buff then igmpv3_send_cr() -> add_grec() will
call igmpv3_sendpack() to send it and reallocate a new buffer. When
the message is sent:

__mkroute_output() -> ip_check_mc()

will read lock mc_list_lock again. If there is another core is try
write lock mc_list_lock between the two read lock, then deadlock
ocurred.

The rwlock on other platforms I've check, say, PowerPC, x86, ARM, is
just read lock shared and write_lock mutex, so if we've hold read lock
the write lock will just wait, and if there have a read lock again it
will success.

So, What's the criteria of rwlock design in the Linux kernel? Is that
read lock re-hold of IGMP a design error in Linux kernel, or the read
lock has to be design like that?

There is a other thing, that the timer interrupt will start timer on
the same in_dev, should that be optimized?

BTW: If we have so many cores, say 64, is there other things we have
to think about spinlock? If there have collisions ocurred, should we
just read the shared memory again and again, or just a very little
'delay' is better? I've seen relax() is called in the implementation
of spinlock on TILEPro platform.
