Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1JJNmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:42:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1JJNls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:48 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=BFeodAn88ZkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=wXrWetmS4ZzqdOzb6hUA:9 a=b2ujFcayTMJmpIGjTEQA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=gpF95cLF8i9YOegmH3UA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134146.557023500@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 20/20] tracing: Do not allocate buffer for trace_marker
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0020-tracing-Do-not-allocate-buffer-for-trace_marker.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When doing intense tracing, the kmalloc inside trace_marker can
introduce side effects to what is being traced.

As trace_marker() is used by userspace to inject data into the
kernel ring buffer, it needs to do so with the least amount
of intrusion to the operations of the kernel or the user space
application.

As the ring buffer is designed to write directly into the buffer
without the need to make a temporary buffer, and userspace already
went through the hassle of knowing how big the write will be,
we can simply pin the userspace pages and write the data directly
into the buffer. This improves the impact of tracing via trace_marker
tremendously!

Thanks to Peter Zijlstra and Thomas Gleixner for pointing out the
use of get_user_pages_fast() and kmap_atomic().

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  111 +++++++++++++++++++++++++++++++++++++---------=
----
 1 files changed, 83 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 13f2b84..f86efe9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3628,22 +3628,24 @@ tracing_free_buffer_release(struct inode *inode, st=
ruct file *filp)
 	return 0;
 }
=20
-static int mark_printk(const char *fmt, ...)
-{
-	int ret;
-	va_list args;
-	va_start(args, fmt);
-	ret =3D trace_vprintk(0, fmt, args);
-	va_end(args);
-	return ret;
-}
-
 static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
-	char *buf;
-	size_t written;
+	unsigned long addr =3D (unsigned long)ubuf;
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
+	struct print_entry *entry;
+	unsigned long irq_flags;
+	struct page *pages[2];
+	int nr_pages =3D 1;
+	ssize_t written;
+	void *page1;
+	void *page2;
+	int offset;
+	int size;
+	int len;
+	int ret;
=20
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3651,28 +3653,81 @@ tracing_mark_write(struct file *filp, const char __=
user *ubuf,
 	if (cnt > TRACE_BUF_SIZE)
 		cnt =3D TRACE_BUF_SIZE;
=20
-	buf =3D kmalloc(cnt + 2, GFP_KERNEL);
-	if (buf =3D=3D NULL)
-		return -ENOMEM;
+	/*
+	 * Userspace is injecting traces into the kernel trace buffer.
+	 * We want to be as non intrusive as possible.
+	 * To do so, we do not want to allocate any special buffers
+	 * or take any locks, but instead write the userspace data
+	 * straight into the ring buffer.
+	 *
+	 * First we need to pin the userspace buffer into memory,
+	 * which, most likely it is, because it just referenced it.
+	 * But there's no guarantee that it is. By using get_user_pages_fast()
+	 * and kmap_atomic/kunmap_atomic() we can get access to the
+	 * pages directly. We then write the data directly into the
+	 * ring buffer.
+	 */
+	BUILD_BUG_ON(TRACE_BUF_SIZE >=3D PAGE_SIZE);
=20
-	if (copy_from_user(buf, ubuf, cnt)) {
-		kfree(buf);
-		return -EFAULT;
+	/* check if we cross pages */
+	if ((addr & PAGE_MASK) !=3D ((addr + cnt) & PAGE_MASK))
+		nr_pages =3D 2;
+
+	offset =3D addr & (PAGE_SIZE - 1);
+	addr &=3D PAGE_MASK;
+
+	ret =3D get_user_pages_fast(addr, nr_pages, 0, pages);
+	if (ret < nr_pages) {
+		while (--ret >=3D 0)
+			put_page(pages[ret]);
+		written =3D -EFAULT;
+		goto out;
 	}
-	if (buf[cnt-1] !=3D '\n') {
-		buf[cnt] =3D '\n';
-		buf[cnt+1] =3D '\0';
+
+	page1 =3D kmap_atomic(pages[0]);
+	if (nr_pages =3D=3D 2)
+		page2 =3D kmap_atomic(pages[1]);
+
+	local_save_flags(irq_flags);
+	size =3D sizeof(*entry) + cnt + 2; /* possible \n added */
+	buffer =3D global_trace.buffer;
+	event =3D trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
+					  irq_flags, preempt_count());
+	if (!event) {
+		/* Ring buffer disabled, return as if not open for write */
+		written =3D -EBADF;
+		goto out_unlock;
+	}
+
+	entry =3D ring_buffer_event_data(event);
+	entry->ip =3D _THIS_IP_;
+
+	if (nr_pages =3D=3D 2) {
+		len =3D PAGE_SIZE - offset;
+		memcpy(&entry->buf, page1 + offset, len);
+		memcpy(&entry->buf[len], page2, cnt - len);
 	} else
-		buf[cnt] =3D '\0';
+		memcpy(&entry->buf, page1 + offset, cnt);
=20
-	written =3D mark_printk("%s", buf);
-	kfree(buf);
-	*fpos +=3D written;
+	if (entry->buf[cnt - 1] !=3D '\n') {
+		entry->buf[cnt] =3D '\n';
+		entry->buf[cnt + 1] =3D '\0';
+	} else
+		entry->buf[cnt] =3D '\0';
+
+	ring_buffer_unlock_commit(buffer, event);
=20
-	/* don't tell userspace we wrote more - it might confuse them */
-	if (written > cnt)
-		written =3D cnt;
+	written =3D cnt;
=20
+	*fpos +=3D written;
+
+ out_unlock:
+	if (nr_pages =3D=3D 2)
+		kunmap_atomic(page2);
+	kunmap_atomic(page1);
+	while (nr_pages > 0)
+		put_page(pages[--nr_pages]);
+ out:
 	return written;
 }
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYaAAoJEIy3vGnGbaoAvY0P/iF2drtd8B+8J+KHVxf+P8KY
u1ApBn1t83BeVSHs1V4RxNjxT2pkU8DJXYPpo4S4xljwaNjxeDfA/UzQ4tNDD870
ebdrM9EX2TyRYBN3ISxvFpBXxhDX39hB1fWs7FHJypFxc13Cavt05bzbvlPz+GeV
3fXXqwuNCJr+AdC2FU9dMpV39PVqwBqay9LLhNWOKnUrkLH4DDMSKCubLZZa3AoV
kdLxum5K17QS5PH6HO0q9gRQj5BhAcJ7sjm092tLkSe0PmDa3ouO/xDHZI1Sa35j
HazHC27HyZzT9Cjt+sYXAnXzcqrGyYLhlMvQ0WrYqIGtTimYH87koAotlKEPinGG
RxgLSnFWTafMWEAq0cF/lLJzBplKBhXzbvnvf8xuSIqe1l2jP7eE6Trh6DoMCNbT
vDNFqa9R60LJb0Vp9aDKplMoM2GP90rTx9mOAA3dX8h55e9AEw1n9Ca2oofRnYJV
LCNvj91WwhSrtKlc2NrhJWI0IrCXju3wmITgjCAteeI0PyckfFywqlAUbNxZrYLG
WLLR2JNgZD+v9eNxXnhl9r5n+PSRLMEa6FXnsFhtmLtj5PTB+vsYj+TH2mrfO/Q0
k1AMOtlbXdZ+Pb9khJ6AMmlWoagc3DLu+lZALusAfapqusONuuQIMdqFfS6xaJqe
4jcY0s09saF4mD5/afHP
=yQlz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
