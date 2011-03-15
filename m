Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1COGec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 02:34:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1COGe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 02:34:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=odJPH44AIuO7O3p4zxZAyMNsYe31jCkAXEPbNPVO2c7WRGYGXTDDvQDqV4x9LF/G0
	969qj36KrCuZUPfbm5kSA==
Subject: [PATCH] KBuild: silence "'scripts/unifdef' is up to date."
To: Michal Marek <mmarek@suse.cz>
From: Mike Waychison <mikew@google.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Mon, 14 Mar 2011 23:34:25 -0700
Message-ID: <20110315063425.9538.11565.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch applies to 2.6.38-rc8.

While changing our build system over to use the headers_install target
as part of our klibc build, the following message started showing up in
our logs:

make[2]: `scripts/unifdef' is up to date.

It turns out that the build blindly invokes a recursive make on this
target, which causes make to emit this message when the target is
already up to date.  This isn't seen for most targets as the rest of the
build relies primarily on the default target and on PHONY targets when
invoking make recursively.

Silence the above message when building unifdef as part of
headers_install by hiding it behind a new PHONY target called
"build_unifdef" that has an empty recipe.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 Makefile         |    2 +-
 scripts/Makefile |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 504f788..5d7e0b2 100644
--- a/Makefile
+++ b/Makefile
@@ -1018,7 +1018,7 @@ hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
 PHONY += __headers
 __headers: include/linux/version.h scripts_basic FORCE
-	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
+	$(Q)$(MAKE) $(build)=scripts build_unifdef
 
 PHONY += headers_install_all
 headers_install_all:
diff --git a/scripts/Makefile b/scripts/Makefile
index 2e08810..fcea261 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -18,6 +18,11 @@ always		:= $(hostprogs-y) $(hostprogs-m)
 # The following hostprogs-y programs are only build on demand
 hostprogs-y += unifdef
 
+# This target is used internally to avoid "is up to date" messages
+PHONY += build_unifdef
+build_unifdef: scripts/unifdef FORCE
+	@:
+
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux

