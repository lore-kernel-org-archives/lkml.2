Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2L1KYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 05:24:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10661 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2L1KYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 05:24:13 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=200/3=5D=20signalfd=3A=20a=20kernel=20interface=20for=20dumping/restoring=20pending=20signals=20=28v2=29?=
Date: Fri, 28 Dec 2012 14:22:58 +0400
Message-Id: <1356690181-1796-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is simple. We need to get the siginfo for each signal on dump,
and then return it back on restore.

The first problem is that the kernel doesn’t report complete siginfo-s
in user-space. In a signal handler the kernel strips SI_CODE from
siginfo. When a siginfo is received from signalfd, it has a different
format with fixed sizes of fields. The interface of signalfd was
extended. If a signalfd is created with the flag SFD_RAW, it returns
siginfo in a raw format.

rt_sigqueueinfo looks suitable for restoring signals, but it can’t send
siginfo with a positive si_code, because these codes are reserved for
the kernel. In the real world each person has right to do anything with
himself, so I think a process should able to send any siginfo to itself.

v2: add ability to dump signals without dequeuing them.
    pread with non-zero offset is used for this. offset encodes
    a queue (private of shared) and a sequence number of a signal
    in the queue. Thanks to Oleg for this idea.

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>

-- 
1.7.11.7

