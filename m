Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946046Ab2ERNLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:11:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741Ab2ERNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:56 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=9F0j-8JpHZwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=fOM_VpNnRYehBkQn8CUA:9 a=GihG3io9dNuPoLFiR2kA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NfOsOozX9b-pAnZdF10A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131052.053307819@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 14/15] ftrace/x86: Have x86 ftrace use the ftrace_modify_all_code()
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0014-ftrace-x86-Have-x86-ftrace-use-the-ftrace_modify_all.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

To remove duplicate code, have the ftrace arch_ftrace_update_code()
use the generic ftrace_modify_all_code(). This requires that the
default ftrace_replace_code() becomes a weak function so that an
arch may override it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |   15 ++-------------
 include/linux/ftrace.h   |    1 +
 kernel/trace/ftrace.c    |    4 ++--
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 4243e8b..32ff365 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -435,7 +435,7 @@ static void run_sync(void)
 		local_irq_disable();
 }
=20
-static void ftrace_replace_code(int enable)
+void ftrace_replace_code(int enable)
 {
 	struct ftrace_rec_iter *iter;
 	struct dyn_ftrace *rec;
@@ -493,18 +493,7 @@ void arch_ftrace_update_code(int command)
 {
 	modifying_ftrace_code++;
=20
-	if (command & FTRACE_UPDATE_CALLS)
-		ftrace_replace_code(1);
-	else if (command & FTRACE_DISABLE_CALLS)
-		ftrace_replace_code(0);
-
-	if (command & FTRACE_UPDATE_TRACE_FUNC)
-		ftrace_update_ftrace_func(ftrace_trace_function);
-
-	if (command & FTRACE_START_FUNC_RET)
-		ftrace_enable_ftrace_graph_caller();
-	else if (command & FTRACE_STOP_FUNC_RET)
-		ftrace_disable_ftrace_graph_caller();
+	ftrace_modify_all_code(command);
=20
 	modifying_ftrace_code--;
 }
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index cd72ace..55e6d63 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -314,6 +314,7 @@ ftrace_set_early_filter(struct ftrace_ops *ops, char *b=
uf, int enable);
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
 extern int ftrace_dyn_arch_init(void *data);
+extern void ftrace_replace_code(int enable);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3c34582..a008663 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1683,7 +1683,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int ena=
ble)
 	return -1; /* unknow ftrace bug */
 }
=20
-static void ftrace_replace_code(int update)
+void __weak ftrace_replace_code(int enable)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
@@ -1693,7 +1693,7 @@ static void ftrace_replace_code(int update)
 		return;
=20
 	do_for_each_ftrace_rec(pg, rec) {
-		failed =3D __ftrace_replace_code(rec, update);
+		failed =3D __ftrace_replace_code(rec, enable);
 		if (failed) {
 			ftrace_bug(failed, rec->ip);
 			/* Stop processing */
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpcAAoJEIy3vGnGbaoA6XQP/iUIa8G4Tsxu5OiSbqW4Pdjn
/EIVwHMa5A8NkXmWFvtzNmhmVDMucU2VBoMafwqm9FjfIH6MSdP6uqZ1KMe12+b5
PWI6l3KcFdnUAIikMTEKQIrXYkAAqFKJRd62sODzPf6L0dmx8o9J4riINBX+L53M
VH1VueooBsbKsUuTEbvOMddfAxbaZ24yCR+zSL7CK1u1xQtWFnaQ1q6oOx19Y2JB
EEX2VK+76DqoOlYtRNKayqJGUPwurfBDJeE4E5EBdmr2D9MKeTX43YrvBPX+lW1M
tMP8T6VyCfV+eSBdM0ZKlK4e0MRKDGBKr3GRV9vJTO1N9IAcsYcquAc+luFdZWKR
+7YaE+Rl+5ep5lJTaDvf64SG+fCbEYmmKZo0uMuSjSmCZ6aKAgJs6aDDsp+Fb5I1
2hj4y/N0NaORR133h9I+5KcVUDocSsRIq1NjTdi2JnznBc2Rib1IpgNfWj/FVOxI
gs/nvVfU9BIxOhxn0cYS8tN6IntYp7A+ErWHVieieRcy7cfSuqStcxIv4L9RHcBf
74+hJTOBoJlF55JJaXOp+fk22B8pfnM5YeybfcApsroj15tt66eItP9B2oMuAjlL
v+kdUsZW82RgX+e9EJL/BT3BFOjgkIfD9HSXLhIETyY4l5hXVPnLqJjX8uUYnt//
r9SQuCSNjO6mFj2oeVfS
=AJH5
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
