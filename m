Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3ACAmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:42:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3ACAmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:42:14 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=T9D4Q0gKs5QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WFrf85btRFAA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=ru2sfidHeqASOQE9vEIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=QIahel-I9teLu4D6:21 a=886bpl6sv5U_WrPx:21 a=qlCC5o7qNNLNSor75KwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130103004212.299139386@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Jan 2013 17:50:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH 1/3] ftrace: Be first to run code modification on modules
References: <20130102225035.140076434@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Be-first-to-run-code-modification-on-modules.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If some other kernel subsystem has a module notifier, and adds a kprobe
to a ftrace mcount point (now that kprobes work on ftrace points),
when the ftrace notifier runs it will fail and disable ftrace, as well
as kprobes that are attached to ftrace points.

Here's the error:

 WARNING: at kernel/trace/ftrace.c:1618 ftrace_bug+0x239/0x280()
 Hardware name: Bochs
 Modules linked in: fat(+) stap_56d28a51b3fe546293ca0700b10bcb29__8059(F) n=
fsv4 auth_rpcgss nfs dns_resolver fscache xt_nat iptable_nat nf_conntrack_i=
pv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack lockd sunrpc ppdev parpo=
rt_pc parport microcode virtio_net i2c_piix4 drm_kms_helper ttm drm i2c_cor=
e [last unloaded: bid_shared]
 Pid: 8068, comm: modprobe Tainted: GF            3.7.0-0.rc8.git0.1.fc19.x=
86_64 #1
 Call Trace:
  [<ffffffff8105e70f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff81134106>] ? __probe_kernel_read+0x46/0x70
  [<ffffffffa0180000>] ? 0xffffffffa017ffff
  [<ffffffffa0180000>] ? 0xffffffffa017ffff
  [<ffffffff8105e76a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff810fd189>] ftrace_bug+0x239/0x280
  [<ffffffff810fd626>] ftrace_process_locs+0x376/0x520
  [<ffffffff810fefb7>] ftrace_module_notify+0x47/0x50
  [<ffffffff8163912d>] notifier_call_chain+0x4d/0x70
  [<ffffffff810882f8>] __blocking_notifier_call_chain+0x58/0x80
  [<ffffffff81088336>] blocking_notifier_call_chain+0x16/0x20
  [<ffffffff810c2a23>] sys_init_module+0x73/0x220
  [<ffffffff8163d719>] system_call_fastpath+0x16/0x1b
 ---[ end trace 9ef46351e53bbf80 ]---
 ftrace failed to modify [<ffffffffa0180000>] init_once+0x0/0x20 [fat]
  actual: cc:bb:d2:4b:e1

A kprobe was added to the init_once() function in the fat module on load.
But this happened before ftrace could have touched the code. As ftrace
didn't run yet, the kprobe system had no idea it was a ftrace point and
simply added a breakpoint to the code (0xcc in the cc:bb:d2:4b:e1).

Then when ftrace went to modify the location from a call to mcount/fentry
into a nop, it didn't see a call op, but instead it saw the breakpoint op
and not knowing what to do with it, ftrace shut itself down.

The solution is to simply give the ftrace module notifier the max priority.
This should have been done regardless, as the core code ftrace modification
also happens very early on in boot up. This makes the module modification
closer to core modification.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Frank Ch. Eigler <fche@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 51b7159..356bc2f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3998,7 +3998,7 @@ static int ftrace_module_notify(struct notifier_block=
 *self,
=20
 struct notifier_block ftrace_module_nb =3D {
 	.notifier_call =3D ftrace_module_notify,
-	.priority =3D 0,
+	.priority =3D INT_MAX,	/* Run before anything that can use kprobes */
 };
=20
 extern unsigned long __start_mcount_loc[];
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ5NPkAAoJEOdOSU1xswtMOqAH/jLm9hMSumZ5dD9ludIhgqC/
pS3aRaPV9DtdfnpwN84hT45wQWethG+obSX/TMT5aQFUPB5d2MoadB8yFHZuTNV5
34/qeeOaCmZTOH3OdMC0Na/jI13ZfYgK7FGFRFbsEsNIG/DaS4O2uFWmu1b9vY9g
qClZZZkiKvX/W7SDfG7IYRMahV1ovdP4IWk2GcgB9I2EX6vVuFfTCOOPvQCpdP5I
Xjrr1F+Cqbk0rgqLyI9drRFGWfyf3OHivalepaC8RFh7WKGYkUKe0RxlVgo4nbmN
DghqFbTKILn3XZHG8jAwZmNzzAg809snzzzQiVc7tKnUci/1ocvu3cRM/y3wpXw=
=y2Tr
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
