Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1BDM7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:59:00 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56657 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1BDM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:58:57 -0500
X-AuditID: b753bd60-a32b8ba000004916-65-4d4bf80e8061
X-AuditID: b753bd60-a32b8ba000004916-65-4d4bf80e8061
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core  3/4] tracing/kprobes: Add bitfield type
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 04 Feb 2011 21:52:05 +0900
Message-ID: <20110204125205.9507.11363.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110204125145.9507.5169.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110204125145.9507.5169.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bitfield type for tracing arguments on kprobe-tracer.
The syntax of a bitfield type is;

 b<bit-size>@<bit-offset>/<container-size>

e.g.
 Accessing 2 bits-width field with 4 bits-offset in
32 bits-width data at 4 bytes offseted from the address
pointed by AX register,

 +4(%ax):b2@4/32

Since the width of container data depends on the arch,
so I just added the container-size at the end.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 Documentation/trace/kprobetrace.txt |   16 +++++
 kernel/trace/trace_kprobe.c         |  104 +++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 5f77d94..52303af 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -42,11 +42,25 @@ Synopsis of kprobe_events
   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(**)
   NAME=FETCHARG : Set NAME as the argument name of FETCHARG.
   FETCHARG:TYPE : Set TYPE as the type of FETCHARG. Currently, basic types
-		  (u8/u16/u32/u64/s8/s16/s32/s64) and string are supported.
+		  (u8/u16/u32/u64/s8/s16/s32/s64), "string" and bitfield
+		  are supported.
 
   (*) only for return probe.
   (**) this is useful for fetching a field of data structures.
 
+Types
+-----
+Several types are supported for fetch-args. Kprobe tracer will access memory
+by given type. Prefix 's' and 'u' means those types are singed and unsigned
+respectively. Traced arguments are shown in decimal (signed) or hex (unsigned).
+String type is a special type, which fetches a "null-terminated" string from
+kernel space. This means it will fail and store NULL if the string container
+has been paged out.
+Bitfield is another special type, which takes 3 parameters, bit-width, bit-
+offset, and container-size (usually 32). The syntax is;
+
+ b<bit-width>@<bit-offset>/<container-size>
+
 
 Per-Probe Event Filtering
 -------------------------
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c6ed886..ccdc542 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -353,6 +353,43 @@ static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 	kfree(data);
 }
 
+/* Bitfield fetch function */
+struct bitfield_fetch_param {
+	struct fetch_param orig;
+	unsigned char hi_shift;
+	unsigned char low_shift;
+};
+
+#define DEFINE_FETCH_bitfield(type)					\
+static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
+					    void *data, void *dest)	\
+{									\
+	struct bitfield_fetch_param *bprm = data;			\
+	type buf = 0;							\
+	call_fetch(&bprm->orig, regs, &buf);				\
+	if (buf) {							\
+		buf <<= bprm->hi_shift;					\
+		buf >>= bprm->low_shift;				\
+	}								\
+	*(type *)dest = buf;						\
+}
+DEFINE_BASIC_FETCH_FUNCS(bitfield)
+#define fetch_bitfield_string NULL
+#define fetch_bitfield_string_size NULL
+
+static __kprobes void
+free_bitfield_fetch_param(struct bitfield_fetch_param *data)
+{
+	/*
+	 * Don't check the bitfield itself, because this must be the
+	 * last fetch function.
+	 */
+	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
+		free_deref_fetch_param(data->orig.data);
+	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
+		free_symbol_cache(data->orig.data);
+	kfree(data);
+}
 /* Default (unsigned long) fetch type */
 #define __DEFAULT_FETCH_TYPE(t) u##t
 #define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
@@ -367,6 +404,7 @@ enum {
 	FETCH_MTD_memory,
 	FETCH_MTD_symbol,
 	FETCH_MTD_deref,
+	FETCH_MTD_bitfield,
 	FETCH_MTD_END,
 };
 
@@ -387,6 +425,7 @@ ASSIGN_FETCH_FUNC(retval, ftype),			\
 ASSIGN_FETCH_FUNC(memory, ftype),			\
 ASSIGN_FETCH_FUNC(symbol, ftype),			\
 ASSIGN_FETCH_FUNC(deref, ftype),			\
+ASSIGN_FETCH_FUNC(bitfield, ftype),			\
 	  }						\
 	}
 
@@ -430,9 +469,33 @@ static const struct fetch_type *find_fetch_type(const char *type)
 	if (!type)
 		type = DEFAULT_FETCH_TYPE_STR;
 
+	/* Special case: bitfield */
+	if (*type == 'b') {
+		unsigned long bs;
+		type = strchr(type, '/');
+		if (!type)
+			goto fail;
+		type++;
+		if (strict_strtoul(type, 0, &bs))
+			goto fail;
+		switch (bs) {
+		case 8:
+			return find_fetch_type("u8");
+		case 16:
+			return find_fetch_type("u16");
+		case 32:
+			return find_fetch_type("u32");
+		case 64:
+			return find_fetch_type("u64");
+		default:
+			goto fail;
+		}
+	}
+
 	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
 		if (strcmp(type, fetch_type_table[i].name) == 0)
 			return &fetch_type_table[i];
+fail:
 	return NULL;
 }
 
@@ -586,7 +649,9 @@ error:
 
 static void free_probe_arg(struct probe_arg *arg)
 {
-	if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
+	if (CHECK_FETCH_FUNCS(bitfield, arg->fetch.fn))
+		free_bitfield_fetch_param(arg->fetch.data);
+	else if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
 		free_deref_fetch_param(arg->fetch.data);
 	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
 		free_symbol_cache(arg->fetch.data);
@@ -806,6 +871,41 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 	return ret;
 }
 
+#define BYTES_TO_BITS(nb)	((BITS_PER_LONG * (nb)) / sizeof(long))
+
+/* Bitfield type needs to be parsed into a fetch function */
+static int __parse_bitfield_probe_arg(const char *bf,
+				      const struct fetch_type *t,
+				      struct fetch_param *f)
+{
+	struct bitfield_fetch_param *bprm;
+	unsigned long bw, bo;
+	char *tail;
+
+	if (*bf != 'b')
+		return 0;
+
+	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
+	if (!bprm)
+		return -ENOMEM;
+	bprm->orig = *f;
+	f->fn = t->fetch[FETCH_MTD_bitfield];
+	f->data = (void *)bprm;
+
+	bw = simple_strtoul(bf + 1, &tail, 0);	/* Use simple one */
+	if (bw == 0 || *tail != '@')
+		return -EINVAL;
+
+	bf = tail + 1;
+	bo = simple_strtoul(bf, &tail, 0);
+	if (tail == bf || *tail != '/')
+		return -EINVAL;
+
+	bprm->hi_shift = BYTES_TO_BITS(t->size) - (bw + bo);
+	bprm->low_shift = bprm->hi_shift + bo;
+	return (BYTES_TO_BITS(t->size) < (bw + bo)) ? -EINVAL : 0;
+}
+
 /* String length checking wrapper */
 static int parse_probe_arg(char *arg, struct trace_probe *tp,
 			   struct probe_arg *parg, int is_return)
@@ -835,6 +935,8 @@ static int parse_probe_arg(char *arg, struct trace_probe *tp,
 	parg->offset = tp->size;
 	tp->size += parg->type->size;
 	ret = __parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
+	if (ret >= 0)
+		ret = __parse_bitfield_probe_arg(t, parg->type, &parg->fetch);
 	if (ret >= 0) {
 		parg->fetch_size.fn = get_fetch_size_function(parg->type,
 							      parg->fetch.fn);

