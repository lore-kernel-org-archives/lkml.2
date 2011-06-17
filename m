Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab1FQQKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:10:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65067 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab1FQQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Uw6d4/+GtctXiVYEl0hnMRwoCCFdQ/+yxzkfabaaoCeu+KnyX+wRTbsFCsOfkM7ZiE
         d9xUqiGDRhzZFYOsnJixagm5+Pm6WT32vInJUuLSued5tHT4M8laH7Uv9o2FqsFSJKm2
         MbLNJEodsEs+y9Lnb3p3/Dnie4qzpuh4whTYo=
Date: Fri, 17 Jun 2011 20:10:46 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm tools: Fix broken terminal when kvm exits because of a
 signal
Message-ID: <20110617161046.GA13705@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issuing 'killall kvm' leaves the terminal on which kvm was running in
a broken state. This is because atexit(3) handlers are not called if
a process terminates because of a signal.

Installing a proper handler for the TERM signal fixes the issue.

p.s. The rest of the kvm tools use signal(2), and not sigaction(2), so
     I continue the tradition.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 tools/kvm/term.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/kvm/term.c b/tools/kvm/term.c
index 689d52d..9947223 100644
--- a/tools/kvm/term.c
+++ b/tools/kvm/term.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/uio.h>
+#include <signal.h>
 
 #include "kvm/read-write.h"
 #include "kvm/term.h"
@@ -102,6 +103,13 @@ static void term_cleanup(void)
 	tcsetattr(STDIN_FILENO, TCSANOW, &orig_term);
 }
 
+static void term_sig_cleanup(int sig)
+{
+	term_cleanup();
+	signal(sig, SIG_DFL);
+	raise(sig);
+}
+
 void term_init(void)
 {
 	struct termios term;
@@ -113,5 +121,6 @@ void term_init(void)
 	term.c_lflag &= ~(ICANON | ECHO | ISIG);
 	tcsetattr(STDIN_FILENO, TCSANOW, &term);
 
+	signal(SIGTERM, term_sig_cleanup);
 	atexit(term_cleanup);
 }
-- 
1.7.5.3
