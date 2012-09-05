Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2IELAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:00:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:52534 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab2IELAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:00:51 -0400
Subject: Re: [PATCH] perf bench: fix assert when NDEBUG is defined
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <CANg8OWLL6gzUpZuq8YT2bSbT5=EVWejbpCX0TM8dt7mKXyZ9Yg@mail.gmail.com>
References: <CANg8OWLL6gzUpZuq8YT2bSbT5=EVWejbpCX0TM8dt7mKXyZ9Yg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Sep 2012 13:00:39 +0200
Message-ID: <1346842839.2461.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-03 at 03:04 +0300, Irina Tirdea wrote:
> -       BUG_ON(gettimeofday(&tv_start, NULL));
> +       ret = gettimeofday(&tv_start, NULL);
> +       BUG_ON(ret); 

Its valid (although admittedly dubious) to have BUG_ON with
side-effects.

The 'right' fix would be something like:

---
 tools/perf/util/include/linux/kernel.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index b6842c1..a5efd924 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -47,8 +47,12 @@
 #endif
 
 #ifndef BUG_ON
+#ifdef NDEBUG
+#define BUG_ON(cond) do { if (cond) ; } while (0)
+#else
 #define BUG_ON(cond) assert(!(cond))
 #endif
+#endif
 
 /*
  * Both need more care to handle endianness


