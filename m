Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab1CXQDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:03:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26282 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934039Ab1CXQCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:02:55 -0400
Date: Thu, 24 Mar 2011 09:02:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Harkes <jaharkes@cs.cmu.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [origin tree build failure] Re: [PATCH] fs, coda: Fix compile
 warning when CONFIG_SYSCTL=n.
Message-Id: <20110324090204.470d1f96.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTinMbYte_Atmgqn2bfowWOMWNV3TiAFgoOMTPg2G@mail.gmail.com>
References: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
	<20110324075413.GA25830@elte.hu>
	<AANLkTinMbYte_Atmgqn2bfowWOMWNV3TiAFgoOMTPg2G@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D8B6B02.010F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 16:46:15 +0600 Rakib Mullick wrote:

> On Thu, Mar 24, 2011 at 1:54 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Rakib Mullick <rakib.mullick@gmail.com> wrote:
> >
> >> When CONFIG_SYSCTL=n, we get the following warning:
> >>
> >> fs/coda/sysctl.c:18: warning: ‘coda_table’ defined but not used
> >>
> >> Following patches fixes the above warning by making sure coda_table
> >> and it's callee
> >> function are in the same context. It also cleans up the code by
> >> removing extra #ifdef.
> >>
> >>
> >> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> >> ---
> >>
> >> diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
> >> index c6405ce..d9cc2b3 100644
> >> --- a/fs/coda/sysctl.c
> >> +++ b/fs/coda/sysctl.c
> >
> > FYI, the v2 of this patch:
> >
> >  0bc825d240ab: codafs: fix compile warning when CONFIG_SYSCTL=n
> >
> > broke the upstream build:
> >
> >  fs/built-in.o: In function `init_coda':
> >  psdev.c:(.init.text+0x2549): undefined reference to `coda_sysctl_clean'
> >  fs/built-in.o: In function `exit_coda':
> >  psdev.c:(.exit.text+0x1bf): undefined reference to `coda_sysctl_clean'
> >  fs/built-in.o: In function `init_coda_psdev':
> >  psdev.c:(.text.unlikely+0x21e1): undefined reference to `coda_sysctl_init'
> >
> > I don't think the -v2 commit was build-tested with !CONFIG_PROC_SYSCTL &&
> > CONFIG_CODA_FS=y.
> >
> Andrew cleans up the unnecessary stubs. But, clearly removed
> definition is necessary. And Yes, you are right, I didn't build test
> it. Sorry for that. Please consider the following patch.
> 
> ---
> codafs: Fix build break when CONFIG_PROC_SYSCTL=n
> 
> Commit 0bc825d240ab (codafs: fix compile warning when
> CONFIG_SYSCTL=n), introduces build breakage, when CONFIG_PROC_SYSCTL=n
> and CONFIG_CODA_FS=y. This patch fixes it.
> 
> fs/built-in.o: In function `init_coda':
> psdev.c:(.init.text+0xc02): undefined reference to `coda_sysctl_init'
> psdev.c:(.init.text+0xc7c): undefined reference to `coda_sysctl_clean'
> fs/built-in.o: In function `exit_coda':
> psdev.c:(.exit.text+0xa9): undefined reference to `coda_sysctl_clean'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> Reported-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> 
> diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
> index 06d27a4..af56ad5 100644
> --- a/fs/coda/sysctl.c
> +++ b/fs/coda/sysctl.c
> @@ -61,4 +61,13 @@ void coda_sysctl_clean(void)
>  		fs_table_header = NULL;
>  	}
>  }
> +
> +#else
> +void coda_sysctl_init(void)
> +{
> +}
> +
> +void coda_sysctl_clean(void)
> +{
> +}
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
