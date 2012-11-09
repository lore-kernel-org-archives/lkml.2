Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2KIQos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:44:48 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50239 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2KIQop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:44:45 -0500
Date: Sat, 10 Nov 2012 00:44:27 +0800
From: Tekkaman Ninja <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>,
        Dongsheng Song <dongsheng.song@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2]Documentation: Chinese translation of
 Documentation/arm/kernel_user_helpers.txt
Message-ID: <20121109164426.GA3799@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a Chinese translated version of
Documentation/arm/kernel_user_helpers.txt

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

---
 Documentation/zh_CN/arm/kernel_user_helpers.txt |  284 +++++++++++++++++++++++
 1 file changed, 284 insertions(+)
 create mode 100644 Documentation/zh_CN/arm/kernel_user_helpers.txt

diff --git a/Documentation/zh_CN/arm/kernel_user_helpers.txt b/Documentation/zh_CN/arm/kernel_user_helpers.txt
new file mode 100644
index 0000000..2b6c03c
--- /dev/null
+++ b/Documentation/zh_CN/arm/kernel_user_helpers.txt
@@ -0,0 +1,284 @@
+Chinese translated version of Documentation/arm/kernel_user_helpers.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Maintainer: Nicolas Pitre <nicolas.pitre@linaro.org>
+		Dave Martin <dave.martin@linaro.org>
+Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
+---------------------------------------------------------------------
+Documentation/arm/kernel_user_helpers.txt 的中文翻译
+
+如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
+交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
+译存在问题，请联系中文版维护者。
+英文版维护者： Nicolas Pitre <nicolas.pitre@linaro.org>
+		Dave Martin <dave.martin@linaro.org>
+中文版维护者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
+中文版翻译者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
+中文版校译者： 宋冬生 Dongsheng Song <dongshneg.song@gmail.com>
+		傅炜 Fu Wei <tekkamanninja@gmail.com>
+
+
+以下为正文
+---------------------------------------------------------------------
+内核提供的用户空间辅助代码
+======================
+
+在内核内存空间的固定地址处，有一个由内核提供并可从用户空间访问的代码
+段。它用于向用户空间提供因在许多 ARM CPU 中未实现的特性和/或指令而需
+内核提供帮助的某些操作。这些代码直接在用户模式下执行的想法是为了获得
+最佳效率，但那些与内核计数器联系过于紧密的部分，则被留给了用户库实现。
+事实上，此代码甚至可能因不同的 CPU 而异，这取决于其可用的指令集或它
+是否为 SMP 系统。换句话说，内核保留在不作出警告的情况下根据需要更改
+这些代码的权利。只有本文档描述的入口及其结果是保证稳定的。
+
+这与完全成熟的 VDSO 实现不同（但两者并不冲突），尽管如此，VDSO 可阻止
+某些通过常量高效跳转到那些代码段的汇编技巧。且由于那些代码段在返回用户
+代码前仅使用少量的代码周期，则一个 VDSO 间接远程调用将会在这些简单的
+操作上增加一个可测量的开销。
+
+在对那些拥有原生支持的新型处理器进行代码优化时，用户空间最好绕过这些
+辅助代码，并在内联函数中实现这些操作（无论是通过编译器在代码中直接放置，
+还是作为库函数调用实现的一部分）；仅有在为了其他操作使用了同类原生指令，
+导致二进制结果已与早期 ARM 处理不兼容的情况下，才使用这些辅助代码。
+换句话说，如果为了别的目的，你编译的代码将不能使用新的指令，则不能仅
+为了避免使用这些内核辅助代码而导致二进制程序无法在早期处理器上运行。
+
+新的辅助代码可能随着时间的推移而增加，所以新内核中的某些辅助代码在旧
+内核中可能不存在。因此，程序必须在对任何辅助代码调用假设是安全之前，
+检测 __kuser_helper_version 的值（见下文）。理想情况下，这种检测应该
+只在进程启动时执行一次；如果内核版本不支持所需辅助代码，则该进程可尽早
+中止执行。
+
+kuser_helper_version
+--------------------
+
+位置:	0xffff0ffc
+
+参考声明:
+
+  extern int32_t __kuser_helper_version;
+
+定义:
+
+  这个区域包含了当前运行内核实现的辅助代码版本号。用户空间可以通过读
+  取此版本号以确定特定的辅助代码是否存在。
+
+使用范例:
+
+#define __kuser_helper_version (*(int32_t *)0xffff0ffc)
+
+void check_kuser_version(void)
+{
+	if (__kuser_helper_version < 2) {
+		fprintf(stderr, "can't do atomic operations, kernel too old\n");
+		abort();
+	}
+}
+
+注意:
+
+  用户空间可以假设这个域的值不会在任何单个进程的生存期内改变。也就
+  是说，这个域可以仅在库的初始化阶段或进程启动阶段读取一次。
+
+kuser_get_tls
+-------------
+
+位置:	0xffff0fe0
+
+参考原型:
+
+  void * __kuser_get_tls(void);
+
+输入:
+
+  lr = 返回地址
+
+输出:
+
+  r0 = TLS 值
+
+被篡改的寄存器:
+
+  无
+
+定义:
+
+  获取之前通过 __ARM_NR_set_tls 系统调用设置的 TLS 值。
+
+使用范例:
+
+typedef void * (__kuser_get_tls_t)(void);
+#define __kuser_get_tls (*(__kuser_get_tls_t *)0xffff0fe0)
+
+void foo()
+{
+	void *tls = __kuser_get_tls();
+	printf("TLS = %p\n", tls);
+}
+
+注意:
+
+  - 仅在 __kuser_helper_version >= 1 时，此辅助代码存在
+    （从内核版本 2.6.12 开始）。
+
+kuser_cmpxchg
+-------------
+
+位置:	0xffff0fc0
+
+参考原型:
+
+  int __kuser_cmpxchg(int32_t oldval, int32_t newval, volatile int32_t *ptr);
+
+输入:
+
+  r0 = oldval
+  r1 = newval
+  r2 = ptr
+  lr = 返回地址
+
+输出:
+
+  r0 = 成功代码 (零或非零)
+  C flag = 如果 r0 == 0 则置 1，如果 r0 != 0 则清零。
+
+被篡改的寄存器:
+
+  r3, ip, flags
+
+定义:
+
+  仅在 *ptr 为 oldval 时原子保存 newval 于 *ptr 中。
+  如果 *ptr 被改变，则返回值为零，否则为非零值。
+  如果 *ptr 被改变，则 C flag 也会被置 1，以实现调用代码中的汇编
+  优化。
+
+使用范例:
+
+typedef int (__kuser_cmpxchg_t)(int oldval, int newval, volatile int *ptr);
+#define __kuser_cmpxchg (*(__kuser_cmpxchg_t *)0xffff0fc0)
+
+int atomic_add(volatile int *ptr, int val)
+{
+	int old, new;
+
+	do {
+		old = *ptr;
+		new = old + val;
+	} while(__kuser_cmpxchg(old, new, ptr));
+
+	return new;
+}
+
+注意:
+
+  - 这个例程已根据需要包含了内存屏障。
+
+  - 仅在 __kuser_helper_version >= 2 时，此辅助代码存在
+    （从内核版本 2.6.12 开始）。
+
+kuser_memory_barrier
+--------------------
+
+位置:	0xffff0fa0
+
+参考原型:
+
+  void __kuser_memory_barrier(void);
+
+输入:
+
+  lr = 返回地址
+
+输出:
+
+  无
+
+被篡改的寄存器:
+
+  无
+
+定义:
+
+  应用于任何需要内存屏障以防止手动数据修改带来的一致性问题，以及
+  __kuser_cmpxchg 中。
+
+使用范例:
+
+typedef void (__kuser_dmb_t)(void);
+#define __kuser_dmb (*(__kuser_dmb_t *)0xffff0fa0)
+
+注意:
+
+  - 仅在 __kuser_helper_version >= 3 时，此辅助代码存在
+    （从内核版本 2.6.15 开始）。
+
+kuser_cmpxchg64
+---------------
+
+位置:	0xffff0f60
+
+参考原型:
+
+  int __kuser_cmpxchg64(const int64_t *oldval,
+                        const int64_t *newval,
+                        volatile int64_t *ptr);
+
+输入:
+
+  r0 = 指向 oldval
+  r1 = 指向 newval
+  r2 = 指向目标值
+  lr = 返回地址
+
+输出:
+
+  r0 = 成功代码 (零或非零)
+  C flag = 如果 r0 == 0 则置 1，如果 r0 != 0 则清零。
+
+被篡改的寄存器:
+
+  r3, lr, flags
+
+定义:
+
+  仅在 *ptr 等于 *oldval 指向的 64 位值时，原子保存 *newval
+  指向的 64 位值于 *ptr 中。如果 *ptr 被改变，则返回值为零，
+  否则为非零值。
+
+  如果 *ptr 被改变，则 C flag 也会被置 1，以实现调用代码中的汇编
+  优化。
+
+使用范例:
+
+typedef int (__kuser_cmpxchg64_t)(const int64_t *oldval,
+                                  const int64_t *newval,
+                                  volatile int64_t *ptr);
+#define __kuser_cmpxchg64 (*(__kuser_cmpxchg64_t *)0xffff0f60)
+
+int64_t atomic_add64(volatile int64_t *ptr, int64_t val)
+{
+	int64_t old, new;
+
+	do {
+		old = *ptr;
+		new = old + val;
+	} while(__kuser_cmpxchg64(&old, &new, ptr));
+
+	return new;
+}
+
+注意:
+
+  - 这个例程已根据需要包含了内存屏障。
+
+  - 由于这个过程的代码长度（此辅助代码跨越 2 个常规的 kuser “槽”），
+    因此 0xffff0f80 不被作为有效的入口点。
+
+  - 仅在 __kuser_helper_version >= 5 时，此辅助代码存在
+    （从内核版本 3.1 开始）。
-- 
1.7.9.5

