Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3AHCAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:00:30 -0500
Received: from nm21-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.176]:29558
	"EHLO nm21-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753712Ab3AHCA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:00:29 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2013 21:00:29 EST
X-Yahoo-Newman-Id: 443930.98341.bm@smtp108.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Y6cm6MIVM1kZlhnOjeM8q03XkjRTPSnRT9mwQZAaxGntgP_
 07HIiFeZeluH2Xf0h5ASwb.zd6I1ZD4y1JFaPapZA.nW_x9Wdpwt.MMG4in.
 jVI9zkOqS36zHnbdKHxlX.jRZYsvhlkgVkBpn.6Pel1twuuO0Zr1yzPuAC_O
 KVanwDWA2SeSdUDZ_mQMIhJUMS1K74NWMUBBLaOHp88e3SfmblkZSqsaaM5f
 BCzMixRYs8BwbxmvxQ7irIrtRRDE7L6HQytSVNMVO6j7HPSGjxvZyIpt7Q5l
 XQIm2KaukFHltu7URMrHRm12W4OogJxUkklFh_SGhh4PrfuhzeYzxW7KsYki
 v1up64oxkPRQEyqobF7r1sP6qP7RyE3AGaRaBqYCGsw8eztV8BCRY_iM1R.E
 J2S_2BGEXRIegOMpXzV9CwpF2X8zr5rHpTWOJEFWqJEd1M0ha1N9DpiyVhqB
 BANMDThj696C.HHKGiz5TbXY-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB7C50.3070605@schaufler-ca.com>
Date: Mon, 07 Jan 2013 17:54:24 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v12 0/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s
from a single vector of hook handlers to a list based method
for handling multiple concurrent modules. 

A level of indirection has been introduced in the handling of
security blobs. LSMs no longer access ->security fields directly,
instead they use an abstraction provided by lsm_[gs]et field
functions. 

The XFRM hooks are only used by SELinux and it is not clear
that they can be shared. The First LSM that registers using
those hooks gets to use them. Any subsequent LSM that uses
those hooks is denied registration. 

Secids have not been made shareable. Only one LSM that uses
secids (SELinux and Smack) can be used at a time. The first
to register wins.

The "security=" boot option takes a comma separated list of
LSMs, registering them in the order presented. The LSM hooks
will be executed in the order registered. Hooks that return
errors are not short circuited. All hooks are called even
if one of the LSM hooks fails. The result returned will be
that of the last LSM hook that failed.

Some hooks don't fit that model. setprocattr, getprocattr,
and a few others are special cased. All behavior from
security/capability.c has been moved into the hook handling.
The security/commoncap functions used to get called from
the LSM specific code. The handling of the capability
functions has been moved out of the LSMs and into the
hook handling.

The /proc/*/attr interfaces are given to one LSM. This
can be done by setting CONFIG_SECURITY_PRESENT. Additional
interfaces have been created in /proc/*/attr so that
each LSM has its own named interfaces.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 fs/proc/base.c                      |   28 +-
 include/linux/lsm.h                 |  174 ++++
 include/linux/security.h            |  255 +++++-
 security/Kconfig                    |   79 +-
 security/Makefile                   |    3 +-
 security/apparmor/context.c         |   10 +-
 security/apparmor/domain.c          |   19 +-
 security/apparmor/include/context.h |   13 +-
 security/apparmor/lsm.c             |   66 +-
 security/capability.c               | 1081 -------------------------
 security/commoncap.c                |    6 -
 security/inode.c                    |   79 +-
 security/security.c                 | 1496 ++++++++++++++++++++++++++++-------
 security/selinux/hooks.c            |  410 +++++-----
 security/selinux/include/objsec.h   |    2 +
 security/selinux/include/xfrm.h     |    2 +-
 security/selinux/netlabel.c         |   13 +-
 security/selinux/selinuxfs.c        |    6 +-
 security/selinux/xfrm.c             |    9 +-
 security/smack/smack.h              |   14 +-
 security/smack/smack_access.c       |    2 +-
 security/smack/smack_lsm.c          |  367 ++++-----
 security/smack/smackfs.c            |   16 +-
 security/tomoyo/common.h            |    6 +-
 security/tomoyo/domain.c            |    2 +-
 security/tomoyo/securityfs_if.c     |    9 +-
 security/tomoyo/tomoyo.c            |   47 +-
 security/yama/Kconfig               |    7 -
 security/yama/yama_lsm.c            |   33 +-
 29 files changed, 2226 insertions(+), 2028 deletions(-)

