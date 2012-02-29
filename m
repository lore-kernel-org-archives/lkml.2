Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030891Ab2B2HvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:51:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030198Ab2B2HvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:51:10 -0500
Date: Tue, 28 Feb 2012 23:50:27 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-a51f4047758d2bcd099ea113b833ed380f4024ba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, nbowler@elliptictech.com, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, matt@console-pimps.org,
        tglx@linutronix.de, sfr@canb.auug.org.au
Reply-To: mingo@redhat.com, hpa@zytor.com, nbowler@elliptictech.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        matt@console-pimps.org, tglx@linutronix.de, sfr@canb.auug.org.au
In-Reply-To: <20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
References: <20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, build:
  Fix portability issues when cross-building
Git-Commit-ID: a51f4047758d2bcd099ea113b833ed380f4024ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 23:50:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a51f4047758d2bcd099ea113b833ed380f4024ba
Gitweb:     http://git.kernel.org/tip/a51f4047758d2bcd099ea113b833ed380f4024ba
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 28 Feb 2012 23:36:21 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 28 Feb 2012 23:40:56 -0800

x86, build: Fix portability issues when cross-building

It would appear that we never actually generated a correct CRC when
building on a bigendian machine.  Depending on the word size, we would
either generate an all-zero CRC (64-bit machine) or a byte-swapped
CRC (32-bit machine.)  Fix the types used so we don't arbitrarily use
a 64-bit word to hold 32-bit numbers, and pass the CRC through
put_unaligned_le32() like all the other numbers.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Bowler <nbowler@elliptictech.com>
Link: http://lkml.kernel.org/r/20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au
---
 arch/x86/boot/tools/build.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index f3bd2e6..ed54976 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -36,7 +36,7 @@
 
 typedef unsigned char  u8;
 typedef unsigned short u16;
-typedef unsigned long  u32;
+typedef unsigned int   u32;
 
 #define DEFAULT_MAJOR_ROOT 0
 #define DEFAULT_MINOR_ROOT 0
@@ -247,8 +247,9 @@ int main(int argc, char ** argv)
 	}
 
 	/* Write the CRC */
-	fprintf(stderr, "CRC %lx\n", crc);
-	if (fwrite(&crc, 1, 4, stdout) != 4)
+	fprintf(stderr, "CRC %x\n", crc);
+	put_unaligned_le32(crc, buf);
+	if (fwrite(buf, 1, 4, stdout) != 4)
 		die("Writing CRC failed");
 
 	close(fd);
