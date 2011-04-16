Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1DPN0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:26:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49434 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1DPN0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=rDcSHQ7i40zwZOlxyztaqZb9e2wb1da6VKLZsl63ZpnRZAFHY1ZJalNpEf6LFnDvJa
         rNvxCK/GbC33v2Mx5bJAtEpKTA20JU5HYhM4QmWVJXlUObiIyoPF74z5nY61Np9zLUHj
         x8sX9IAk3Ydmsaey7VG5G+WFUitIZbzNYZT3A=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 0/4] Speed up the symbols' resolution process V4
Date: Sat, 16 Apr 2011 15:26:09 +0200
Message-Id: <1302960373-5309-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of this patch is to speed up the symbols resolution process.

This objective is achieved by sorting all ksymtab* and kcrctab* symbols
(those which reside both in the kernel and in the modules) and thus use the
fast binary search.

To avoid adding lots of code for symbols sorting I rely on the linker which can
easily do the job thanks to a little trick. The trick isn't really beautiful to
see but permits minimal changes to the code and build process. Indeed the patch
is very simple and short.

In the first place I changed the code for place every symbol in a different
section (for example: "___ksymtab" sec "__" #sym) at compile time (this the
above mentioned trick!). Thus I request to the linker to sort and merge all
these sections into the appropriate ones (for example: "__ksymtab") at link
time using the linker scripts. Once all symbols are sorted we can use binary
search instead of the linear one.

I'm fairly sure that this is a good speed improvement even though I haven't
made any comprehensive benchmarking (but follow a simple one). In any case
I would be very happy to receive suggestions about how made it. Collaterally,
the boot time should be reduced also (proportionally to the number of modules
and symbols nvolved at boot stage).

I hope that you find that interesting!

This work was supported by a hardware donation from the CE Linux Forum.

Thanks to Ian Lance Taylor for help about how the linker works.


Changes since V3:
*) Please ignore this version completely

Changes since V2:
*) Fix a bug in each_symbol() semantics by Anders Kaseorg
*) Split the work in three patches as requested by Rusty Russell
*) Add a generic binary search implementation made by Tim Abbott
*) Remove CONFIG_SYMBOLS_BSEARCH kernel option

Changes since V1:
*) Merge all patches into only one
*) Remove few useless things
*) Introduce CONFIG_SYMBOLS_BSEARCH kernel option


Alessio Igor Bogani (3):
  module: Restructure each_symbol() code
  module: Sort exported symbols
  module: Use the binary search for symbols resolution

Tim Abbott (1):
  lib: Add generic binary search function to the kernel.

 include/asm-generic/vmlinux.lds.h |   20 ++++----
 include/linux/bsearch.h           |    9 ++++
 include/linux/module.h            |    4 +-
 kernel/module.c                   |   84 ++++++++++++++++++++++++++++---------
 lib/Makefile                      |    3 +-
 lib/bsearch.c                     |   53 +++++++++++++++++++++++
 scripts/module-common.lds         |   11 +++++
 7 files changed, 151 insertions(+), 33 deletions(-)
 create mode 100644 include/linux/bsearch.h
 create mode 100644 lib/bsearch.c

-- 
1.7.4.1

