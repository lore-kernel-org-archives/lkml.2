Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130Ab2GLMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:04:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41910 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2GLMEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:04:16 -0400
Message-ID: <1342094650.765.4.camel@mop>
Subject: Re: pr_cat() + CATSTR(name, size)?
From: Kay Sievers <kay@vrfy.org>
To: Joe Perches <joe@perches.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jul 2012 14:04:10 +0200
In-Reply-To: <1342029074.13724.113.camel@joe2Laptop>
References: <1342002808.810.12.camel@mop>
	 <1342018897.13724.61.camel@joe2Laptop>
	 <CAPXgP11XnrFayb-g5HFu3wPtw8=xLfSY7HNCCbiSoehj8KsGcw@mail.gmail.com>
	 <1342020647.13724.71.camel@joe2Laptop>
	 <CAPXgP13ff+eFH_jJ+0FDX0-GkuZj3RSv7VCp3ftcsGzA412FVQ@mail.gmail.com>
	 <1342025743.13724.102.camel@joe2Laptop>
	 <CAPXgP11pjoKLbj8oXbFBJkzeAFUHwP3CyNkT8DfpO27nBhx2eA@mail.gmail.com>
	 <1342029074.13724.113.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jul 11, 2012 at 7:51 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-07-11 at 19:25 +0200, Kay Sievers wrote:

>> > If your solution is just for the dev_<level> messages
>> > (ie: with vprintk_emit descriptors), then it's not
>> > too ugly.
>>
>> Yeah, I thought only about these. But there might be more users where
>> it makes sense to do that in a more reliable manner, don't know. It
>> was surely no meant to replace the remaining 99.9% of the other cont
>> users. :)
>
> I believe your current reassembly code only works
> on a maximum of 2 interleaved threads.  Did that change?

No, two threads doing continuation printk at the same time, will still
race against each other, and we can not reconstruct full and correct
lines later. But it's much less likely, because multiple different
continuation prints at the same time are very rare.

>> Yeah, when the size changes, we have different type of struct. So we
>> can not name them all "printk_continuation_buffer", every different
>> size would conflict with each other.
>
> It doesn't work so it doesn't matter no?

Right, it can't work.

>> Hmm, I really don't think we can teach the people, or expect them to
>> know, that these printk() functions are fragile if used in some
>> critical code paths.
>
> Vigilance. (and maybe a checkpatch test :).
> There just aren't many critical code paths.

>> printk() should just never fail, because it
>> is used to tell that something went wrong. We have the entire kmsg
>> buffer pre-allocated at bootup for that reason.
>
> I still think devolving to direct printks when OOM works
> as a fallback just fine.

I don't think we should ever try to call malloc(), it would get us into
too much trouble.

I just played a bit more with the pr_cat() idea. We can completely race
free, and limited to pretty-looking line lengths, put out large lists of
items.

It would usually just use an 80 char buffer for the line on the
stack.

[    0.000000] Kernel command line: root=/dev/sda2 ...
[    0.000000] 2:-12 -34 -56 -90
[    0.000000] 3:-12 -34 -90
[    0.000000] 4:+12 +34 -90
[    0.000000] 5:~12 ~34 -90
[    0.000000] foo: #0 #1 #2 #3 #4 #5 #6 #7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17
[    0.000000] foo+: #18 #19 #20 #21 #22 #23 #24 #25 #26 #27 #28 #29 #30 #31 #32
[    0.000000] foo+: #33 #34 #35 #36 #37 #38 #39 #40 #41 #42 #43 #44 #45 #46 #47
[    0.000000] foo+: #48 #49
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)

diff --git a/kernel/printk.c b/kernel/printk.c
index 177fa49..0f4df08 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -48,6 +48,40 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#define CATSTR_INIT(name)		\
+	name##_len = 0
+
+#define CATSTR_DEFINE(name, max)	\
+	char name[max];			\
+	size_t name##_len = 0;		\
+	size_t name##_max = max
+
+#define pr_cat(name, fmt, ...)		\
+	_pr_cat(name, &name##_len, name##_max, fmt, ##__VA_ARGS__)
+
+bool _pr_cat(char *s, size_t *len, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	size_t r;
+
+	if (*len == size)
+		return false;
+
+	va_start(args, fmt);
+	r = vsnprintf(s + *len, size - *len, fmt, args);
+	va_end(args);
+
+	if (r + 1 >= size - *len) {
+		s[*len] = '\0';
+		*len = size;
+		return false;
+	}
+
+	*len += r;
+	s[*len] = '\0';
+	return true;
+}
+
 /*
  * Architectures can override it:
  */
@@ -587,6 +621,11 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	struct devkmsg_user *user;
 	int err;
 
+	console_lock();
+	print_modules();
+	print_modules();
+	console_unlock();
+
 	/* write-only does not need any file context */
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
@@ -671,6 +710,59 @@ void __init setup_log_buf(int early)
 	unsigned long flags;
 	char *new_log_buf;
 	int free;
+	int i;
+
+	CATSTR_DEFINE(line, 64);
+	CATSTR_DEFINE(line2, 16);
+	CATSTR_DEFINE(line3, 12);
+
+	pr_cat(line, "1:");
+	pr_cat(line, "-%i ", 12);
+	pr_cat(line, "-%i ", 34);
+	pr_cat(line, "-%i ", 56);
+	pr_cat(line, "-%i ", 78);
+	pr_info("%s-%i\n", line, 90);
+
+	pr_cat(line2, "2:");
+	pr_cat(line2, "-%i ", 12);
+	pr_cat(line2, "-%i ", 34);
+	pr_cat(line2, "-%i ", 56);
+	pr_cat(line2, "-%i ", 78);
+	pr_info("%s-%i\n", line2, 90);
+
+	pr_cat(line3, "3:");
+	pr_cat(line3, "-%i ", 12);
+	pr_cat(line3, "-%i ", 34);
+	pr_cat(line3, "-%i ", 56);
+	pr_cat(line3, "-%i ", 78);
+	pr_info("%s-%i\n", line3, 90);
+
+	CATSTR_INIT(line3);
+	pr_cat(line3, "4:");
+	pr_cat(line3, "+%i ", 12);
+	pr_cat(line3, "+%i ", 34);
+	pr_cat(line3, "+%i ", 56);
+	pr_cat(line3, "+%i ", 78);
+	pr_info("%s-%i\n", line3, 90);
+
+	CATSTR_INIT(line3);
+	pr_cat(line3, "5:");
+	pr_cat(line3, "~%i ", 12);
+	pr_cat(line3, "~%i ", 34);
+	pr_cat(line3, "~%i ", 56);
+	pr_cat(line3, "~%i ", 78);
+	pr_info("%s-%i\n", line3, 90);
+
+	CATSTR_INIT(line);
+	pr_cat(line, "foo:");
+	for (i = 0; i < 50; i++) {
+		if (!pr_cat(line, " #%i", i)) {
+			pr_info("%s #%i\n", line, i);
+			CATSTR_INIT(line);
+			pr_cat(line, "foo+:");
+		}
+	}
+	pr_info("%s\n", line);
 
 	if (!new_log_buf_len)
 		return;


