Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab2DMKcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:32:04 -0400
Received: from 5350504D.static.ziggozakelijk.nl ([83.80.80.77]:24217 "EHLO
	ns2.tasking.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961Ab2DMKcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:32:01 -0400
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <1334274394-13466-1-git-send-email-paul.gortmaker@windriver.com> <CA+55aFx15+eHNA4LobwiFhe4k94XPTVTLdiBmuR4hDKR5HpWPg@mail.gmail.com> <1334274394-13466-1-git-send-email-paul.gortmaker@windriver.com> <1334274394-13466-2-git-send-email-paul.gortmaker@windriver.com>
Reply-To: dick@streefland.net (Dick Streefland)
From: dick@streefland.net (Dick Streefland)
Subject: Re: [PATCH 1/3] kconfig: fix IS_ENABLED to not require all options to be defined
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <2e99.4f88009a.417f5@altium.nl>
Date: Fri, 13 Apr 2012 10:31:54 -0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| +#define __ARG_PLACEHOLDER_1 0,
| +#define config_enabled(cfg) _config_enabled(cfg)
| +#define _config_enabled(value) __config_enabled(__ARG_PLACEHOLDER_##value)
| +#define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
| +#define ___config_enabled(__ignored, val, ...) val

The ISO C99 standard requires that the variable argument macro
___config_enabled() is expanded with at least three arguments. When
a CONFIG_* macro is not defined, there are only two arguments, and
gcc will issue a somewhat cryptic warning message when you compile
with the -pedantic option:

  "warning: ISO C99 requires rest arguments to be used"

Adding an additional dummy argument makes the code ISO C99 compliant,
and eliminates the warning:

diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index be342b9..eac65da 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -19,7 +19,7 @@
 #define __ARG_PLACEHOLDER_1 0,
 #define config_enabled(cfg) _config_enabled(cfg)
 #define _config_enabled(value) __config_enabled(__ARG_PLACEHOLDER_##value)
-#define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
+#define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0, 0)
 #define ___config_enabled(__ignored, val, ...) val
 
 /*

Signed-off-by: Dick Streefland <dick@streefland.net>

-- 
Dick

