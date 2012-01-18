Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2ARN2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:28:20 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:14550 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2ARN2T convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 08:28:19 -0500
Message-Id: <4F16D6FD020000780006D72F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 13:28:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] perf/x86-64: make "default" memcpy() selection
 actually use glibc's implementation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since arch/x86/lib/memcpy_64.S implements not only __memcpy, but also
memcpy, without further precautions this function will get chose by the
static linker for resolving all references, and hence the "default"
measurement didn't really measure anything else than the
"x86-64-unrolled" one.

Fix this by renaming (through the pre-processor) the conflicting
symbol.

On my Westmere system, the glibc variant turns out to require about 4%
less instructions, but 15% more cycles for the default 1Mb block size
measured.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,2 @@
-
+#define memcpy MEMCPY /* don't hide glibc's memcpy() */
 #include "../../../arch/x86/lib/memcpy_64.S"



