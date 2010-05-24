Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0EXU0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0EXU0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:26:46 -0400
Date: Mon, 24 May 2010 16:26:06 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: fweisbec <fweisbec@gmail.com>, mingo <mingo@elte.hu>,
       rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       laijs <laijs@cn.fujitsu.com>, lizf <lizf@cn.fujitsu.com>,
       hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       mhiramat <mhiramat@redhat.com>,
       "heiko.carstens" <heiko.carstens@de.ibm.com>,
       benh <benh@kernel.crashing.org>, davem <davem@davemloft.net>,
       lethal <lethal@linux-sh.org>, schwidefsky <schwidefsky@de.ibm.com>,
       brueckner <brueckner@linux.vnet.ibm.com>,
       "tony.luck" <tony.luck@intel.com>
Subject: Re: [PATCH 07/14] syscalls: add ARCH_COMPAT_SYSCALL_DEFINE()
Message-ID: <20100524202606.GD2720@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com> <cbd14095e98f80fd05d3e8e76111572072e565bc.1268749695.git.jbaron@redhat.com> <1274684482-sup-7551@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274684482-sup-7551@au1.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 05:05:42PM +1000, Ian Munsie wrote:
> 
> Excerpts from Jason Baron's message of Wed Mar 17 04:46:42 +1100 2010:
> <snip>
> > +    SYSCALL_METADATA(syscall, compat_sys_##sname, x);    \
> > +    asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
> > +#else
> > +#define COMPAT_SYSCALL_DEFINEx(x, sname, ...)            \
> 
> I think that should be:
> #define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)
> 
> To avoid breaking archs without compat syscalls.
> 
> Cheers,
> -Ian

yes. good catch. I had spotted this as well. here's the complete re-spun
patch. 

thanks,

-Jason


diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e601985..b5f66dc 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -141,7 +141,7 @@ struct perf_event_attr;
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
-		.name                   = "sys_enter"#sname,		\
+		.name                   = "enter_"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
@@ -163,7 +163,7 @@ struct perf_event_attr;
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
-		.name                   = "sys_exit"#sname,		\
+		.name                   = "exit_"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
@@ -174,14 +174,14 @@ struct perf_event_attr;
 		TRACE_SYS_EXIT_PROFILE_INIT(sname)			\
 	}
 
-#define SYSCALL_METADATA(sname, nb)				\
+#define SYSCALL_METADATA(rname, sname, nb)			\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
-		.name 		= "sys"#sname,			\
+		.name 		= #rname,			\
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
@@ -194,20 +194,20 @@ struct perf_event_attr;
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
-	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
+	SYSCALL_TRACE_ENTER_EVENT(sys_##sname);			\
+	SYSCALL_TRACE_EXIT_EVENT(sys_##sname);			\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	  __syscall_meta__##sname = {				\
+	  __syscall_meta_sys_##sname = {			\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
 		.ftrace_enter	= 0,				\
 		.ftrace_exit	= 0,				\
 		.perf_enter	= 0,				\
 		.perf_exit	= 0,				\
-		.enter_event	= &event_enter__##sname,	\
-		.exit_event	= &event_exit__##sname,		\
+		.enter_event	= &event_enter_sys_##sname,	\
+		.exit_event	= &event_exit_sys_##sname,	\
 	};							\
 	asmlinkage long sys_##sname(void)
 #else
@@ -221,6 +221,32 @@ struct perf_event_attr;
 #define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
+#ifdef CONFIG_COMPAT
+
+#define ARCH_COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, sys32_##name, name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, sys32_##name, name, __VA_ARGS__)
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)		\
+	static const char *types_compat_sys_##sname[] = {	\
+		__SC_STR_TDECL##x(__VA_ARGS__)			\
+	};							\
+	static const char *args_compat_sys_##sname[] = {	\
+		__SC_STR_ADECL##x(__VA_ARGS__)			\
+	};							\
+	SYSCALL_METADATA(syscall, compat_sys_##sname, x);	\
+	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
+#else
+#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)		\
+	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
+#endif
+
+#endif
+
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
 	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name "\n"	\
@@ -237,13 +263,13 @@ struct perf_event_attr;
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define SYSCALL_DEFINEx(x, sname, ...)				\
-	static const char *types_##sname[] = {			\
+	static const char *types_sys##sname[] = {		\
 		__SC_STR_TDECL##x(__VA_ARGS__)			\
 	};							\
-	static const char *args_##sname[] = {			\
+	static const char *args_sys##sname[] = {		\
 		__SC_STR_ADECL##x(__VA_ARGS__)			\
 	};							\
-	SYSCALL_METADATA(sname, x);				\
+	SYSCALL_METADATA(sys##sname, sys##sname, x);		\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 #else
 #define SYSCALL_DEFINEx(x, sname, ...)				\
