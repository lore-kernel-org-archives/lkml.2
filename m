Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0FIVqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:46:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47169 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab0FIVqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LGA+H2cjIvqKS/7UAzyDlNLwPYzO6jg9UnjuKGzGuXUe6brTijRFC+OyyasbS6lGJ+
         JWuqBRPi09guasiXPz1h+odaHXPSkKGLTJAF/X67Ju4OZf86Io5I9HkiVXnY2LsC78p9
         8N/gIY3vQxs19yO8uFNIfuM9UX1wHDgcPiJPU=
Date: Thu, 10 Jun 2010 00:46:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, yi.y.yang@intel.com
Subject: [PATCH 1/2] kstrto*: converting strings to integers done
 (hopefully) right
Message-ID: <20100609214616.GA31340@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. simple_strto*() suck because they do not contain overflow checks
   and crufty, libc way to indicate failure.
2. strict_strto*() also do not have overflow checks but the name
   and comments pretend they do.
3. Both have only "long long" and "long" versions, but users want
   e. g. strtouint()
4. Both "simple" and "strict" prefixes are wrong:
   Simple doesn't say what's so simple, strict should not exist because
   conversion should be strict by default.

   The solution is to use "k" prefix and add convertors for more types.

   Enter

   	kstrtoull(),
	kstrtoll(),
	kstrtoul(),
	kstrtol(),
	kstrtouint(),
	kstrtoint(),
	kstrtou64(),
	kstrtos64(),
	kstrtou32(),
	kstrtos32(),
	kstrtou16(),
	kstrtos16(),
	kstrtou8(),
	kstrtos8()

   and, horrors, a runtime testsuite (although incomplete).

Use kstrto*() in your code today!

strict_strto*() become deprecated, stubbed to kstrto*() and eventually
removed altogether.

I _hope_ kstrto*() will remain the only family of converters (along with
scanf() of course).

P. S.: sizeof() and __alignof__() trick is done to shortcut a function call
	when types are indistinguishable.
