Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1CXKqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:46:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38266 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1CXKqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xwOlUyITOtvlqpvBC0ZPJBFbHDEKRS8u01tCfGuEIbEn5l3N4PJEzAbpeKl8z8mv8n
         8etflUMCbcChtwytUVCzQBuLxhqt/IqGvPWTcSpA382ybesRJJu7tBiu5YpKUzqd3bPF
         bssoSk/0CVCbYY8O/GR5BblToslLnfIjLoIWY=
MIME-Version: 1.0
In-Reply-To: <20110324075413.GA25830@elte.hu>
References: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
	<20110324075413.GA25830@elte.hu>
Date: Thu, 24 Mar 2011 16:46:15 +0600
Message-ID: <AANLkTinMbYte_Atmgqn2bfowWOMWNV3TiAFgoOMTPg2G@mail.gmail.com>
Subject: Re: [origin tree build failure] Re: [PATCH] fs, coda: Fix compile
 warning when CONFIG_SYSCTL=n.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 1:54 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>> When CONFIG_SYSCTL=n, we get the following warning:
>>
>> fs/coda/sysctl.c:18: warning: ‘coda_table’ defined but not used
>>
>> Following patches fixes the above warning by making sure coda_table
>> and it's callee
>> function are in the same context. It also cleans up the code by
>> removing extra #ifdef.
>>
>>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>> ---
>>
>> diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
>> index c6405ce..d9cc2b3 100644
>> --- a/fs/coda/sysctl.c
>> +++ b/fs/coda/sysctl.c
>
> FYI, the v2 of this patch:
>
>  0bc825d240ab: codafs: fix compile warning when CONFIG_SYSCTL=n
>
> broke the upstream build:
>
>  fs/built-in.o: In function `init_coda':
>  psdev.c:(.init.text+0x2549): undefined reference to `coda_sysctl_clean'
>  fs/built-in.o: In function `exit_coda':
>  psdev.c:(.exit.text+0x1bf): undefined reference to `coda_sysctl_clean'
>  fs/built-in.o: In function `init_coda_psdev':
>  psdev.c:(.text.unlikely+0x21e1): undefined reference to `coda_sysctl_init'
>
> I don't think the -v2 commit was build-tested with !CONFIG_PROC_SYSCTL &&
> CONFIG_CODA_FS=y.
>
Andrew cleans up the unnecessary stubs. But, clearly removed
definition is necessary. And Yes, you are right, I didn't build test
it. Sorry for that. Please consider the following patch.

---
codafs: Fix build break when CONFIG_PROC_SYSCTL=n

Commit 0bc825d240ab (codafs: fix compile warning when
CONFIG_SYSCTL=n), introduces build breakage, when CONFIG_PROC_SYSCTL=n
and CONFIG_CODA_FS=y. This patch fixes it.

fs/built-in.o: In function `init_coda':
psdev.c:(.init.text+0xc02): undefined reference to `coda_sysctl_init'
psdev.c:(.init.text+0xc7c): undefined reference to `coda_sysctl_clean'
fs/built-in.o: In function `exit_coda':
psdev.c:(.exit.text+0xa9): undefined reference to `coda_sysctl_clean'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
---

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index 06d27a4..af56ad5 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -61,4 +61,13 @@ void coda_sysctl_clean(void)
 		fs_table_header = NULL;
 	}
 }
+
+#else
+void coda_sysctl_init(void)
+{
+}
+
+void coda_sysctl_clean(void)
+{
+}
 #endif
