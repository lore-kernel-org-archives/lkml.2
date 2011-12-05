Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab1LERp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:45:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab1LERp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:45:28 -0500
Date: Mon, 5 Dec 2011 09:45:03 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-9dde9dc0a81c7aeb863b35121d09011f09b4897c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111205120603.15475.91192.stgit@cloud>
References: <20111205120603.15475.91192.stgit@cloud>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/tools: Add decoded instruction dump mode
Git-Commit-ID: 9dde9dc0a81c7aeb863b35121d09011f09b4897c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:45:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9dde9dc0a81c7aeb863b35121d09011f09b4897c
Gitweb:     http://git.kernel.org/tip/9dde9dc0a81c7aeb863b35121d09011f09b4897c
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 5 Dec 2011 21:06:03 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 14:53:23 +0100

x86/tools: Add decoded instruction dump mode

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
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20111205120603.15475.91192.stgit@cloud
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
