Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0GGRLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab0GGRLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:11:18 -0400
Date: Wed, 7 Jul 2010 19:11:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eric.dumazet@gmail.com,
       oleg@redhat.com
Subject: Re: [PATCH] time/fs - file's time race with vgettimeofday
Message-ID: <20100707171103.GB20533@jolsa.brq.redhat.com>
References: <1278056519-5008-1-git-send-email-jolsa@redhat.com>
 <AANLkTilE3sd7SSLVCN87rpJ5iSm-sYd-n6nJnzlByfRK@mail.gmail.com>
 <1278457900.1715.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278457900.1715.9.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 04:11:40PM -0700, john stultz wrote:
> On Tue, 2010-07-06 at 16:03 -0700, john stultz wrote:
> > On Fri, Jul 2, 2010 at 12:41 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > > This issue was described in the BZ 244697
> > >
> > >        Time goes backward - gettimeofday() vs. rename()
> > >        https://bugzilla.redhat.com/show_bug.cgi?id=244697
> > >
> > >
> > > It's not just issue of the creat but few others like rename.
> > >
> > >
> > > The following patch will prevent the race by adding the
> > > CURRENT_TIME_SEC_REAL macro, which will return seconds from
> > > the getnstimeofday call, ensuring it's computed on current tick.
> > > It fixes the 'creat' case for ext4.
> > >
> > >
> > > I'm not sure how much trouble is having this race unfixed compared
> > > to the performance impact the fix might have. Maybe there're
> > > better ways to fix this.
> > 
> > I do worry that your patch will have too much of a performance hit. I
> > think the right fix would be in vtime().
> > 
> > Test patch to follow shortly.
> 
> So the following (untested) patch _should_ resolve this in mainline on
> x86. Please let me know if it works for you.
> 
> However, for older kernels, this patch won't be sufficient, as it
> depends on update_vsyscall getting the time at the last tick in its
> wall_time, and kernels that don't have the logarithmic accumulation code
> & remove xtime_cache patches can't be fixed so easily. 
> 
> Once we get this upstream, let me know if you have any questions about
> how to backport this to older kernels.
> 
> thanks
> -john
> 
> 
> 
> [PATCH] x86: Fix vtime/file timestamp inconsistencies
> 
> Due to vtime calling vgettimeofday(), its possible that an application
> could call  time();create("stuff",O_RDRW);  only to see the file's
> creation timestamp to be before the value returned by time.
> 
> The proper fix is to make vtime use the same time value as
> current_kernel_time() (which is exported via update_vsyscall) instead of
> vgettime().
> 
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> 
> 
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 1c0c6ab..ce9a4fa 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -169,13 +169,18 @@ int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
>   * unlikely */
>  time_t __vsyscall(1) vtime(time_t *t)
>  {
> -	struct timeval tv;
> +	unsigned seq;
>  	time_t result;
>  	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
>  		return time_syscall(t);
>  
> -	vgettimeofday(&tv, NULL);
> -	result = tv.tv_sec;
> +	do {
> +		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
> +
> +		result = vsyscall_gtod_data.wall_time_sec;
> +
> +	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
> +
>  	if (t)
>  		*t = result;
>  	return result;
> 
> 

I think there's a typo in using "vsyscall_gtod_data" inside
the vtime call it should be "__vsyscall_gtod_data" intead.

attaching changed patch

wbr,
jirka

---
[PATCH] x86: Fix vtime/file timestamp inconsistencies

Due to vtime calling vgettimeofday(), its possible that an application
could call  time();create("stuff",O_RDRW);  only to see the file's
creation timestamp to be before the value returned by time.

The proper fix is to make vtime use the same time value as
current_kernel_time() (which is exported via update_vsyscall) instead of
vgettime().


Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1c0c6ab..dce0c3c 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -169,13 +169,18 @@ int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
-	struct timeval tv;
+	unsigned seq;
 	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
 
-	vgettimeofday(&tv, NULL);
-	result = tv.tv_sec;
+	do {
+		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
+
+		result = __vsyscall_gtod_data.wall_time_sec;
+
+	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
+
 	if (t)
 		*t = result;
 	return result;
