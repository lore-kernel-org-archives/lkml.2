Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0DTNka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:40:30 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:34353 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0DTNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AOOm+BA2/XtvIMkjHRqMYvfrHFbQ3u3lkFbDNYpT9LbAGnCKZ4GOG1j4eSNZilKxlQ
         4xQbLZK36Cbnb8BGslkpbuVkbnpOptPkKlE1YZ57yhZj6uRzq4Wu3yEm1ikayzAEj4ve
         D6Z/+nnoYXzwuN3bdIyqia149ldj9fDXqwMIw=
MIME-Version: 1.0
Date: Tue, 20 Apr 2010 09:40:27 -0400
Message-ID: <y2kf16bc8301004200640r9485da73p920a2f5c3e2d949e@mail.gmail.com>
Subject: Should calculation of vm.overcommit_ratio be changed?
From: Dave Wright <wrightd@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current calculation of VM overcommit (particularly with default
vm.overcommit_ratio==50) seems to be a hold-over from the days when we
had more swap than physical memory. For example, 1/2 phy mem + swap
made sense when you had a 1GB of memory and 2GB of swap, however I
recently ran into an issue on a server that had 8GB RAM and 2GB swap.
The OOM killer was getting triggered as VM commit hit 6GB, even though
there was plenty of RAM available. Once I figured out what was going
on, I manually tweaked the ratio to be 110%.
It looks like current distro recommendations are still "have as much
swap as you have RAM", in which case the current calculation is fine,
but with SSD becoming more common on boot drives, I think many users
will end up with less swap than RAM - consider a desktop user who
might have 4GB RAM and 1GB swap. I don't think you would expect
Desktop users to understand or tweak overcommit_ratio, but I also
don't think having the distro simply change the default from 50 (to
100 or something else) would cover all the cases well.

Would it make more sense to have the overcommit formula be calculated as:

max commit = min(swap, ram) * overcommit_ratio + max(swap, ram) ?

When swap>=ram, the formula works exactly the same as it does now, but
when ram>>swap, you are guaranteed to always be able to your full RAM
(even when swap=0).

-Dave Wright
