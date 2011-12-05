Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1LEMG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:06:27 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46798 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab1LEMGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:06:21 -0500
X-AuditID: b753bd60-9645cba00000359c-de-4edcb3bbb2a6
X-AuditID: b753bd60-9645cba00000359c-de-4edcb3bbb2a6
Subject: [PATCH 6/6] x86/tools: Add decoded instruction dump mode
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 05 Dec 2011 21:06:03 +0900
Message-ID: <20111205120603.15475.91192.stgit@cloud>
In-Reply-To: <20111205120520.15475.82983.stgit@cloud>
References: <20111205120520.15475.82983.stgit@cloud>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add instruction dump mode to insn_sanity tool for
checking decoder really decoded instructions.

This mode is enabled when passing double -v (-vv) to
insn_sanity. It is useful for who wants to check whether
the decoder can decode some instructions correctly.
e.g.
 $ echo 0f 73 10 11 | ./insn_sanity -y -vv -i -
 Instruction = {
        .prefixes = {
                .value = 0, bytes[] = {0, 0, 0, 0},
                .got = 1, .nbytes = 0},
        .rex_prefix = {
                .value = 0, bytes[] = {0, 0, 0, 0},
                .got = 1, .nbytes = 0},
        .vex_prefix = {
                .value = 0, bytes[] = {0, 0, 0, 0},
                .got = 1, .nbytes = 0},
        .opcode = {
                .value = 29455, bytes[] = {f, 73, 0, 0},
                .got = 1, .nbytes = 2},
        .modrm = {
                .value = 16, bytes[] = {10, 0, 0, 0},
                .got = 1, .nbytes = 1},
        .sib = {
                .value = 0, bytes[] = {0, 0, 0, 0},
                .got = 1, .nbytes = 0},
        .displacement = {
                .value = 0, bytes[] = {0, 0, 0, 0},
                .got = 1, .nbytes = 0},
        .immediate1 = {
                .value = 17, bytes[] = {11, 0, 0, 0},
                .got = 1, .nbytes = 1},
        .immediate2 = {
                .value = 0, bytes[] = {0, 0, 0, 0},
                .got = 0, .nbytes = 0},
        .attr = 44800, .opnd_bytes = 4, .addr_bytes = 8,
        .length = 4, .x86_64 = 1, .kaddr = 0x7fff0f7d9430}
 Success: decoded and checked 1 given instructions with 0 errors (seed:0x0)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/tools/insn_sanity.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
index b6720d6..cc2f8c1 100644
--- a/arch/x86/tools/insn_sanity.c
+++ b/arch/x86/tools/insn_sanity.c
@@ -59,7 +59,7 @@ static void usage(const char *err)
 	fprintf(stderr, "Usage: %s [-y|-n|-v] [-s seed[,no]] [-m max] [-i input]\n", prog);
 	fprintf(stderr, "\t-y	64bit mode\n");
 	fprintf(stderr, "\t-n	32bit mode\n");
-	fprintf(stderr, "\t-v	Verbose mode\n");
+	fprintf(stderr, "\t-v	Verbosity(-vv dumps any decoded result)\n");
 	fprintf(stderr, "\t-s	Give a random seed (and iteration number)\n");
 	fprintf(stderr, "\t-m	Give a maximum iteration number\n");
 	fprintf(stderr, "\t-i	Give an input file with decoded binary\n");
@@ -188,7 +188,7 @@ static void parse_args(int argc, char **argv)
 			x86_64 = 0;
 			break;
 		case 'v':
-			verbose = 1;
+			verbose++;
 			break;
 		case 'i':
 			if (strcmp("-", optarg) == 0)
@@ -264,7 +264,8 @@ int main(int argc, char **argv)
 			errors++;
 		} else if (verbose && !insn_complete(&insn))
 			dump_stream(stdout, "Info: Found an undecodable input", i, insn_buf, &insn);
-
+		else if (verbose >= 2)
+			dump_insn(stdout, &insn);
 		insns++;
 	}
 

