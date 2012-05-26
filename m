Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2EZNTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:19:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43128 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2EZNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:19:22 -0400
Date: Sat, 26 May 2012 06:17:48 -0700
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
Subject: [PATCH v5 0/11] Merge ram_console into pstore
Message-ID: <20120526131747.GA15054@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

And another respin, v5 this time:

- Split out fixes into a separate series;
- Added proper spinlock protection to the pstore/console interface
  (the bug I found when was adding ftrace interface);
- And as I'm about to add ftrace support to pstore, to not touch
  the same lines of code twice, I reworked 'Factor ramoops_get_dump_prz()
  out of ramoops_pstore_read()' patch into 'Factor ramoops_get_next_prz()
  out of ramoops_pstore_read()'. This is just a more generic interface
  that will work for both console and ftrace przs.
  Since the patch changed drastically, it lost Kees' ack, so it needs a
  re-ack.
- The same as above happened w/ 'Introduce ramoops_context.max_dump_count'
  patch, it turned into 'Give proper names to dump-related variables', it
  also needs a re-ack.
- If anyone is willing to try the patches, for convenience they are now
  available in the git repository:
  	git://git.infradead.org/users/cbou/linux-pstore.git
  or gitweb:
  	http://git.infradead.org/users/cbou/linux-pstore.git

In v4:

- Per Kees Cook's comments, the patches no longer remove an automatic
  updates feature, but instead make the it configurable; plus disable
  it by default (in a separate patch);
- Fixed some bugs noticed by Colin Cross;
- Documented new continuous ramoops-console log behaviour (also
  noticed by Colin Cross).

In v3:

- Rebased on top of current staging-next;
- The series are getting bigger. This is partly because we now support
  different persistent zone sizes for oops records and console log,
  per Colin Cross' request.
  And I believe the code is now more manageable for further enhancements
  (e.g. if we'd want to add other message types, e.g. tracing);
- Addressed Kees Cook's comments on the unlinking matters;
- Removed automatic updates support. Please see the last patch
  description for rationale;
- A new fixup for pstore/inode, just getting rid of a sparse warning.

In v2:

- Updated documentation per Colin Cross' comments;
- Corrected return value in ramoops_pstore_write() (noticed by Kees Cook);
- Fixed large writes handling in pstore_console_write(), i.e. when
  log_buf write is larger than pstore bufsize. Also Noticed by Kees Cook.


And a boilerplate for the series:

Currently pstore doesn't support logging kernel messages in run-time,
it only dumps dmesg when kernel oopses/panics. This makes pstore
useless for debugging hangs caused by HW issues or improper use of HW
(e.g. weird device inserted -> driver tried to write reserved bits ->
SoC hanged. In that case we don't get any messages in the pstore.

This series add a new message type for pstore, i.e. PSTORE_TYPE_CONSOLE,
plus make pstore/ram.c handle the new messages.

The old ram_console driver is removed. This might probably cause
some pain for out-of-tree code, as it would need to be adjusted...
but "no pain, no gain"? :-) Though, if there's some serious resistance,
we can probably postpone the last two patches.

Thanks!

--- 
 Documentation/ramoops.txt             |   14 ++
 drivers/staging/android/Kconfig       |    5 -
 drivers/staging/android/Makefile      |    1 -
 drivers/staging/android/ram_console.c |  179 ------------------------
 fs/pstore/Kconfig                     |    7 +
 fs/pstore/inode.c                     |    3 +
 fs/pstore/platform.c                  |   54 +++++++-
 fs/pstore/ram.c                       |  246 ++++++++++++++++++++++++---------
 fs/pstore/ram_core.c                  |   81 +----------
 include/linux/pstore.h                |    1 +
 include/linux/pstore_ram.h            |   20 +--
 11 files changed, 261 insertions(+), 350 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
