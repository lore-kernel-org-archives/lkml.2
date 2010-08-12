Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999Ab0HLW2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:28:23 -0400
Received: from trinity.develer.com ([83.149.158.210]:43807 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937Ab0HLW2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:28:21 -0400
Date: Fri, 13 Aug 2010 00:28:13 +0200
From: Andrea Righi <arighi@develer.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kfifo: add kfifo_skip() testcase
Message-ID: <20100812222802.GA17763@linux.develer.com>
References: <1281627158-9461-1-git-send-email-arighi@develer.com>
 <1281627158-9461-2-git-send-email-arighi@develer.com>
 <20100812142211.59e24462.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812142211.59e24462.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 02:22:11PM -0700, Andrew Morton wrote:
> On Thu, 12 Aug 2010 17:32:38 +0200
> Andrea Righi <arighi@develer.com> wrote:
> 
> > Add a testcase for kfifo_skip() to the byte stream fifo example.
> > 
> > Signed-off-by: Andrea Righi <arighi@develer.com>
> > ---
> >  samples/kfifo/bytestream-example.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
> > index 642eef3..2e3a7a8 100644
> > --- a/samples/kfifo/bytestream-example.c
> > +++ b/samples/kfifo/bytestream-example.c
> > @@ -73,6 +73,10 @@ static int __init testfunc(void)
> >  	ret = kfifo_in(&test, buf, ret);
> >  	printk(KERN_INFO "ret: %d\n", ret);
> >  
> > +	/* skip first element of the fifo */
> > +	printk(KERN_INFO "skip 1st element\n");
> > +	kfifo_skip(&test);
> > +
> >  	/* put values into the fifo until is full */
> >  	for (i = 20; kfifo_put(&test, &i); i++)
> >  		;
> 
> hm, that's not a very good test harness.  A better one would check that
> the resulting kfifo actually contains the expected items in the
> expected order.  AFACIT this will "pass" even if kfifo_skip() is a
> no-op, or execs nethack or something.
> 
> Oh well, it's more than we usually get.

Agreed. Something like this is probably more meaningful.

---
kfifo: add explicit error checking in byte stream example

Provide a static array of expected items that kfifo should contain at
the end of the test to validate it.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 samples/kfifo/bytestream-example.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index 2e3a7a8..a94e694 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -44,10 +44,17 @@ static struct kfifo test;
 static DECLARE_KFIFO(test, unsigned char, FIFO_SIZE);
 #endif
 
+static unsigned char expected_result[FIFO_SIZE] = {
+	 3,  4,  5,  6,  7,  8,  9,  0,
+	 1, 20, 21, 22, 23, 24, 25, 26,
+	27, 28, 29, 30, 31, 32, 33, 34,
+	35, 36, 37, 38, 39, 40, 41, 42,
+};
+
 static int __init testfunc(void)
 {
 	unsigned char	buf[6];
-	unsigned char	i;
+	unsigned char	i, j;
 	unsigned int	ret;
 
 	printk(KERN_INFO "byte stream fifo test start\n");
@@ -83,10 +90,19 @@ static int __init testfunc(void)
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
 
-	/* print out all values in the fifo */
-	while (kfifo_get(&test, &i))
-		printk("%d ", i);
-	printk("\n");
+	/* check the correctness of all values in the fifo */
+	j = 0;
+	while (kfifo_get(&test, &i)) {
+		if (i != expected_result[j++]) {
+			printk(KERN_WARNING "value mismatch: test failed\n");
+			return -EIO;
+		}
+	}
+	if (j != ARRAY_SIZE(expected_result)) {
+		printk(KERN_WARNING "size mismatch: test failed\n");
+		return -EIO;
+	}
+	printk(KERN_INFO "test passed\n");
 
 	return 0;
 }
@@ -142,7 +158,12 @@ static int __init example_init(void)
 #else
 	INIT_KFIFO(test);
 #endif
-	testfunc();
+	if (testfunc() < 0) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -EIO;
+	}
 
 	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
 #ifdef DYNAMIC

