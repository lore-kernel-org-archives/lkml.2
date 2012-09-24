Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2IXS3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:29:24 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:46625 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab2IXS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:29:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mark Salter <msalter@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
	<20120922114549.GA11610@moon>
	<20120922132046.GA4260@flint.arm.linux.org.uk>
	<20120922114723.d7f07fb6.akpm@linux-foundation.org>
	<1348503709.20929.40.camel@deneb.redhat.com>
	<20120924164942.GH16532@moon> <20120924174256.GD24172@moon>
Date: Mon, 24 Sep 2012 11:29:09 -0700
In-Reply-To: <20120924174256.GD24172@moon> (Cyrill Gorcunov's message of "Mon,
	24 Sep 2012 21:42:56 +0400")
Message-ID: <87lifzuvey.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18AGDNpH9niNvAGnVNDofirTewkHYt7s0w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: openvz.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Cyrill Gorcunov <gorcunov@openvz.org>
X-Spam-Relay-Country: 
Subject: Re: sys_kcmp
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@openvz.org> writes:

> On Mon, Sep 24, 2012 at 08:49:42PM +0400, Cyrill Gorcunov wrote:
>> > I got past that with:
>> > 
>> > diff --git a/include/linux/security.h b/include/linux/security.h
>> > index 01ef030..14e394d 100644
>> > --- a/include/linux/security.h
>> > +++ b/include/linux/security.h
>> > @@ -118,6 +118,7 @@ void reset_security_ops(void);
>> >  extern unsigned long mmap_min_addr;
>> >  extern unsigned long dac_mmap_min_addr;
>> >  #else
>> > +#define mmap_min_addr          0UL
>> >  #define dac_mmap_min_addr      0UL
>> >  #endif
>> > 
>
> I think better to add CONFIG_MMU test here.
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: prctl: prctl_set_mm -- Don't test for mmap_min_addr on non-MMU config
>
> In case if CONFIG_MMU is not set the @mmap_min_addr
> is undefined leading to build error. Thus test for
> it iif CONFIG_MMU is present.
>
> Note this code snippet depends on CONFIG_CHECKPOINT_RESTORE=y.
>
> Reported-by: Mark Salter <msalter@redhat.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  kernel/sys.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -1865,7 +1865,11 @@ static int prctl_set_mm(int opt, unsigne
>  	if (opt == PR_SET_MM_EXE_FILE)
>  		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
>  
> +#ifdef CONFIG_MMU
>  	if (addr >= TASK_SIZE || addr < mmap_min_addr)
> +#else
> +	if (addr >= TASK_SIZE)
> +#endif

I expect what you want is a call to access_ok, rather than hard coding
details about task layout here.  This test certainly looks wrong
for a 32bit process on a 64bit kernel. If I read your test right it
appears I can set values of say 0x100000000 on a 32bit process...

As for mmap_min_addr I would expect your find_vma check would make that
test unnecessary, simply by not finding a vma...

Eric

>  		return -EINVAL;
>  
>  	error = -EINVAL;
