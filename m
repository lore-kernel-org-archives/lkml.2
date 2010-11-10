Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0KJEZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 23:25:50 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34283 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0KJEZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 23:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=esvGkHufHrcZTgahwAj0T8m5eJzq86ab77e+v5Ew0D3bmOERZ4pUyT5IAo1p60GQrE
         f5g8f3XDjXy6idgRcoXp/MUEZU54OoxxuuMNKvvdjbJhus7EeraIHU+/VvTpKom0xjDm
         m9tFNXnqkTVl/ikPlPn/E+PYckIHc59PmXDjY=
MIME-Version: 1.0
Date: Wed, 10 Nov 2010 12:25:47 +0800
Message-ID: <AANLkTik2jL_wXDydNiH-r-RUcxRDYUEY30maPhkS94o9@mail.gmail.com>
Subject: [PATCH] kdb: fix kernel fault when register kdb debug command exceeds KDB_BASE_CMD_MAX
From: jovi zhang <bookjovi@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>, Martin Hicks <mort@sgi.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAA4QFDA027744

If we register kdb debug command numbers exceeds KDB_BASE_CMD_MAX,
kernel will fault
This patch fix it

Signed-off-by: jovi zhang <bookjovi@gmail.com>
kernel/debug/kdb/kdb_main.c |   10 ++++------
1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 37755d6..abd46c9 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -82,7 +82,7 @@ static kdbtab_t kdb_base_commands[50];
#define for_each_kdbcmd(cmd, num)                                      \
       for ((cmd) = kdb_base_commands, (num) = 0;                      \
            num < kdb_max_commands;                                    \
-            num == KDB_BASE_CMD_MAX ? cmd = kdb_commands : cmd++, num++)
+            num++, num == KDB_BASE_CMD_MAX ? cmd = kdb_commands : cmd++)

typedef struct _kdbmsg {
       int     km_diag;        /* kdb diagnostic */
@@ -2730,7 +2730,7 @@ int kdb_register_repeat(char *cmd,
       }

       if (i >= kdb_max_commands) {
-               kdbtab_t *new = kmalloc((kdb_max_commands - KDB_BASE_CMD_MAX +
+               kdbtab_t *new = kzalloc((kdb_max_commands - KDB_BASE_CMD_MAX +
                        kdb_command_extend) * sizeof(*new), GFP_KDB);
               if (!new) {
                       kdb_printf("Could not allocate new kdb_command "
@@ -2739,13 +2739,11 @@ int kdb_register_repeat(char *cmd,
               }
               if (kdb_commands) {
                       memcpy(new, kdb_commands,
-                              kdb_max_commands * sizeof(*new));
+                       (kdb_max_commands - KDB_BASE_CMD_MAX) * sizeof(*new));
                       kfree(kdb_commands);
               }
-               memset(new + kdb_max_commands, 0,
-                      kdb_command_extend * sizeof(*new));
               kdb_commands = new;
-               kp = kdb_commands + kdb_max_commands;
+               kp = kdb_commands + kdb_max_commands - KDB_BASE_CMD_MAX;
               kdb_max_commands += kdb_command_extend;
       }
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
