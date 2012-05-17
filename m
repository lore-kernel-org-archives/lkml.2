Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093Ab2EQHNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:13:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35531 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761032Ab2EQHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:13:19 -0400
Date: Thu, 17 May 2012 00:11:48 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
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
Subject: [PATCH v3 0/3] Merge ramoops and persistent_ram, generic pstore RAM
 backend
Message-ID: <20120517071148.GA16946@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here comes v3:

- Rebased on current staging-next tree, so only 3 patches left;
- Fixed ram_console dependency in Kconfig (issue noticed by Greg KH).


And the boilerplate, background for the series:

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
proper places.

--- 
 Documentation/ramoops.txt                |    6 +
 drivers/staging/android/Kconfig          |   10 +-
 drivers/staging/android/Makefile         |    1 -
 drivers/staging/android/persistent_ram.c |  532 ------------------------------
 drivers/staging/android/persistent_ram.h |   82 -----
 drivers/staging/android/ram_console.c    |    2 +-
 fs/pstore/Kconfig                        |    7 +-
 fs/pstore/Makefile                       |    2 +-
 fs/pstore/ram.c                          |  119 ++++---
 fs/pstore/ram_core.c                     |  532 ++++++++++++++++++++++++++++++
 include/linux/pstore_ram.h               |   81 +++++
 11 files changed, 697 insertions(+), 677 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
