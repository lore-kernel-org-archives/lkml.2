Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2BNMhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 07:37:01 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46448 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2BNMg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 07:36:59 -0500
X-AuditID: b753bd60-a2688ba000000655-19-4f3a55682d98
X-AuditID: b753bd60-a2688ba000000655-19-4f3a55682d98
Message-ID: <4F3A5564.1080607@hitachi.com>
Date: Tue, 14 Feb 2012 21:36:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, akpm@linux-foundation.org,
        jbaron@redhat.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Return proper error code from register_kprobe()
References: <4F3A3D30.5010506@linux.vnet.ibm.com>
In-Reply-To: <4F3A3D30.5010506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/14 19:53), Prashanth Nageshappa wrote:
> register_kprobe() aborts if the address of the new request falls in a prohibited
> area (such as ftrace pouch, __kprobes annotated functions, non-kernel text
> addresses, jump label text). We however don't return the right error on this
> abort, resulting in incorrect adding/reporting of kprobes (Ex: 'perf probe
> do_fork+18' or 'perf probe mcount')

OK, I see.

> 
> This patch fixes it by returning -EINVAL upon failure.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Prashanth K Nageshappa<prashanth@linux.vnet.ibm.com>

However, I can't agree with this change :(, because this
ignores possibilities of -ENOENT error code in other error
paths.

What I'm expecting is, setup an error code where the error
occurs, as below;

        jump_label_lock();
        preempt_disable();
        if (!kernel_text_address((unsigned long) p->addr) ||
            in_kprobes_functions((unsigned long) p->addr) ||
            ftrace_text_reserved(p->addr, p->addr) ||
-           jump_label_text_reserved(p->addr, p->addr))
+           jump_label_text_reserved(p->addr, p->addr)) {
+		ret = -EINVAL;
                goto fail_with_jump_label;
+	}

IMHO, we should change the label name too...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