---

 include/linux/kernel.h |   49 ++++++-
 lib/Kconfig.debug      |    3 +
 lib/Makefile           |    2 +
 lib/kstrtox.c          |  225 ++++++++++++++++++++++++++++++
 lib/test-kstrtox.c     |  356 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c         |  147 --------------------
 6 files changed, 631 insertions(+), 151 deletions(-)
 create mode 100644 lib/kstrtox.c
 create mode 100644 lib/test-kstrtox.c

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..9006128 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -182,14 +182,55 @@ NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
+
+int kstrtoull(const char *s, unsigned int base, unsigned long long *res);
+int kstrtoll(const char *s, unsigned int base, long long *res);
+int _kstrtoul(const char *s, unsigned int base, unsigned long *res);
+static inline int kstrtoul(const char *s, unsigned int base, unsigned long *res)
+{
+	if (sizeof(unsigned long) == sizeof(unsigned long long) &&
+	    __alignof__(unsigned long) == __alignof__(unsigned long long))
+		return kstrtoull(s, base, (unsigned long long *)res);
+	else
+		return _kstrtoul(s, base, res);
+}
+
+int _kstrtol(const char *s, unsigned int base, long *res);
+static inline int kstrtol(const char *s, unsigned int base, long *res)
+{
+	if (sizeof(long) == sizeof(long long) &&
+	    __alignof__(long) == __alignof__(long long))
+		return kstrtoll(s, base, (long long *)res);
+	else
+		return _kstrtol(s, base, res);
+}
+
+int kstrtouint(const char *s, unsigned int base, unsigned int *res);
+int kstrtoint(const char *s, unsigned int base, int *res);
+
+static inline int kstrtou64(const char *s, unsigned int base, u64 *res)
+{
+	return kstrtoull(s, base, res);
+}
+
+static inline int kstrtou32(const char *s, unsigned int base, u32 *res)
+{
+	return kstrtouint(s, base, res);
+}
+
+int kstrtou16(const char *s, unsigned int base, u16 *res);
+int kstrtos16(const char *s, unsigned int base, s16 *res);
+int kstrtou8(const char *s, unsigned int base, u8 *res);
+int kstrtos8(const char *s, unsigned int base, s8 *res);
+
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
-extern int strict_strtoul(const char *, unsigned int, unsigned long *);
-extern int strict_strtol(const char *, unsigned int, long *);
-extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
-extern int strict_strtoll(const char *, unsigned int, long long *);
+#define strict_strtoul	kstrtoul
+#define strict_strtol	kstrtol
+#define strict_strtoull	kstrtoull
+#define strict_strtoll	kstrtoll
 extern int sprintf(char * buf, const char * fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..226384f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1122,3 +1122,6 @@ source "samples/Kconfig"
 source "lib/Kconfig.kgdb"
 
 source "lib/Kconfig.kmemcheck"
+
+config TEST_KSTRTOX
+	tristate "Test kstrto*() family of functions at runtime"
diff --git a/lib/Makefile b/lib/Makefile
index 3f1062c..115c917 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -22,6 +22,8 @@ lib-y	+= kobject.o kref.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
+obj-y += kstrtox.o
+obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
new file mode 100644
index 0000000..fe792b5
--- /dev/null
+++ b/lib/kstrtox.c
@@ -0,0 +1,225 @@
+/*
+ * Convert integer string representation to an integer.
+ * If an integer doesn't fit into specified type, -E is returned.
+ *
+ * Integer starts with optional sign.
+ * kstrtou*() functions do not accept sign "-".
+ *
+ * Radix 0 means autodetection: leading "0x" implies radix 16,
+ * leading "0" implies radix 8, otherwise radix is 10.
+ * Autodetection hints work after optional sign, but not before.
+ *
+ * If -E is returned, result is not touched.
+ */
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/math64.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+static inline char _tolower(const char c)
+{
+	return c | 0x20;
+}
+
+static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	unsigned long long acc;
+	int ok;
+
+	if (base == 0) {
+		if (s[0] == '0') {
+			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
+				base = 16;
+			else
+				base = 8;
+		} else
+			base = 10;
+	}
+	if (base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
+		s += 2;
+
+	acc = 0;
+	ok = 0;
+	while (*s) {
+		unsigned int val;
+
+		if ('0' <= *s && *s <= '9')
+			val = *s - '0';
+		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
+			val = _tolower(*s) - 'a' + 10;
+		else if (*s == '\n') {
+			if (*(s + 1) == '\0')
+				break;
+			else
+				return -EINVAL;
+		} else
+			return -EINVAL;
+
+		if (val >= base)
+			return -EINVAL;
+		if (acc > div_u64(ULLONG_MAX - val, base))
+			return -EINVAL;
+		acc = acc * base + val;
+		ok = 1;
+
+		s++;
+	}
+	if (!ok)
+		return -EINVAL;
+	*res = acc;
+	return 0;
+}
+
+int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	if (s[0] == '+')
+		s++;
+	return _kstrtoull(s, base, res);
+}
+EXPORT_SYMBOL(kstrtoull);
+
+int kstrtoll(const char *s, unsigned int base, long long *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	if (s[0] == '-') {
+		rv = _kstrtoull(s + 1, base, &tmp);
+		if (rv < 0)
+			return rv;
+		if ((long long)(-tmp) >= 0)
+			return -EINVAL;
+		*res = -tmp;
+	} else {
+		rv = kstrtoull(s, base, &tmp);
+		if (rv < 0)
+			return rv;
+		if ((long long)tmp < 0)
+			return -EINVAL;
+		*res = tmp;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(kstrtoll);
+
+int _kstrtoul(const char *s, unsigned int base, unsigned long *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(unsigned long)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(_kstrtoul);
+
+int _kstrtol(const char *s, unsigned int base, long *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(long)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(_kstrtol);
+
+int kstrtouint(const char *s, unsigned int base, unsigned int *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(unsigned int)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtouint);
+
+int kstrtoint(const char *s, unsigned int base, int *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(int)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtoint);
+
+int kstrtou16(const char *s, unsigned int base, u16 *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(u16)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtou16);
+
+int kstrtos16(const char *s, unsigned int base, s16 *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(s16)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtos16);
+
+int kstrtou8(const char *s, unsigned int base, u8 *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(u8)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtou8);
+
+int kstrtos8(const char *s, unsigned int base, s8 *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(s8)tmp)
+		return -EINVAL;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtos8);
diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
new file mode 100644
index 0000000..56fda26
--- /dev/null
+++ b/lib/test-kstrtox.c
@@ -0,0 +1,356 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#define for_each_test(i, test)	\
+	for (i = 0; i < sizeof(test) / sizeof(test[0]); i++)
+
+struct test_fail {
+	const char *str;
+	unsigned int base;
+};
+
+#define DEFINE_TEST_FAIL(test)	\
+	const struct test_fail test[] __initdata
+
+#define DECLARE_TEST_OK(type, test_type)	\
+	test_type {				\
+		const char *str;		\
+		unsigned int base;		\
+		type expected_res;		\
+	}
+
+#define DEFINE_TEST_OK(type, test)	\
+	const type test[] __initdata
+
+#define TEST_FAIL(fn, type, fmt, test)					\
+{									\
+	unsigned int i;							\
+									\
+	for_each_test(i, test) {					\
+		const struct test_fail *t = &test[i];			\
+		type tmp;						\
+		int rv;							\
+									\
+		tmp = 0;						\
+		rv = fn(t->str, t->base, &tmp);				\
+		if (rv >= 0) {						\
+			WARN(1, "str '%s', base %u, expected -E, got %d/" fmt "\n",	\
+				t->str, t->base, rv, tmp);		\
+			continue;					\
+		}							\
+	}								\
+}
+
+#define TEST_OK(fn, type, fmt, test)					\
+{									\
+	unsigned int i;							\
+									\
+	for_each_test(i, test) {					\
+		const typeof(test[0]) *t = &test[i];			\
+		type res;						\
+		int rv;							\
+									\
+		rv = fn(t->str, t->base, &res);				\
+		if (rv != 0) {						\
+			WARN(1, "str '%s', base %u, expected 0/" fmt ", got %d\n",	\
+				t->str, t->base, t->expected_res, rv);	\
+			continue;					\
+		}							\
+		if (res != t->expected_res) {				\
+			WARN(1, "str '%s', base %u, expected " fmt ", got " fmt "\n",	\
+				t->str, t->base, t->expected_res, res);	\
+			continue;					\
+		}							\
+	}								\
+}
+
+static void __init test_kstrtoull_ok(void)
+{
+	DECLARE_TEST_OK(unsigned long long, struct test_ull);
+	static DEFINE_TEST_OK(struct test_ull, test_ull_ok) = {
+		{"0",	10,	0ULL},
+		{"1",	10,	1ULL},
+		{"127",	10,	127ULL},
+		{"128",	10,	128ULL},
+		{"129",	10,	129ULL},
+		{"255",	10,	255ULL},
+		{"256",	10,	256ULL},
+		{"257",	10,	257ULL},
+		{"32767",	10,	32767ULL},
+		{"32768",	10,	32768ULL},
+		{"32769",	10,	32769ULL},
+		{"65535",	10,	65535ULL},
+		{"65536",	10,	65536ULL},
+		{"65537",	10,	65537ULL},
+		{"2147483647",	10,	2147483647ULL},
+		{"2147483648",	10,	2147483648ULL},
+		{"2147483649",	10,	2147483649ULL},
+		{"4294967295",	10,	4294967295ULL},
+		{"4294967296",	10,	4294967296ULL},
+		{"4294967297",	10,	4294967297ULL},
+		{"9223372036854775807",	10,	9223372036854775807ULL},
+		{"9223372036854775808",	10,	9223372036854775808ULL},
+		{"9223372036854775809",	10,	9223372036854775809ULL},
+		{"18446744073709551614",	10,	18446744073709551614ULL},
+		{"18446744073709551615",	10,	18446744073709551615ULL},
+
+		{"00",		8,	00ULL},
+		{"01",		8,	01ULL},
+		{"0177",	8,	0177ULL},
+		{"0200",	8,	0200ULL},
+		{"0201",	8,	0201ULL},
+		{"0377",	8,	0377ULL},
+		{"0400",	8,	0400ULL},
+		{"0401",	8,	0401ULL},
+		{"077777",	8,	077777ULL},
+		{"0100000",	8,	0100000ULL},
+		{"0100001",	8,	0100001ULL},
+		{"0177777",	8,	0177777ULL},
+		{"0200000",	8,	0200000ULL},
+		{"0200001",	8,	0200001ULL},
+		{"017777777777",	8,	017777777777ULL},
+		{"020000000000",	8,	020000000000ULL},
+		{"020000000001",	8,	020000000001ULL},
+		{"037777777777",	8,	037777777777ULL},
+		{"040000000000",	8,	040000000000ULL},
+		{"040000000001",	8,	040000000001ULL},
+		{"0777777777777777777777",	8,	0777777777777777777777ULL},
+		{"01000000000000000000000",	8,	01000000000000000000000ULL},
+		{"01000000000000000000001",	8,	01000000000000000000001ULL},
+		{"01777777777777777777776",	8,	01777777777777777777776ULL},
+		{"01777777777777777777777",	8,	01777777777777777777777ULL},
+
+		{"0x0",		16,	0x0ULL},
+		{"0x1",		16,	0x1ULL},
+		{"0x7f",	16,	0x7fULL},
+		{"0x80",	16,	0x80ULL},
+		{"0x81",	16,	0x81ULL},
+		{"0xff",	16,	0xffULL},
+		{"0x100",	16,	0x100ULL},
+		{"0x101",	16,	0x101ULL},
+		{"0x7fff",	16,	0x7fffULL},
+		{"0x8000",	16,	0x8000ULL},
+		{"0x8001",	16,	0x8001ULL},
+		{"0xffff",	16,	0xffffULL},
+		{"0x10000",	16,	0x10000ULL},
+		{"0x10001",	16,	0x10001ULL},
+		{"0x7fffffff",	16,	0x7fffffffULL},
+		{"0x80000000",	16,	0x80000000ULL},
+		{"0x80000001",	16,	0x80000001ULL},
+		{"0xffffffff",	16,	0xffffffffULL},
+		{"0x100000000",	16,	0x100000000ULL},
+		{"0x100000001",	16,	0x100000001ULL},
+		{"0x7fffffffffffffff",	16,	0x7fffffffffffffffULL},
+		{"0x8000000000000000",	16,	0x8000000000000000ULL},
+		{"0x8000000000000001",	16,	0x8000000000000001ULL},
+		{"0xfffffffffffffffe",	16,	0xfffffffffffffffeULL},
+		{"0xffffffffffffffff",	16,	0xffffffffffffffffULL},
+
+		{"0\n",	0,	0ULL},
+	};
+	TEST_OK(kstrtoull, unsigned long long, "%llu", test_ull_ok);
+}
+
+static void __init test_kstrtoull_fail(void)
+{
+	static DEFINE_TEST_FAIL(test_ull_fail) = {
+		{"",	0},
+		{"",	8},
+		{"",	10},
+		{"",	16},
+		{"\n",	0},
+		{"\n",	8},
+		{"\n",	10},
+		{"\n",	16},
+		{"\n0",	0},
+		{"\n0",	8},
+		{"\n0",	10},
+		{"\n0",	16},
+		{"+",	0},
+		{"+",	8},
+		{"+",	10},
+		{"+",	16},
+		{"-",	0},
+		{"-",	8},
+		{"-",	10},
+		{"-",	16},
+		{"0x",	0},
+		{"0x",	16},
+		{"0X",	0},
+		{"0X",	16},
+		{"0 ",	0},
+		{"1+",	0},
+		{"1-",	0},
+		{" 2",	0},
+		/* base autodetection */
+		{"0x0z",	0},
+		{"0z",		0},
+		{"a",		0},
+		/* digit >= base */
+		{"2",	2},
+		{"8",	8},
+		{"a",	10},
+		{"A",	10},
+		{"g",	16},
+		{"G",	16},
+		/* overflow */
+		{"10000000000000000000000000000000000000000000000000000000000000000",	2},
+		{"2000000000000000000000",	8},
+		{"18446744073709551616",	10},
+		{"10000000000000000",	16},
+		/* negative */
+		{"-0", 0},
+		{"-0", 8},
+		{"-0", 10},
+		{"-0", 16},
+		{"-1", 0},
+		{"-1", 8},
+		{"-1", 10},
+		{"-1", 16},
+		/* sign is first character if any */
+		{"-+1", 0},
+		{"-+1", 8},
+		{"-+1", 10},
+		{"-+1", 16},
+		/* nothing after \n */
+		{"0\n0", 0},
+		{"0\n0", 8},
+		{"0\n0", 10},
+		{"0\n0", 16},
+		{"0\n+", 0},
+		{"0\n+", 8},
+		{"0\n+", 10},
+		{"0\n+", 16},
+		{"0\n-", 0},
+		{"0\n-", 8},
+		{"0\n-", 10},
+		{"0\n-", 16},
+		{"0\n ", 0},
+		{"0\n ", 8},
+		{"0\n ", 10},
+		{"0\n ", 16},
+	};
+	TEST_FAIL(kstrtoull, unsigned long long, "%llu", test_ull_fail);
+}
+
+static void __init test_kstrtoll_ok(void)
+{
+	DECLARE_TEST_OK(long long, struct test_ll);
+	static DEFINE_TEST_OK(struct test_ll, test_ll_ok) = {
+		{"0",	10,	0LL},
+		{"1",	10,	1LL},
+		{"127",	10,	127LL},
+		{"128",	10,	128LL},
+		{"129",	10,	129LL},
+		{"255",	10,	255LL},
+		{"256",	10,	256LL},
+		{"257",	10,	257LL},
+		{"32767",	10,	32767LL},
+		{"32768",	10,	32768LL},
+		{"32769",	10,	32769LL},
+		{"65535",	10,	65535LL},
+		{"65536",	10,	65536LL},
+		{"65537",	10,	65537LL},
+		{"2147483647",	10,	2147483647LL},
+		{"2147483648",	10,	2147483648LL},
+		{"2147483649",	10,	2147483649LL},
+		{"4294967295",	10,	4294967295LL},
+		{"4294967296",	10,	4294967296LL},
+		{"4294967297",	10,	4294967297LL},
+		{"9223372036854775807",	10,	9223372036854775807LL},
+
+		{"-1",	10,	-1LL},
+		{"-2",	10,	-2LL},
+		{"-9223372036854775808",	10,	LLONG_MIN},
+	};
+	TEST_OK(kstrtoll, long long, "%lld", test_ll_ok);
+}
+
+static void __init test_kstrtoll_fail(void)
+{
+	static DEFINE_TEST_FAIL(test_ll_fail) = {
+		{"9223372036854775808",	10},
+		{"9223372036854775809",	10},
+		{"18446744073709551614",	10},
+		{"18446744073709551615",	10},
+		{"-9223372036854775809",	10},
+		{"-18446744073709551614",	10},
+		{"-18446744073709551615",	10},
+		/* negative zero isn't an integer in Linux */
+		{"-0",	0},
+		{"-0",	8},
+		{"-0",	10},
+		{"-0",	16},
+		/* sign is first character if any */
+		{"-+1", 0},
+		{"-+1", 8},
+		{"-+1", 10},
+		{"-+1", 16},
+	};
+	TEST_FAIL(kstrtoll, long long, "%lld", test_ll_fail);
+}
+
+static void __init test_kstrtou8_ok(void)
+{
+	DECLARE_TEST_OK(u8, struct test_u8);
+	static DEFINE_TEST_OK(struct test_u8, test_u8_ok) = {
+		{"0",	10,	0},
+		{"1",	10,	1},
+		{"254",	10,	254},
+		{"255",	10,	255},
+	};
+	TEST_OK(kstrtou8, u8, "%hhu", test_u8_ok);
+}
+
+static void __init test_kstrtou8_fail(void)
+{
+	static DEFINE_TEST_FAIL(test_u8_fail) = {
+		{"-2",	10},
+		{"-1",	10},
+		{"256",	10},
+		{"257",	10},
+	};
+	TEST_FAIL(kstrtou8, u8, "%hhu", test_u8_fail);
+}
+
+static void __init test_kstrtos8_ok(void)
+{
+	DECLARE_TEST_OK(s8, struct test_s8);
+	static DEFINE_TEST_OK(struct test_s8, test_s8_ok) = {
+		{"-128",	10,	-128},
+		{"-127",	10,	-127},
+		{"-1",	10,	-1},
+		{"0",	10,	0},
+		{"1",	10,	1},
+		{"126",	10,	126},
+		{"127",	10,	127},
+	};
+	TEST_OK(kstrtos8, s8, "%hhd", test_s8_ok);
+}
+
+static void __init test_kstrtos8_fail(void)
+{
+	static DEFINE_TEST_FAIL(test_s8_fail) = {
+		{"-130",	10},
+		{"-129",	10},
+		{"128",	10},
+		{"129",	10},
+	};
+	TEST_FAIL(kstrtos8, s8, "%hhd", test_s8_fail);
+}
+
+static int __init test_kstrtox_init(void)
+{
+	test_kstrtoull_ok();
+	test_kstrtoull_fail();
+	test_kstrtoll_ok();
+	test_kstrtoll_fail();
+	test_kstrtou8_ok();
+	test_kstrtou8_fail();
+	test_kstrtos8_ok();
+	test_kstrtos8_fail();
+	return -EINVAL;
+}
+module_init(test_kstrtox_init);
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b8a2f54..43fca0a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -120,153 +120,6 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 }
 EXPORT_SYMBOL(simple_strtoll);
 
-/**
- * strict_strtoul - convert a string to an unsigned long strictly
- * @cp: The string to be converted
- * @base: The number base to use
- * @res: The converted result value
- *
- * strict_strtoul converts a string to an unsigned long only if the
- * string is really an unsigned long string, any string containing
- * any invalid char at the tail will be rejected and -EINVAL is returned,
- * only a newline char at the tail is acceptible because people generally
- * change a module parameter in the following way:
- *
- * 	echo 1024 > /sys/module/e1000/parameters/copybreak
- *
- * echo will append a newline to the tail.
- *
- * It returns 0 if conversion is successful and *res is set to the converted
- * value, otherwise it returns -EINVAL and *res is set to 0.
- *
- * simple_strtoul just ignores the successive invalid characters and
- * return the converted value of prefix part of the string.
- */
-int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
-{
-	char *tail;
-	unsigned long val;
-	size_t len;
-
-	*res = 0;
-	len = strlen(cp);
-	if (len == 0)
-		return -EINVAL;
-
-	val = simple_strtoul(cp, &tail, base);
-	if (tail == cp)
-		return -EINVAL;
-
-	if ((*tail == '\0') ||
-		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
-		*res = val;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL(strict_strtoul);
-
-/**
- * strict_strtol - convert a string to a long strictly
- * @cp: The string to be converted
- * @base: The number base to use
- * @res: The converted result value
- *
- * strict_strtol is similiar to strict_strtoul, but it allows the first
- * character of a string is '-'.
- *
- * It returns 0 if conversion is successful and *res is set to the converted
- * value, otherwise it returns -EINVAL and *res is set to 0.
- */
-int strict_strtol(const char *cp, unsigned int base, long *res)
-{
-	int ret;
-	if (*cp == '-') {
-		ret = strict_strtoul(cp + 1, base, (unsigned long *)res);
-		if (!ret)
-			*res = -(*res);
-	} else {
-		ret = strict_strtoul(cp, base, (unsigned long *)res);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(strict_strtol);
-
-/**
- * strict_strtoull - convert a string to an unsigned long long strictly
- * @cp: The string to be converted
- * @base: The number base to use
- * @res: The converted result value
- *
- * strict_strtoull converts a string to an unsigned long long only if the
- * string is really an unsigned long long string, any string containing
- * any invalid char at the tail will be rejected and -EINVAL is returned,
- * only a newline char at the tail is acceptible because people generally
- * change a module parameter in the following way:
- *
- * 	echo 1024 > /sys/module/e1000/parameters/copybreak
- *
- * echo will append a newline to the tail of the string.
- *
- * It returns 0 if conversion is successful and *res is set to the converted
- * value, otherwise it returns -EINVAL and *res is set to 0.
- *
- * simple_strtoull just ignores the successive invalid characters and
- * return the converted value of prefix part of the string.
- */
-int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res)
-{
-	char *tail;
-	unsigned long long val;
-	size_t len;
-
-	*res = 0;
-	len = strlen(cp);
-	if (len == 0)
-		return -EINVAL;
-
-	val = simple_strtoull(cp, &tail, base);
-	if (tail == cp)
-		return -EINVAL;
-	if ((*tail == '\0') ||
-		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
-		*res = val;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL(strict_strtoull);
-
-/**
- * strict_strtoll - convert a string to a long long strictly
- * @cp: The string to be converted
- * @base: The number base to use
- * @res: The converted result value
- *
- * strict_strtoll is similiar to strict_strtoull, but it allows the first
- * character of a string is '-'.
- *
- * It returns 0 if conversion is successful and *res is set to the converted
- * value, otherwise it returns -EINVAL and *res is set to 0.
- */
-int strict_strtoll(const char *cp, unsigned int base, long long *res)
-{
-	int ret;
-	if (*cp == '-') {
-		ret = strict_strtoull(cp + 1, base, (unsigned long long *)res);
-		if (!ret)
-			*res = -(*res);
-	} else {
-		ret = strict_strtoull(cp, base, (unsigned long long *)res);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(strict_strtoll);
-
 static noinline_for_stack
 int skip_atoi(const char **s)
 {
-- 
1.6.4.4

