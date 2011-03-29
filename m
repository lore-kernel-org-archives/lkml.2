Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1C2Ord (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:47:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1C2Orb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:47:31 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=P8oO77IduGQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=6R9DKKSKLBkKaQNQ5BsA:9 a=ESjLVuH9CJ7c8qP-RXgA:7 a=8BWC6-MDkCRaCE_h_5pLY8yGCLwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <8fa65ade-2b9f-4f05-9b52-dfd770326f44@email.android.com>
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
	 <4D90A08D.707@zytor.com>
	 <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
	 <4D90A1FE.4000405@zytor.com>
	 <1301324940.14261.232.camel@gandalf.stny.rr.com>
	 <20110328181855.GA6146@p183.telecom.by> <20110329073037.GK27398@elte.hu>
	 <8fa65ade-2b9f-4f05-9b52-dfd770326f44@email.android.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 10:47:28 -0400
Message-ID: <1301410048.14261.279.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 07:32 -0700, H. Peter Anvin wrote:
> I think the question is what are the expected semantics if WARN_ON_SMP
> is used in an if... especially for UP.

Well, actually this whole patchset was created because we added the
semantic if (WARN_ON_SMP(x)).

This patch: https://lkml.org/lkml/2011/3/11/463


Added the following code:


+static void __unqueue_futex(struct futex_q *q)
+{
+	struct futex_hash_bucket *hb;
+
+	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
+			|| plist_node_empty(&q->list)))
+		return;
+
+	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
+	plist_del(&q->list, &hb->chain);
+}


Which on !CONFIG_SMP broke, because that "|| !spin_is_locked()" always
return true and we trigger the WARN_ON() as well as returning early,
breaking the code, and triggering bugs, as we never do the
"plist_del()".

To fix this, I added: https://lkml.org/lkml/2011/3/17/312

Which does this change:

@@ -785,8 +785,8 @@ static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
-			|| plist_node_empty(&q->list)))
+	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
+	    || WARN_ON(plist_node_empty(&q->list)))
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);


But as WARN_ON_SMP() currently had no if () context, I needed to first
make the change of: https://lkml.org/lkml/2011/3/17/313

#ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
-# define WARN_ON_SMP(x)			do { } while (0)
+# define WARN_ON_SMP(x)			({0;})
 #endif

But if this is such a problem, we can revert all this and do:

@@ -785,8 +785,11 @@ static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
-			|| plist_node_empty(&q->list)))
+#ifdef CONFIG_SMP
+	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
+		return;
+#endif
+	if (WARN_ON(plist_node_empty(&q->list)))
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);


And leave the WARN_ON_SMP() alone.

-- Steve


