Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab2EPMmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:42:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54690 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab2EPMmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:42:40 -0400
Date: Wed, 16 May 2012 05:41:09 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH v2 0/6] Merge ramoops and persistent_ram, generic pstore RAM
 backend
Message-ID: <20120516124109.GA14658@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is v2 of the previous patch set. The series do not include
patches that were already merged.

I believe I addressed all the previous comments, plus now the
series include another small cleanup patch.

Here's some background for the series:

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
proper places. Patches that will fix the second issue will be sent
shortly.

--- 
 Documentation/ramoops.txt                |    8 +-
 drivers/char/Kconfig                     |    9 -
 drivers/char/Makefile                    |    1 -
 drivers/char/ramoops.c                   |  362 --------------------
 drivers/staging/android/Kconfig          |   10 +-
 drivers/staging/android/Makefile         |    1 -
 drivers/staging/android/persistent_ram.c |  530 -----------------------------
 drivers/staging/android/persistent_ram.h |   84 -----
 drivers/staging/android/ram_console.c    |    2 +-
 fs/pstore/Kconfig                        |   17 +
 fs/pstore/Makefile                       |    3 +
 fs/pstore/ram.c                          |  383 +++++++++++++++++++++
 fs/pstore/ram_core.c                     |  532 ++++++++++++++++++++++++++++++
 include/linux/pstore_ram.h               |   98 ++++++
 include/linux/ramoops.h                  |   17 -
 15 files changed, 1042 insertions(+), 1015 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
