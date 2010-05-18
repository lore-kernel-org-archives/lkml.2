Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0ERFir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:38:47 -0400
Received: from waste.org ([173.11.57.241]:51036 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0ERFiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:38:46 -0400
Subject: Re: [PATCH] random: Check kmalloc return value and give the failed
  message
From: Matt Mackall <mpm@selenic.com>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikYvtfMgpXW5mGHmMDSoj9O0QKOMzspoDQHURxF@mail.gmail.com>
References: <AANLkTikYvtfMgpXW5mGHmMDSoj9O0QKOMzspoDQHURxF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 00:38:43 -0500
Message-ID: <1274161123.11603.507.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 13:23 +0800, Steven Liu wrote:
> Hi, Matt Mackall,
> 
> Check kmalloc return value and give the failed message
> 
> Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
> ---
>  drivers/char/random.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 2fd3d39..d1bedeb 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -952,8 +952,11 @@ static void init_std_data(struct entropy_store *r)
>     mix_pool_bytes(r, &now, sizeof(now));
>     mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
>     /* Enable continuous test in fips mode */
> -   if (fips_enabled)
> +   if (fips_enabled){
>         r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
> +       if(r->last_data == NULL)
> +           printk(KERN_ERR "kmalloc memory failed in %s \n", __func__);
> +   }

This is the wrong fix. I'm not sure how this kmalloc got in; I'm sure I
objected to it the first time around. The right answer is: use a static
buffer because a) it can't fail so no error-checking is needed and b)
EXTRACT_SIZE is only 10 bytes! That means that allocating it dynamically
as above takes more code space than you'd be saving by not allocating
it, even without the printk. Here's a better patch:

diff -r a12387bbcc93 drivers/char/random.c
--- a/drivers/char/random.c	Thu Apr 08 10:02:02 2010 -0700
+++ b/drivers/char/random.c	Tue May 18 00:38:04 2010 -0500
@@ -414,7 +414,7 @@
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+	__u8 last_data[EXTRACT_SIZE];
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -862,7 +862,7 @@
 	while (nbytes) {
 		extract_buf(r, tmp);
 
-		if (r->last_data) {
+		if (fips_enabled) {
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
@@ -951,9 +951,6 @@
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
-	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)


> 


-- 
Mathematics is the supreme nostalgia of our time.


