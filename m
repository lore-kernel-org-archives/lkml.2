Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1KSAey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:34:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1KSAex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:34:53 -0500
Date: Fri, 18 Nov 2011 16:34:41 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-f14525f9e033f344996905744f41680ea2b877ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        matthltc@us.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        matthltc@us.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20111118221558.GA6408@count0.beaverton.ibm.com>
References: <20111118221558.GA6408@count0.beaverton.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/syscall] x86: Simplify syscallhdr.sh
Git-Commit-ID: f14525f9e033f344996905744f41680ea2b877ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 16:34:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f14525f9e033f344996905744f41680ea2b877ce
Gitweb:     http://git.kernel.org/tip/f14525f9e033f344996905744f41680ea2b877ce
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 18 Nov 2011 16:03:27 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Nov 2011 16:03:27 -0800

x86: Simplify syscallhdr.sh

Simplify syscallhdr.sh by letting grep sort out the ABIs that we want,
rather than relying on manual list matching.  This is safe since the
ABI strings already have to consist only of characters which are valid in C
macro names.

Suggested-by: Matt Helsley <matthltc@us.ibm.com>
Link: http://lkml.kernel.org/r/20111118221558.GA6408@count0.beaverton.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/syscalls/syscallhdr.sh |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/x86/syscalls/syscallhdr.sh b/arch/x86/syscalls/syscallhdr.sh
index 0d473ff..b3c5930 100644
--- a/arch/x86/syscalls/syscallhdr.sh
+++ b/arch/x86/syscalls/syscallhdr.sh
@@ -2,33 +2,20 @@
 
 in="$1"
 out="$2"
-my_abis=`echo "$3" | tr ',' ' '`
+my_abis=`echo "($3)" | tr ',' '|'`
 prefix="$4"
 offset="$5"
 
 fileguard=_ASM_X86_`basename "$out" | sed \
     -e 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' \
     -e 's/[^A-Z0-9_]/_/g' -e 's/__/_/g'`
-
-in_list () {
-    local x
-    for x in $1; do
-	if [ x"$x" = x"$2" ]; then
-	    return 0
-	fi
-    done
-    return 1
-}
-
-grep '^[0-9]' "$in" | sort -n | (
+grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my_abis}" "$in" | sort -n | (
     echo "#ifndef ${fileguard}"
     echo "#define ${fileguard} 1"
     echo ""
 
     while read nr abi name entry ; do
-	if in_list "$my_abis" "$abi"; then
-	    echo "#define __NR_${prefix}${name}" $((nr+offset))
-        fi
+	echo "#define __NR_${prefix}${name}" $((nr+offset))
     done
 
     echo ""
