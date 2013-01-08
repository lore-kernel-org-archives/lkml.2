Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3AHVXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:23:20 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4676 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3AHVXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:23:19 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Al Cooper" <alcooperx@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
cc: "Al Cooper" <alcooperx@gmail.com>
Subject: [PATCH] perf tools: Fix GNU make v3.80 compatibility issue
Date: Tue, 8 Jan 2013 16:22:36 -0500
Message-ID: <1357680156-15520-1-git-send-email-alcooperx@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
X-WSS-ID: 7CF2528539W24547012-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/Changes, the kernel should be buildable with
GNU make 3.80+. tools/perf/config/utilities.mak contains the "$(or"
construct, which requires make 3.81.  This causes "make" to fail on
systems with GNU make 3.80.

Replace "$(or" with an equivalent "$(if" expression, to restore backward
compatibility. Also fix an issue where _get_attempt was called with only
one argument. This prevented the error message from printing the
name of the variable that can be used to fix the problem.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 tools/perf/config/utilities.mak |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index e541312..8ef3bd3 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -13,7 +13,7 @@ newline := $(newline)
 # what should replace a newline when escaping
 # newlines; the default is a bizarre string.
 #
-nl-escape = $(or $(1),m822df3020w6a44id34bt574ctac44eb9f4n)
+nl-escape = $(if $(1),$(1),m822df3020w6a44id34bt574ctac44eb9f4n)
 
 # escape-nl
 #
@@ -173,9 +173,9 @@ _ge-abspath = $(if $(is-executable),$(1))
 # Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
 #
 define get-executable-or-default
-$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
 endef
-_ge_attempt = $(or $(get-executable),$(_gea_warn),$(call _gea_err,$(2)))
+_ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
-- 
1.7.6


