Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442Ab2ELAQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:16:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50341 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761403Ab2ELAQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:16:36 -0400
Date: Fri, 11 May 2012 17:15:06 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Sergiu Iordache <sergiu@chromium.org>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 0/11] Merge ramoops and persistent_ram, generic pstore RAM
 backend
Message-ID: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There are currently two competing debug facilities to store kernel
messages in a persistent storage: a generic pstore and Google's
persistent_ram. Not so long ago (https://lkml.org/lkml/2012/3/8/252),
it was decided that we should fix this situation.

Recently ramoops has switched to pstore, which basically means that
it became a RAM backend for the pstore framework.

persistent_ram+ram_console and ramoops+pstore have almost the same
features, except:

1. Ramoops doesn't support ECC. Having ECC is useful when a hardware
   reset was used to bring the machine back to life (i.e. a watchdog
   triggered). In such cases, RAM may be somewhat corrupt, but
   usually it is restorable.

2. Pstore doesn't support logging kernel messages in run-time, it only
   dumps dmesg when kernel oopses/panics. This makes pstore useless for
   debugging hangs caused by HW issues or improper use of HW (e.g.
   weird device inserted -> driver tried to write a reserved bits ->
   SoC hanged. In that case we don't get any messages in the pstore.

These patches solve the first issue, plus move things to their
proper places. Patches that will fix the second issue are pending.

Thanks,

--- 
 drivers/char/Kconfig                     |    9 -
 drivers/char/Makefile                    |    1 -
 drivers/char/ramoops.c                   |  362 --------------------
 drivers/staging/android/Kconfig          |   10 +-
 drivers/staging/android/persistent_ram.c |  473 --------------------------
 drivers/staging/android/persistent_ram.h |   78 -----
 drivers/staging/android/ram_console.c    |    2 +-
 fs/pstore/Kconfig                        |   12 +
 fs/pstore/Makefile                       |    1 +
 fs/pstore/ram.c                          |  384 ++++++++++++++++++++++
 fs/pstore/ram_core.c                     |  530 ++++++++++++++++++++++++++++++
 include/linux/pstore_ram.h               |   99 ++++++
 include/linux/ramoops.h                  |   17 -
 13 files changed, 1028 insertions(+), 950 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
