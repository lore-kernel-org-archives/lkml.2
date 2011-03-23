Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab1CWVCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:02:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49522 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310Ab1CWVCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=C8wbFwWrgjpIIEP8tT5G30oArUjWg5PBLdq9q/0mGT86KFtoE4RKG65Tb3Jn/MP1Cr
         70EBG/IMdp3OZ3PeEUqWUNfMJ9DdoaIFq9oOxnhHS03Z/jWUNnWCZci7RwmSLssLo9cY
         LjmKwRUalhzQQQhsmtMoM+819XIQNs3ebv0fg=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Lance Taylor <ian@airs.com>,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 0/2] Speed up the symbols' resolution process
Date: Wed, 23 Mar 2011 22:00:41 +0100
Message-Id: <1300914043-2297-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of this patchset is to speed up the symbols' resolution process.

This objective is achieved by sorting all symbols (those which reside both in
the kernel and in the modules) and thus convert the slow linear search to the
fast binary search.

To avoid adding lots of code for symbols sorting I rely on the linker which can
easily do the job thanks to a little trick. The trick isn't really beautiful to
see but permits minimal changes to the code and build process. Indeed, the
patchset is constituted by only two very short patches.

In the first patch I changed the code for place every symbol in a different
section (for example: "___ksymtab" sec "__" #sym) at compile time (this the
above mentioned trick!). In the same patch I also request to the linker to
sort and merge all these sections into the appropriate ones (for example:
"__ksymtab") at link time using the linker scripts. Once all symbols are
sorted we can use binary search instead of the linear one (this is done in
the second patch).

I'm fairly sure that this is a good speed improvement even though I haven't
made any benchmarking (I would be very happy to receive suggestions about how
made it). Collaterally, the boot time should be reduced also (proportionally
to the number of modules involved at boot stage).

I hope that you find that interesting!


This work was supported by a hardware donation from the CE Linux Forum.


Alessio Igor Bogani (2):
  Let Linker sort the symbols
  Replace the linear search with a binary search for locate the symbols

 include/asm-generic/vmlinux.lds.h |   20 +++++++-------
 include/linux/module.h            |    4 +-
 kernel/module.c                   |   49 ++++++++++++++++++++++--------------
 scripts/module-common.lds         |   19 ++++++++++++++
 4 files changed, 61 insertions(+), 31 deletions(-)

-- 
1.7.4.1

