Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab2FCXQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 19:16:19 -0400
Received: from nm9.access.bullet.mail.sp2.yahoo.com ([98.139.44.136]:22868
	"HELO nm9.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753567Ab2FCXQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 19:16:18 -0400
X-Yahoo-Newman-Id: 789283.18205.bm@omp1014.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VLxK628VM1k4FmjkH.4PoDn8efy3Rh_Ncc_U64impyURmyV
 TOtVx8ro.2_J932aABKf32W9XZ2sYlY0_0mbFIaiFhQYdL0YEhDR8TjM64I3
 cqsZYTg_oRdWely3WO2Cqz7bnfGWBJN04BpdCw1kNHwUAbgt7j8jLliUUSCf
 LyweYcGhHCSAHeT6NZxcO5ge0IjfLnvEN3p10PrxYbN62.V2T2z.qf8S4bXw
 PTJiUmT3nC9.7uT4pF3kqdzqW3Q6ODbfcJIWfsUwjXlxSS.LpsL7iWDydyWr
 ZOTXAkLEm8bfmFEdDFYRk6nqT46msmchkP1.2AncGn6v3yxnhVhKtucqdVDx
 PT6kNQy0Lvm89XOhg6wAIIOd.zQNAiodBmj2wcc1Ux9KAnYylG6EZpOwu0Iw
 22HeODA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FCBF042.2090208@att.net>
Date: Sun, 03 Jun 2012 18:16:18 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Generic rbtree: compare() vs less()
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I wanted to get with you on something you mentioned in IRC, as well as
one of your emails.  The (primary) reason my code uses a compare()
function instead of less() is that it has to work with trees that allow
unique keys.  In the fair scheduler, it doesn't matter because:
a.) duplicate keys are allowed
b.) you never need to do lookups.

If you had to do lookups, you would have to call less() twice:

if (less(p->key, key)) {
    p = p->right;
} else if (less(key, p->key)) {
    p = p->right;
} else {
    return p;
}

Using compare() means that you only call this function once and allows
for the possibility that some trees might have a more complication
compare function.  Plus, on gcc 4.5 and earlier, it's not inlining the
compare function call. :(

The reason I'm returning long from compare() instead of returning int,
is to hopefully simplify the generated code for compare functions that
need to subtract two 64-bit values and still not incur additional
overhead.  If I used int, then the compare function for a 64-bit value
would have to look like this:

int compare(u64 *a, u64 *b) {
    return *a > *b ? 1 : (*a < *b ? -1 : 0);
}
// or
int compare(u64 *a, u64 *b) {
    s64 diff = *a - *b;
    return diff > 0 ? 1: (diff < 0 ? -1 : 0);
}

And that's a whole lot more instructions, unless the compiler can inline
the function, compared the two values, use the CPU's negative & zero
flags and just completely compiled out int return value which, sadly,
just doesn't seem to happen very often. :(  (especially on 4.5 and
earlier where it fails to inline the compare function call).

Incidentally, this is what I've done on my fair.c patch:

+static inline long compare_vruntime(u64 *a, u64 *b)
+{
+#if __BITS_PER_LONG >= 64
+       return (long)((s64)*a - (s64)*b);
+#else
+/* This is hacky, but is done to reduce instructions -- we wont use
this for
+ * rbtree lookups, only inserts, and since our relationship is defined as
+ * non-unique, we only need to return positive if a > b and any other value
+ * means less than.
+ */
+       return (long)(*a > *b);
+#endif
+}

This should keep the instruction count pretty much what it was prior to
my patch on 32-bit systems as well as 64.

Anyway, please let me know if you have any other ideas on this!  I'm
going to write up a Q&A or something that explains the reasons for some
of these seemingly odd decisions. (maybe I'll even find some better
alternatives after getting feedback)

Daniel
