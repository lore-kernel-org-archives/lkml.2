Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2JRLZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:25:08 -0400
Received: from mail.axsentis.net ([78.35.17.11]:56928 "EHLO mail.axsentis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab2JRLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:25:06 -0400
X-Greylist: delayed 1625 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2012 07:25:06 EDT
From: Stefan Knoblich <s.knoblich@axsentis.de>
To: linux-kernel@vger.kernel.org
Cc: weiyj.lk@gmail.com, dhowells@redhat.com,
        Stefan Knoblich <s.knoblich@axsentis.de>
Subject: Re: CONFIG_MODULE_SIG breaks out-of-tree modules in modpost.
Date: Thu, 18 Oct 2012 12:57:50 +0200
Message-Id: <1350557870-5660-1-git-send-email-s.knoblich@axsentis.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <CAPgLHd-9oJhKGfpewf2shxKhGWFOVdcxjhFrvHx4fDc=hxo3Kw@mail.gmail.com>
References: <CAPgLHd-9oJhKGfpewf2shxKhGWFOVdcxjhFrvHx4fDc=hxo3Kw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've had the same problem building dahdi-linux-2.6.1, attached
patch fixed it:

From: Stefan Knoblich <s.knoblich@axsentis.de>
Date: Tue, 16 Oct 2012 12:40:29 +0200
Subject: [PATCH] MODSIGN: Fix modpost for external modules with
 CONFIG_MODULE_SIG=y

Modpost with CONFIG_MODULE_SIG=y skips the signing step for external
modules by forcing SIGN_MODULES=0, breaking the build because
cmd_sign_ko_ko_stripped is undefined in that case:

  CC      /tmp/dahdi-linux-2.6.1/drivers/dahdi/../staging/echo/echo.mod.o
  LD [M]  /tmp/dahdi-linux-2.6.1/drivers/dahdi/../staging/echo/echo.ko.unsigned
  STRIP [M] /tmp/dahdi-linux-2.6.1/drivers/dahdi/../staging/echo/echo.ko.stripped
/bin/sh: -c: line 0: syntax error near unexpected token `;'
/bin/sh: -c: line 0: `set -e;  ; echo 'cmd_/tmp/dahdi-linux-2.6.1/drivers/dahdi/
../staging/echo/echo.ko := ' > /tmp/dahdi-linux-2.6.1/drivers/dahdi/
../staging/echo/.echo.ko.cmd'

Renaming the misnamed {quiet_,}cmd_sign_ko_ko_unsigned commands
fixes that error.

Signed-off-by: Stefan Knoblich <s.knoblich@axsentis.de>
---
 scripts/Makefile.modpost |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 0020891..85c0d10 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -188,8 +188,8 @@ quiet_cmd_sign_ko_ko_stripped = SIGN [M] $@
 		sh $(SCRIPTS_DIR)/sign-file $(MODSECKEY) $(MODPUBKEY) $< $@
 else
 KEYRING_DEP :=
-quiet_cmd_sign_ko_ko_unsigned = NO SIGN [M] $@
-      cmd_sign_ko_ko_unsigned = \
+quiet_cmd_sign_ko_ko_stripped = NO SIGN [M] $@
+      cmd_sign_ko_ko_stripped = \
 		cp $< $@
 endif
 
-- 
1.7.8.6

